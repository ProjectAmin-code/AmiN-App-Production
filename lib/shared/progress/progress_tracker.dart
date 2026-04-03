import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'progress_snapshot.dart';
import 'progress_sync_service.dart';

class ProgressTracker extends ChangeNotifier {
  ProgressTracker._();

  static final ProgressTracker instance = ProgressTracker._();

  static const String _snapshotStorageKey = 'amin_progress_snapshot_v1';
  static const String _userStorageKey = 'amin_progress_user_v1';
  static const String _userIdStorageKey = 'amin_progress_user_id_v1';
  static const Duration _syncDebounceDelay = Duration(seconds: 2);
  static const bool _legacySnapshotCompatibilityEnabled = true;

  SharedPreferences? _prefs;
  ProgressSnapshot _snapshot = ProgressSnapshot.empty();
  String _userName = '';
  String _userId = '';
  bool _initialized = false;
  bool _isSyncing = false;
  bool _dirtySinceLastSync = false;
  DateTime? _lastSyncedUtc;
  String? _lastSyncError;
  Timer? _syncDebounce;

  ProgressSnapshot get snapshot => _snapshot;
  String get userName => _userName;
  String get userId => _userId;
  bool get hasIdentity =>
      _userName.trim().isNotEmpty && _userId.trim().isNotEmpty;
  bool get isSyncing => _isSyncing;
  DateTime? get lastSyncedUtc => _lastSyncedUtc;
  String? get lastSyncError => _lastSyncError;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    _initialized = true;
    try {
      _prefs = await SharedPreferences.getInstance();
      _userName = _prefs?.getString(_userStorageKey) ?? '';
      _userId = _prefs?.getString(_userIdStorageKey) ?? '';
      final raw = _prefs?.getString(_snapshotStorageKey);
      if (raw != null && raw.trim().isNotEmpty) {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) {
          _snapshot = ProgressSnapshot.fromJson(decoded);
        } else if (decoded is Map) {
          _snapshot = ProgressSnapshot.fromJson(
            decoded.map((key, value) => MapEntry('$key', value)),
          );
        }
      }
      if (_userName.trim().isNotEmpty) {
        await _ensureUserId();
      }
    } catch (_) {
      // Fallback to in-memory state only when persistence is unavailable.
    }
    notifyListeners();
  }

  Future<void> setUserName(String name) async {
    final cleaned = name.trim();
    if (cleaned.isEmpty) {
      return;
    }
    final changed = cleaned != _userName;
    _userName = cleaned;
    await _ensureUserId();
    await _persistUserName();
    _dirtySinceLastSync = true;
    if (changed) {
      notifyListeners();
    }
    _scheduleSync();
    unawaited(_registerStudent());
    unawaited(_syncBackfillCompletedLessons());
  }

  Future<void> clearUserIdentity({bool clearProgress = false}) async {
    _userName = '';
    _userId = '';
    if (clearProgress) {
      _snapshot = ProgressSnapshot.empty();
    }
    _dirtySinceLastSync = false;
    _lastSyncedUtc = null;
    _lastSyncError = null;

    try {
      await _prefs?.remove(_userStorageKey);
      await _prefs?.remove(_userIdStorageKey);
      if (clearProgress) {
        await _prefs?.remove(_snapshotStorageKey);
      }
    } catch (_) {
      // Ignore persistence errors and keep app responsive.
    }

    notifyListeners();
  }

  Future<ProgressSyncResult> restoreFromUserId(String userId) async {
    final cleaned = userId.trim();
    if (cleaned.isEmpty) {
      return const ProgressSyncResult(
        success: false,
        message: 'Sila masukkan User ID.',
      );
    }

    final studentResult = await ProgressSyncService.instance
        .fetchStudentByUserId(userId: cleaned);
    if (!studentResult.success) {
      return ProgressSyncResult(
        success: false,
        message: studentResult.message,
        statusCode: studentResult.statusCode,
      );
    }

    final rawStudentData = studentResult.data;
    if (rawStudentData is! Map) {
      return const ProgressSyncResult(
        success: false,
        message: 'Format data pelajar tidak sah.',
      );
    }
    final studentData = rawStudentData.map(
      (key, value) => MapEntry('$key', value),
    );
    final restoredName = '${studentData['name'] ?? ''}'.trim();
    if (restoredName.isEmpty) {
      return const ProgressSyncResult(
        success: false,
        message: 'Nama pelajar tidak sah di server.',
      );
    }

    final progressResult = await ProgressSyncService.instance
        .fetchProgressByUserId(userId: cleaned);
    if (!progressResult.success) {
      return ProgressSyncResult(
        success: false,
        message: progressResult.message,
        statusCode: progressResult.statusCode,
      );
    }

    final progressData = progressResult.data;
    final rows = progressData is List ? progressData : const <dynamic>[];
    final restoredSnapshot = _snapshotFromProgressRows(rows);

    _userId = cleaned;
    _userName = restoredName;
    _snapshot = restoredSnapshot;
    _dirtySinceLastSync = false;
    _lastSyncError = null;
    _lastSyncedUtc = DateTime.now().toUtc();

    await _persistUserId();
    await _persistUserName();
    await _persistSnapshot();
    notifyListeners();

    return const ProgressSyncResult(
      success: true,
      message: 'Data berjaya dipulihkan.',
    );
  }

  Future<void> updateOnboardingStep({
    required int reachedStep,
    required int totalSteps,
  }) async {
    final previousReached = _snapshot.onboardingReached;
    final nextReached = _maxClamped(reachedStep, totalSteps);
    final nextTotal = totalSteps <= 0 ? _snapshot.onboardingTotal : totalSteps;
    if (nextReached <= _snapshot.onboardingReached &&
        nextTotal == _snapshot.onboardingTotal) {
      return;
    }
    await _updateSnapshot(
      _snapshot.copyWith(
        onboardingReached: nextReached > _snapshot.onboardingReached
            ? nextReached
            : _snapshot.onboardingReached,
        onboardingTotal: nextTotal,
        lastUpdatedUtcMillis: DateTime.now().toUtc().millisecondsSinceEpoch,
      ),
    );

    final from = previousReached + 1;
    final to = nextReached;
    if (from <= to) {
      unawaited(_syncCompletedSteps(from: from, to: to, lessonStartNumber: 1));
    }
  }

  Future<void> updateBelajarStep({
    required int reachedStep,
    required int totalSteps,
  }) async {
    final previousReached = _snapshot.belajarReached;
    final nextReached = _maxClamped(reachedStep, totalSteps);
    final nextTotal = totalSteps <= 0 ? _snapshot.belajarTotal : totalSteps;
    if (nextReached <= _snapshot.belajarReached &&
        nextTotal == _snapshot.belajarTotal) {
      return;
    }
    await _updateSnapshot(
      _snapshot.copyWith(
        belajarReached: nextReached > _snapshot.belajarReached
            ? nextReached
            : _snapshot.belajarReached,
        belajarTotal: nextTotal,
        lastUpdatedUtcMillis: DateTime.now().toUtc().millisecondsSinceEpoch,
      ),
    );

    final from = previousReached + 1;
    final to = nextReached;
    if (from <= to) {
      unawaited(_syncCompletedSteps(from: from, to: to, lessonStartNumber: 4));
    }
  }

  Future<void> updateLearningStep({
    required int reachedStep,
    required int totalSteps,
  }) async {
    final previousReached = _snapshot.learningReached;
    final nextReached = _maxClamped(reachedStep, totalSteps);
    final nextTotal = totalSteps <= 0 ? _snapshot.learningTotal : totalSteps;
    if (nextReached <= _snapshot.learningReached &&
        nextTotal == _snapshot.learningTotal) {
      return;
    }
    await _updateSnapshot(
      _snapshot.copyWith(
        learningReached: nextReached > _snapshot.learningReached
            ? nextReached
            : _snapshot.learningReached,
        learningTotal: nextTotal,
        lastUpdatedUtcMillis: DateTime.now().toUtc().millisecondsSinceEpoch,
      ),
    );

    final from = previousReached + 1;
    final to = nextReached;
    if (from <= to) {
      unawaited(_syncCompletedSteps(from: from, to: to, lessonStartNumber: 7));
    }
  }

  Future<void> recordQuizSubmission({
    required bool isAutoGraded,
    required bool isCorrect,
    required int questionGoal,
    String? lessonId,
    int? score,
  }) async {
    final nextAnswered = _snapshot.quizAnswered + 1;
    final nextAutoTotal = _snapshot.quizAutoTotal + (isAutoGraded ? 1 : 0);
    final nextAutoCorrect =
        _snapshot.quizAutoCorrect + (isAutoGraded && isCorrect ? 1 : 0);
    final nextGoal = questionGoal > 0
        ? questionGoal
        : _snapshot.quizQuestionGoal;
    await _updateSnapshot(
      _snapshot.copyWith(
        quizAnswered: nextAnswered,
        quizAutoTotal: nextAutoTotal,
        quizAutoCorrect: nextAutoCorrect,
        quizQuestionGoal: nextGoal,
        lastUpdatedUtcMillis: DateTime.now().toUtc().millisecondsSinceEpoch,
      ),
    );

    final resolvedLessonId =
        lessonId ?? 'QUIZ_${nextAnswered.toString().padLeft(2, '0')}';
    final resolvedScore = score ?? (isAutoGraded ? (isCorrect ? 100 : 0) : 100);
    unawaited(
      _syncLessonProgress(
        lessonId: resolvedLessonId,
        status: 'completed',
        score: resolvedScore,
      ),
    );
  }

  Future<void> recordQuizSessionCompleted({
    String lessonId = 'QUIZ_SESSION',
    int? score,
  }) async {
    final nextSnapshot = _snapshot.copyWith(
      quizSessionsCompleted: _snapshot.quizSessionsCompleted + 1,
      lastUpdatedUtcMillis: DateTime.now().toUtc().millisecondsSinceEpoch,
    );
    await _updateSnapshot(nextSnapshot);
    final resolvedScore = score ?? nextSnapshot.quizAccuracyPercent;
    unawaited(
      _syncLessonProgress(
        lessonId: lessonId,
        status: 'completed',
        score: resolvedScore,
      ),
    );
  }

  Future<void> recordGameSession({
    required int starsEarned,
    required int starsPossible,
    String lessonId = 'M000_GAME',
  }) async {
    final normalizedPossible = starsPossible <= 0 ? 1 : starsPossible;
    final normalizedEarned = starsEarned.clamp(0, normalizedPossible);
    final score = ((normalizedEarned / normalizedPossible) * 100).round().clamp(
      0,
      100,
    );
    await _updateSnapshot(
      _snapshot.copyWith(
        gameSessionsCompleted: _snapshot.gameSessionsCompleted + 1,
        gameStarsEarned: _snapshot.gameStarsEarned + normalizedEarned,
        gameStarsPossible: _snapshot.gameStarsPossible + normalizedPossible,
        lastUpdatedUtcMillis: DateTime.now().toUtc().millisecondsSinceEpoch,
      ),
    );

    unawaited(
      _syncLessonProgress(
        lessonId: lessonId,
        status: 'completed',
        score: score,
      ),
    );
  }

  Future<void> forceSync() async {
    await _syncNow(force: true);
  }

  Future<void> _updateSnapshot(ProgressSnapshot nextSnapshot) async {
    _snapshot = nextSnapshot;
    _dirtySinceLastSync = true;
    _lastSyncError = null;
    await _persistSnapshot();
    notifyListeners();
    _scheduleSync();
  }

  Future<void> _syncCompletedSteps({
    required int from,
    required int to,
    required int lessonStartNumber,
  }) async {
    for (var index = from; index <= to; index++) {
      final lessonNumber = lessonStartNumber + (index - 1);
      final lessonId = 'S${lessonNumber.toString().padLeft(3, '0')}';
      await _syncLessonProgress(
        lessonId: lessonId,
        status: 'completed',
        score: 100,
      );
    }
  }

  Future<void> _syncBackfillCompletedLessons() async {
    if (_userName.trim().isEmpty) {
      return;
    }
    if (_snapshot.onboardingReached > 0) {
      await _syncCompletedSteps(
        from: 1,
        to: _snapshot.onboardingReached,
        lessonStartNumber: 1,
      );
    }
    if (_snapshot.belajarReached > 0) {
      await _syncCompletedSteps(
        from: 1,
        to: _snapshot.belajarReached,
        lessonStartNumber: 4,
      );
    }
    if (_snapshot.learningReached > 0) {
      await _syncCompletedSteps(
        from: 1,
        to: _snapshot.learningReached,
        lessonStartNumber: 7,
      );
    }
  }

  Future<void> _syncLessonProgress({
    required String lessonId,
    required String status,
    required int score,
  }) async {
    if (_userName.trim().isEmpty) {
      return;
    }
    await _ensureUserId();
    final result = await ProgressSyncService.instance.upsertProgress(
      userId: _userId,
      lessonId: lessonId,
      status: status,
      score: score,
    );
    if (result.success) {
      _lastSyncedUtc = DateTime.now().toUtc();
      _lastSyncError = null;
    } else {
      _lastSyncError = result.message;
    }
    notifyListeners();
  }

  Future<void> _registerStudent() async {
    if (_userName.trim().isEmpty) {
      return;
    }
    await _ensureUserId();
    final result = await ProgressSyncService.instance.registerStudent(
      userId: _userId,
      name: _userName,
    );
    if (result.success) {
      _lastSyncedUtc = DateTime.now().toUtc();
      _lastSyncError = null;
    } else {
      _lastSyncError = result.message;
    }
    notifyListeners();
  }

  void _scheduleSync() {
    if (_userName.trim().isEmpty || !_legacySnapshotCompatibilityEnabled) {
      return;
    }
    _syncDebounce?.cancel();
    _syncDebounce = Timer(_syncDebounceDelay, () {
      _syncNow();
    });
  }

  Future<void> _syncNow({bool force = false}) async {
    if (_userName.trim().isEmpty || _isSyncing) {
      return;
    }
    if (!_dirtySinceLastSync && !force) {
      return;
    }
    _isSyncing = true;
    notifyListeners();
    final result = await ProgressSyncService.instance.uploadLegacySnapshot(
      userName: _userName,
      snapshot: _snapshot,
    );
    _isSyncing = false;
    if (result.success) {
      _dirtySinceLastSync = false;
      _lastSyncError = null;
      _lastSyncedUtc = DateTime.now().toUtc();
    } else {
      _lastSyncError = result.message;
    }
    notifyListeners();
  }

  Future<void> _ensureUserId() async {
    if (_userId.trim().isNotEmpty) {
      return;
    }
    _userId = const Uuid().v4();
    await _persistUserId();
  }

  Future<void> _persistSnapshot() async {
    try {
      await _prefs?.setString(
        _snapshotStorageKey,
        jsonEncode(_snapshot.toJson()),
      );
    } catch (_) {
      // Ignore persistence errors and keep app responsive.
    }
  }

  Future<void> _persistUserName() async {
    try {
      await _prefs?.setString(_userStorageKey, _userName);
    } catch (_) {
      // Ignore persistence errors and keep app responsive.
    }
  }

  Future<void> _persistUserId() async {
    try {
      await _prefs?.setString(_userIdStorageKey, _userId);
    } catch (_) {
      // Ignore persistence errors and keep app responsive.
    }
  }

  int _maxClamped(int reached, int total) {
    final safeTotal = total <= 0 ? 1 : total;
    return reached.clamp(0, safeTotal);
  }

  ProgressSnapshot _snapshotFromProgressRows(List<dynamic> rows) {
    var onboardingReached = 0;
    var belajarReached = 0;
    var learningReached = 0;
    var quizAnswered = 0;
    var quizAutoTotal = 0;
    var quizAutoCorrect = 0;
    var quizSessionsCompleted = 0;
    var gameScoreAccumulated = 0;
    var gameSessionsCompleted = 0;
    var latestUpdatedUtcMillis = DateTime.now().toUtc().millisecondsSinceEpoch;

    for (final raw in rows) {
      if (raw is! Map) {
        continue;
      }
      final map = raw.map((key, value) => MapEntry('$key', value));
      final lessonId = '${map['lessonId'] ?? ''}'.trim();
      if (lessonId.isEmpty) {
        continue;
      }
      final lessonUpper = lessonId.toUpperCase();
      final score = _parseInt(map['score']).clamp(0, 100);

      final updatedMillis = _parseUpdatedMillis(map['updatedAt']);
      if (updatedMillis > latestUpdatedUtcMillis) {
        latestUpdatedUtcMillis = updatedMillis;
      }

      if (lessonUpper.startsWith('S')) {
        final number = _parseScreenNumber(lessonUpper);
        if (number >= 1 && number <= 3) {
          onboardingReached = number > onboardingReached
              ? number
              : onboardingReached;
          continue;
        }
        if (number >= 4 && number <= 6) {
          final step = number - 3;
          belajarReached = step > belajarReached ? step : belajarReached;
          continue;
        }
        if (number >= 7 && number <= 21) {
          final step = number - 6;
          learningReached = step > learningReached ? step : learningReached;
          continue;
        }
      }

      if (lessonUpper.startsWith('QUIZ_LEVEL_') ||
          lessonUpper == 'QUIZ_SESSION') {
        quizSessionsCompleted += 1;
        continue;
      }

      if (lessonUpper.startsWith('Q') || lessonUpper.startsWith('QUIZ_')) {
        quizAnswered += 1;
        quizAutoTotal += 1;
        if (score >= 100) {
          quizAutoCorrect += 1;
        }
        continue;
      }

      if (lessonUpper.startsWith('M')) {
        gameSessionsCompleted += 1;
        gameScoreAccumulated += score;
      }
    }

    final gameStarsPossible = gameSessionsCompleted * 100;
    return ProgressSnapshot.empty().copyWith(
      onboardingReached: onboardingReached,
      onboardingTotal: 3,
      belajarReached: belajarReached,
      belajarTotal: 3,
      learningReached: learningReached,
      learningTotal: 15,
      quizAnswered: quizAnswered,
      quizAutoTotal: quizAutoTotal,
      quizAutoCorrect: quizAutoCorrect,
      quizQuestionGoal: 32,
      quizSessionsCompleted: quizSessionsCompleted,
      gameStarsEarned: gameScoreAccumulated,
      gameStarsPossible: gameStarsPossible,
      gameSessionsCompleted: gameSessionsCompleted,
      lastUpdatedUtcMillis: latestUpdatedUtcMillis,
    );
  }

  int _parseScreenNumber(String lessonUpper) {
    final match = RegExp(r'^S0*(\d+)$').firstMatch(lessonUpper);
    if (match == null) {
      return -1;
    }
    return int.tryParse(match.group(1) ?? '') ?? -1;
  }

  int _parseUpdatedMillis(dynamic raw) {
    if (raw is String) {
      final parsed = DateTime.tryParse(raw);
      if (parsed != null) {
        return parsed.toUtc().millisecondsSinceEpoch;
      }
    }
    return DateTime.now().toUtc().millisecondsSinceEpoch;
  }

  int _parseInt(dynamic raw) {
    if (raw is int) {
      return raw;
    }
    if (raw is num) {
      return raw.toInt();
    }
    return int.tryParse('$raw') ?? 0;
  }

  @override
  void dispose() {
    _syncDebounce?.cancel();
    super.dispose();
  }
}
