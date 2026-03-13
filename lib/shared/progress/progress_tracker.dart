import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'progress_snapshot.dart';
import 'progress_sync_service.dart';

class ProgressTracker extends ChangeNotifier {
  ProgressTracker._();

  static final ProgressTracker instance = ProgressTracker._();

  static const String _snapshotStorageKey = 'amin_progress_snapshot_v1';
  static const String _userStorageKey = 'amin_progress_user_v1';
  static const Duration _syncDebounceDelay = Duration(seconds: 2);

  SharedPreferences? _prefs;
  ProgressSnapshot _snapshot = ProgressSnapshot.empty();
  String _userName = '';
  bool _initialized = false;
  bool _isSyncing = false;
  bool _dirtySinceLastSync = false;
  DateTime? _lastSyncedUtc;
  String? _lastSyncError;
  Timer? _syncDebounce;

  ProgressSnapshot get snapshot => _snapshot;
  String get userName => _userName;
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
    } catch (_) {
      // Fallback to in-memory state only when persistence is unavailable.
    }
    notifyListeners();
  }

  Future<void> setUserName(String name) async {
    final cleaned = name.trim();
    if (cleaned.isEmpty || cleaned == _userName) {
      return;
    }
    _userName = cleaned;
    await _persistUserName();
    _dirtySinceLastSync = true;
    notifyListeners();
    _scheduleSync();
  }

  Future<void> updateOnboardingStep({
    required int reachedStep,
    required int totalSteps,
  }) async {
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
  }

  Future<void> updateBelajarStep({
    required int reachedStep,
    required int totalSteps,
  }) async {
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
  }

  Future<void> updateLearningStep({
    required int reachedStep,
    required int totalSteps,
  }) async {
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
  }

  Future<void> recordQuizSubmission({
    required bool isAutoGraded,
    required bool isCorrect,
    required int questionGoal,
  }) async {
    final nextAnswered = _snapshot.quizAnswered + 1;
    final nextAutoTotal = _snapshot.quizAutoTotal + (isAutoGraded ? 1 : 0);
    final nextAutoCorrect =
        _snapshot.quizAutoCorrect + (isAutoGraded && isCorrect ? 1 : 0);
    final nextGoal = questionGoal > 0 ? questionGoal : _snapshot.quizQuestionGoal;
    await _updateSnapshot(
      _snapshot.copyWith(
        quizAnswered: nextAnswered,
        quizAutoTotal: nextAutoTotal,
        quizAutoCorrect: nextAutoCorrect,
        quizQuestionGoal: nextGoal,
        lastUpdatedUtcMillis: DateTime.now().toUtc().millisecondsSinceEpoch,
      ),
    );
  }

  Future<void> recordQuizSessionCompleted() async {
    await _updateSnapshot(
      _snapshot.copyWith(
        quizSessionsCompleted: _snapshot.quizSessionsCompleted + 1,
        lastUpdatedUtcMillis: DateTime.now().toUtc().millisecondsSinceEpoch,
      ),
    );
  }

  Future<void> recordGameSession({
    required int starsEarned,
    required int starsPossible,
  }) async {
    final normalizedPossible = starsPossible <= 0 ? 1 : starsPossible;
    final normalizedEarned = starsEarned.clamp(0, normalizedPossible);
    await _updateSnapshot(
      _snapshot.copyWith(
        gameSessionsCompleted: _snapshot.gameSessionsCompleted + 1,
        gameStarsEarned: _snapshot.gameStarsEarned + normalizedEarned,
        gameStarsPossible: _snapshot.gameStarsPossible + normalizedPossible,
        lastUpdatedUtcMillis: DateTime.now().toUtc().millisecondsSinceEpoch,
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

  void _scheduleSync() {
    if (_userName.trim().isEmpty) {
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
    final result = await ProgressSyncService.instance.uploadSnapshot(
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

  Future<void> _persistSnapshot() async {
    try {
      await _prefs?.setString(_snapshotStorageKey, jsonEncode(_snapshot.toJson()));
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

  int _maxClamped(int reached, int total) {
    final safeTotal = total <= 0 ? 1 : total;
    return reached.clamp(0, safeTotal);
  }

  @override
  void dispose() {
    _syncDebounce?.cancel();
    super.dispose();
  }
}
