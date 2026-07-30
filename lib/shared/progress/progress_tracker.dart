import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'auth/auth_repository.dart';
import 'data/firebase_data_sources.dart';
import 'data/local_progress_repository.dart';
import 'data/progress_database.dart';
import 'progress_snapshot.dart';
import 'sync/progress_sync_coordinator.dart';

class ProgressTracker extends ChangeNotifier {
  ProgressTracker._();

  static final ProgressTracker instance = ProgressTracker._();

  final ProgressDatabase _db = ProgressDatabase.instance;
  late final LocalProgressRepository _local;
  late final AuthRepository _authRepository;
  late final ProgressSyncCoordinator _syncCoordinator;

  ProgressSnapshot _snapshot = ProgressSnapshot.empty();
  String _userName = '';
  String _userId = '';
  String? _firebaseUid;
  String _authState = 'pending';
  bool _initialized = false;
  int _pendingEventCount = 0;
  DateTime? _lastSyncedUtc;
  String? _lastSyncError;
  String? _activeQuizAttemptId;
  String? _activeGameSessionId;
  Timer? _inactivityTimer;

  ProgressSnapshot get snapshot => _snapshot;
  String get userName => _userName;
  String get userId => _userId;
  bool get hasIdentity => _userName.isNotEmpty && _userId.isNotEmpty;
  bool get needsPinSetup => _authState == 'needs_pin';
  bool get isSyncing => _initialized && _syncCoordinator.isRunning;
  int get pendingEventCount => _pendingEventCount;
  bool get hasPendingBackup => _pendingEventCount > 0;
  DateTime? get lastSyncedUtc => _lastSyncedUtc;
  String? get lastSyncError => _lastSyncError;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    _local = LocalProgressRepository(_db);
    await _local.initialize();

    FirebaseAuth? auth;
    FirebaseProgressDataSource? remote;
    try {
      await Firebase.initializeApp();
      auth = FirebaseAuth.instance;
      remote = FirebaseProgressDataSource(FirebaseFirestore.instance);
    } catch (error) {
      _log('firebase_unavailable', {'error': error.runtimeType.toString()});
    }

    _authRepository = FirebaseAuthRepository(
      database: _db,
      installationId: _local.installationId,
      firebaseAuth: auth,
      studentRemote: remote,
      progressRemote: remote,
    );
    _syncCoordinator = ProgressSyncCoordinator(
      database: _db,
      local: _local,
      remote: remote,
      uidProvider: () => _firebaseUid,
    )..onStatusChanged = () => unawaited(_refresh());
    _syncCoordinator.startConnectivityMonitoring();
    await _refresh();
    unawaited(_authRepository.completePendingRegistration().then((_) async {
      await _refresh();
      _syncCoordinator.schedule();
    }));
  }

  Future<AuthResult> createStudent({required String name, required String pin}) async {
    await _local.ensureProfile(name);
    final result = await _authRepository.createStudent(name, pin);
    await _refresh();
    if (result.success) _syncCoordinator.schedule();
    if (result.success && !result.message.contains(_userId)) {
      return AuthResult(
        success: true,
        message: 'ID Pelajar anda ialah $_userId. ${result.message}',
      );
    }
    return result;
  }

  Future<void> setUserName(String name) async {
    if (name.trim().isEmpty) return;
    await _local.ensureProfile(name);
    await _refresh();
  }

  Future<AuthResult> restoreFromStudentId(String studentId, String pin) async {
    final result = await _authRepository.recover(studentId, pin);
    await _refresh();
    if (result.success) _syncCoordinator.schedule();
    return result;
  }

  Future<void> clearUserIdentity({bool clearProgress = false}) async {
    await _authRepository.signOut();
    if (clearProgress) await _local.clearLocalData();
    await _refresh();
  }

  Future<void> updateOnboardingStep({required int reachedStep, required int totalSteps}) =>
      _updateLessonRange(reachedStep: reachedStep, previous: _snapshot.onboardingReached, start: 1);

  Future<void> updateBelajarStep({required int reachedStep, required int totalSteps}) =>
      _updateLessonRange(reachedStep: reachedStep, previous: _snapshot.belajarReached, start: 4);

  Future<void> updateLearningStep({required int reachedStep, required int totalSteps}) =>
      _updateLessonRange(reachedStep: reachedStep, previous: _snapshot.learningReached, start: 7);

  Future<void> _updateLessonRange({required int reachedStep, required int previous, required int start}) async {
    if (!_initialized) return;
    if (reachedStep <= previous) return;
    await _local.completeLessonRange(from: previous + 1, to: reachedStep, start: start);
    await _changed();
  }

  Future<void> recordLessonStarted(String lessonId) async {
    if (!_initialized) return;
    await _local.startLesson(lessonId);
    await _changed();
  }

  Future<String> beginQuiz({required String quizId, required String level}) async {
    if (!_initialized) return '';
    _activeQuizAttemptId = await _local.startQuiz(quizId: quizId, level: level);
    await _changed();
    return _activeQuizAttemptId!;
  }

  Future<void> recordQuizAnswer({
    required String questionId,
    required String selectedAnswer,
    required bool isAutoGraded,
    required bool isCorrect,
    required bool isBonus,
    required int responseTimeMilliseconds,
  }) async {
    if (!_initialized) return;
    final attemptId = _activeQuizAttemptId;
    if (attemptId == null) return;
    await _local.answerQuiz(
      attemptId: attemptId,
      questionId: questionId,
      selectedAnswer: selectedAnswer,
      isAutoGraded: isAutoGraded,
      isCorrect: isCorrect,
      isBonus: isBonus,
      responseMillis: responseTimeMilliseconds,
    );
    await _changed();
  }

  Future<void> recordQuizSubmission({
    required bool isAutoGraded,
    required bool isCorrect,
    required int questionGoal,
    String? lessonId,
    int? score,
    String selectedAnswer = '',
    bool isBonus = false,
    int responseTimeMilliseconds = 0,
  }) {
    return recordQuizAnswer(
      questionId: lessonId ?? 'unknown',
      selectedAnswer: selectedAnswer,
      isAutoGraded: isAutoGraded,
      isCorrect: isAutoGraded ? isCorrect : true,
      isBonus: isBonus,
      responseTimeMilliseconds: responseTimeMilliseconds,
    );
  }

  Future<void> recordQuizSessionCompleted({String lessonId = 'QUIZ_SESSION', int? score}) async {
    if (!_initialized) return;
    final attemptId = _activeQuizAttemptId;
    if (attemptId == null) return;
    await _local.finishQuiz(attemptId, completed: true, score: score ?? 0);
    _activeQuizAttemptId = null;
    await _changed();
  }

  Future<void> abandonQuiz() async {
    if (!_initialized) return;
    final attemptId = _activeQuizAttemptId;
    if (attemptId == null) return;
    await _local.finishQuiz(attemptId, completed: false);
    _activeQuizAttemptId = null;
    await _changed();
  }

  Future<void> recordGameSession({required int starsEarned, required int starsPossible, String lessonId = 'M000_GAME'}) async {
    if (!_initialized) return;
    final type = switch (lessonId.toLowerCase()) {
      final id when id.contains('pilihpantas') => 'pilih_pantas',
      final id when id.contains('carikumpul') => 'cari_kumpul',
      final id when id.contains('caripilih') => 'cari_bulatkan',
      final id when id.contains('betulsalah') => 'betul_atau_salah',
      _ => 'unknown',
    };
    final activeId = _activeGameSessionId;
    if (activeId == null) {
      await _local.recordGame(gameType: type, gameId: lessonId, earned: starsEarned, possible: starsPossible);
    } else {
      await _local.finishStartedGame(activeId, earned: starsEarned, possible: starsPossible, completed: true);
      _activeGameSessionId = null;
    }
    await _changed();
  }

  Future<void> beginGame({required String gameType, required String gameId}) async {
    if (!_initialized) return;
    _activeGameSessionId = await _local.startGame(gameType: gameType, gameId: gameId);
    await _changed();
  }

  Future<void> abandonGame() async {
    if (!_initialized) return;
    final id = _activeGameSessionId;
    if (id == null) return;
    _activeGameSessionId = null;
    await _local.finishStartedGame(id, earned: 0, possible: 0, completed: false);
    await _changed();
  }

  Future<void> forceSync() async {
    if (!_initialized) return;
    _lastSyncError = null;
    final ran = await _syncCoordinator.syncNow(ignoreBackoff: true);
    if (!ran && _firebaseUid == null) {
      _lastSyncError = 'Kemajuan disimpan pada peranti. Sandaran akan bermula selepas akaun disambungkan.';
    }
    await _refresh();
  }

  Future<void> onAppResumed() async {
    if (!_initialized) return;
    await _authRepository.completePendingRegistration();
    await _refresh();
    _syncCoordinator.schedule();
    await registerActivity();
  }

  Future<void> onAppPaused() async {
    if (!_initialized) return;
    _inactivityTimer?.cancel();
    await _local.endLearningSession();
    await _changed();
  }

  Future<void> registerActivity() async {
    if (!_initialized) return;
    await _local.startLearningSession();
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(minutes: 5), () {
      unawaited(_local.endLearningSession().then((_) => _changed()));
    });
  }

  Future<void> _changed() async {
    await _refresh();
    await _local.enqueueSummary(_snapshot);
    await _refresh();
    _syncCoordinator.schedule();
  }

  Future<void> _refresh() async {
    final profile = await _local.currentProfile();
    _userName = profile?.displayName ?? '';
    _userId = profile?.publicStudentId ?? '';
    _firebaseUid = profile?.firebaseUid;
    _authState = profile?.authState ?? 'pending';
    _snapshot = await _local.loadSnapshot();
    _pendingEventCount = await _local.pendingCount();
    if (profile != null) {
      final metadata = await (_db.select(_db.syncMetadataRows)
            ..where((t) => t.localProfileId.equals(profile.localId)))
          .getSingleOrNull();
      if (metadata?.lastSyncAtMillis != null) {
        _lastSyncedUtc = DateTime.fromMillisecondsSinceEpoch(metadata!.lastSyncAtMillis!, isUtc: true);
      }
      if (metadata?.lastResult == 'Sandaran berjaya.') {
        _lastSyncError = null;
      } else if (metadata?.lastResult != null) {
        _lastSyncError = metadata!.lastResult;
      }
    }
    notifyListeners();
  }

  void _log(String event, Map<String, Object?> fields) {
    if (kDebugMode) debugPrint('[AmiNProgress] $event $fields');
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    if (_initialized) unawaited(_syncCoordinator.dispose());
    super.dispose();
  }
}
