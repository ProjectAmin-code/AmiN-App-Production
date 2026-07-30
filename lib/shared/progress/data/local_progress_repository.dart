import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../domain/progress_types.dart';
import '../domain/student_identity.dart';
import '../progress_snapshot.dart';
import 'progress_database.dart';

class LocalProgressRepository {
  LocalProgressRepository(this.db);

  static const _snapshotKey = 'amin_progress_snapshot_v1';
  static const _nameKey = 'amin_progress_user_v1';
  static const _legacyUserIdKey = 'amin_progress_user_id_v1';
  static const _installationKey = 'amin_installation_id_v1';
  static const _migrationKey = 'amin_drift_migration_v1';

  final ProgressDatabase db;
  late SharedPreferences _prefs;
  late String installationId;
  String? _activeLearningSessionId;
  int? _activeSessionStartedAt;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    installationId = _prefs.getString(_installationKey) ?? 'inst_${const Uuid().v4()}';
    await _prefs.setString(_installationKey, installationId);
    await _migrateLegacySnapshot();
    final profile = await currentProfile();
    if (profile != null) {
      await _ensureInstallation(profile.localId);
      await resetStaleSyncing();
      await createEvent(
        type: LearningEventType.appOpened,
        entityType: LearningEntityType.app,
        entityId: installationId,
      );
    }
  }

  Future<StudentProfile?> currentProfile() => db.select(db.studentProfiles).getSingleOrNull();

  Future<StudentProfile> ensureProfile(String displayName) async {
    var profile = await currentProfile();
    if (profile != null) return profile;
    final now = _now;
    final localId = const Uuid().v4();
    await db.into(db.studentProfiles).insert(
      StudentProfilesCompanion.insert(
        localId: localId,
        publicStudentId: StudentIdentity.generate(),
        displayName: displayName.trim(),
        legacyUserId: Value(_prefs.getString(_legacyUserIdKey)),
        createdAtMillis: now,
        updatedAtMillis: now,
      ),
    );
    await _ensureInstallation(localId);
    return (db.select(db.studentProfiles)..where((t) => t.localId.equals(localId))).getSingle();
  }

  Future<void> _ensureInstallation(String localProfileId) async {
    final info = await PackageInfo.fromPlatform();
    final now = _now;
    final existing = await (db.select(db.installations)
          ..where((t) => t.installationId.equals(installationId)))
        .getSingleOrNull();
    await db.into(db.installations).insertOnConflictUpdate(
      InstallationsCompanion.insert(
        installationId: installationId,
        localProfileId: localProfileId,
        platform: 'android',
        appVersion: '${info.version}+${info.buildNumber}',
        firstSeenAtMillis: existing?.firstSeenAtMillis ?? now,
        lastSeenAtMillis: now,
        lastSyncAtMillis: Value(existing?.lastSyncAtMillis),
      ),
    );
  }

  Future<void> _migrateLegacySnapshot() async {
    if (_prefs.getBool(_migrationKey) == true || await currentProfile() != null) return;
    final name = (_prefs.getString(_nameKey) ?? '').trim();
    final raw = _prefs.getString(_snapshotKey);
    if (name.isEmpty && (raw == null || raw.isEmpty)) return;
    final localId = const Uuid().v4();
    final now = _now;
    Map<String, dynamic> json = {};
    try {
      final decoded = jsonDecode(raw ?? '');
      if (decoded is Map) json = decoded.map((k, v) => MapEntry('$k', v));
    } catch (_) {
      // A damaged legacy snapshot must not prevent creation of a usable profile.
    }
    int value(String key) => (json[key] as num?)?.toInt() ?? 0;
    await db.transaction(() async {
      await db.into(db.studentProfiles).insert(
        StudentProfilesCompanion.insert(
          localId: localId,
          publicStudentId: StudentIdentity.generate(),
          displayName: name.isEmpty ? 'Pelajar' : name,
          authState: const Value('needs_pin'),
          legacyUserId: Value(_prefs.getString(_legacyUserIdKey)),
          createdAtMillis: now,
          updatedAtMillis: now,
        ),
      );
      await db.into(db.legacyProgressBaselines).insert(
        LegacyProgressBaselinesCompanion.insert(
          localProfileId: localId,
          onboardingReached: Value(value('onboardingReached')),
          belajarReached: Value(value('belajarReached')),
          learningReached: Value(value('learningReached')),
          quizAnswered: Value(value('quizAnswered')),
          quizAutoCorrect: Value(value('quizAutoCorrect')),
          quizAutoTotal: Value(value('quizAutoTotal')),
          quizSessionsCompleted: Value(value('quizSessionsCompleted')),
          gameStarsEarned: Value(value('gameStarsEarned')),
          gameStarsPossible: Value(value('gameStarsPossible')),
          gameSessionsCompleted: Value(value('gameSessionsCompleted')),
          migratedAtMillis: now,
        ),
      );
    });
    await _prefs.setBool(_migrationKey, true);
  }

  Future<ProgressSnapshot> loadSnapshot() async {
    final profile = await currentProfile();
    if (profile == null) return ProgressSnapshot.empty();
    final base = await (db.select(db.legacyProgressBaselines)
          ..where((t) => t.localProfileId.equals(profile.localId)))
        .getSingleOrNull();
    final lessons = await (db.select(db.lessonProgressRows)
          ..where((t) => t.localProfileId.equals(profile.localId) & t.status.equals('completed')))
        .get();
    int maxIn(int first, int last) {
      var result = 0;
      for (final lesson in lessons) {
        final match = RegExp(r'^S0*(\d+)$').firstMatch(lesson.lessonId.toUpperCase());
        final number = int.tryParse(match?.group(1) ?? '') ?? -1;
        if (number >= first && number <= last) result = result < number - first + 1 ? number - first + 1 : result;
      }
      return result;
    }
    final answers = await (db.select(db.quizAnswers).join([
      innerJoin(db.quizAttempts, db.quizAttempts.attemptId.equalsExp(db.quizAnswers.attemptId)),
    ])..where(db.quizAttempts.localProfileId.equals(profile.localId))).get();
    final distinctQuestions = answers.map((r) => r.readTable(db.quizAnswers).questionId).toSet().length;
    final autoAnswers = answers.where((r) => r.readTable(db.quizAnswers).isAutoGraded).toList();
    final autoTotal = autoAnswers.length;
    final autoCorrect = autoAnswers.where((r) => r.readTable(db.quizAnswers).isCorrect).length;
    final completedAttempts = await (db.select(db.quizAttempts)
          ..where((t) => t.localProfileId.equals(profile.localId) & t.status.equals('completed')))
        .get();
    final games = await (db.select(db.gameSessions)
          ..where((t) => t.localProfileId.equals(profile.localId) & t.status.equals('completed')))
        .get();
    final gameEarned = games.fold<int>(0, (sum, row) => sum + (row.correctCount ?? row.score ?? 0));
    final gamePossible = games.fold<int>(0, (sum, row) => sum + ((row.correctCount ?? 0) + (row.wrongCount ?? 0)).clamp(1, 1 << 30));
    return ProgressSnapshot.empty().copyWith(
      onboardingReached: _max(base?.onboardingReached ?? 0, maxIn(1, 3)),
      belajarReached: _max(base?.belajarReached ?? 0, maxIn(4, 6)),
      learningReached: _max(base?.learningReached ?? 0, maxIn(7, 21)),
      quizAnswered: (base?.quizAnswered ?? 0) + distinctQuestions,
      quizAutoCorrect: (base?.quizAutoCorrect ?? 0) + autoCorrect,
      quizAutoTotal: (base?.quizAutoTotal ?? 0) + autoTotal,
      quizQuestionGoal: 36,
      quizSessionsCompleted: (base?.quizSessionsCompleted ?? 0) + completedAttempts.length,
      gameStarsEarned: (base?.gameStarsEarned ?? 0) + gameEarned,
      gameStarsPossible: (base?.gameStarsPossible ?? 0) + gamePossible,
      gameSessionsCompleted: (base?.gameSessionsCompleted ?? 0) + games.length,
      lastUpdatedUtcMillis: _now,
    );
  }

  Future<void> completeLessonRange({required int from, required int to, required int start}) async {
    final profile = await currentProfile();
    if (profile == null) return;
    for (var index = from; index <= to; index++) {
      final id = 'S${(start + index - 1).toString().padLeft(3, '0')}';
      await completeLesson(id);
    }
  }

  Future<void> startLesson(String lessonId) async {
    final profile = await currentProfile();
    if (profile == null) return;
    final existing = await (db.select(db.lessonProgressRows)
          ..where((t) => t.localProfileId.equals(profile.localId) & t.lessonId.equals(lessonId)))
        .getSingleOrNull();
    final type = existing == null
        ? LearningEventType.lessonStarted
        : existing.status == 'completed'
            ? LearningEventType.lessonRevisited
            : LearningEventType.lessonResumed;
    await db.transaction(() async {
      await db.into(db.lessonProgressRows).insertOnConflictUpdate(
        LessonProgressRowsCompanion.insert(
          localProfileId: profile.localId,
          lessonId: lessonId,
          status: Value(existing?.status ?? 'started'),
          startedAtMillis: existing?.startedAtMillis ?? _now,
          completedAtMillis: Value(existing?.completedAtMillis),
          totalTimeSpentSeconds: Value(existing?.totalTimeSpentSeconds ?? 0),
          visitCount: Value((existing?.visitCount ?? 0) + 1),
          updatedAtMillis: _now,
        ),
      );
      await createEvent(type: type, entityType: LearningEntityType.lesson, entityId: lessonId);
    });
  }

  Future<void> completeLesson(String lessonId) async {
    final profile = await currentProfile();
    if (profile == null) return;
    final existing = await (db.select(db.lessonProgressRows)
          ..where((t) => t.localProfileId.equals(profile.localId) & t.lessonId.equals(lessonId)))
        .getSingleOrNull();
    if (existing?.status == 'completed') return;
    final now = _now;
    await db.transaction(() async {
      await db.into(db.lessonProgressRows).insertOnConflictUpdate(
        LessonProgressRowsCompanion.insert(
          localProfileId: profile.localId,
          lessonId: lessonId,
          status: const Value('completed'),
          startedAtMillis: existing?.startedAtMillis ?? now,
          completedAtMillis: Value(existing?.completedAtMillis ?? now),
          totalTimeSpentSeconds: Value(existing?.totalTimeSpentSeconds ?? 0),
          visitCount: Value(existing?.visitCount ?? 1),
          updatedAtMillis: now,
        ),
      );
      await createEvent(type: LearningEventType.lessonCompleted, entityType: LearningEntityType.lesson, entityId: lessonId);
      await enqueueDocument(
        relativePath: 'lesson_progress/$lessonId',
        documentId: lessonId,
        payload: {
          'schemaVersion': 1,
          'lessonId': lessonId,
          'status': 'completed',
          'startedAtMillis': existing?.startedAtMillis ?? now,
          'completedAtMillis': existing?.completedAtMillis ?? now,
          'visitCount': existing?.visitCount ?? 1,
          'updatedAtMillis': now,
        },
      );
    });
  }

  Future<String> startQuiz({required String quizId, required String level}) async {
    final profile = await currentProfile();
    if (profile == null) return '';
    final id = const Uuid().v4();
    await db.transaction(() async {
      await db.into(db.quizAttempts).insert(QuizAttemptsCompanion.insert(
        attemptId: id,
        localProfileId: profile.localId,
        quizId: quizId,
        quizLevel: level,
        startedAtMillis: _now,
      ));
      await createEvent(type: LearningEventType.quizStarted, entityType: LearningEntityType.quiz, entityId: id, payload: {'quizId': quizId, 'quizLevel': level});
    });
    return id;
  }

  Future<void> answerQuiz({required String attemptId, required String questionId, required String selectedAnswer, required bool isAutoGraded, required bool isCorrect, required bool isBonus, required int responseMillis}) async {
    if (attemptId.isEmpty) return;
    final answerId = '$attemptId:$questionId';
    await db.transaction(() async {
      await db.into(db.quizAnswers).insertOnConflictUpdate(QuizAnswersCompanion.insert(
        answerId: answerId,
        attemptId: attemptId,
        questionId: questionId,
        selectedAnswer: selectedAnswer,
        isAutoGraded: Value(isAutoGraded),
        isCorrect: isCorrect,
        isBonusQuestion: isBonus,
        responseTimeMilliseconds: responseMillis,
        answeredAtMillis: _now,
      ));
      await createEvent(type: LearningEventType.quizQuestionAnswered, entityType: LearningEntityType.question, entityId: questionId, payload: {'attemptId': attemptId, 'isAutoGraded': isAutoGraded, 'isCorrect': isCorrect, 'isBonus': isBonus, 'responseTimeMilliseconds': responseMillis});
    });
  }

  Future<void> finishQuiz(String attemptId, {required bool completed, int score = 0}) async {
    if (attemptId.isEmpty) return;
    final attempt = await (db.select(db.quizAttempts)..where((t) => t.attemptId.equals(attemptId))).getSingleOrNull();
    if (attempt == null || attempt.status != 'started') return;
    final answers = await (db.select(db.quizAnswers)..where((t) => t.attemptId.equals(attemptId))).get();
    final correct = answers.where((a) => a.isCorrect && !a.isBonusQuestion).length;
    final wrong = answers.where((a) => !a.isCorrect && !a.isBonusQuestion).length;
    final bonus = answers.where((a) => a.isCorrect && a.isBonusQuestion).length;
    final now = _now;
    final payload = {
      'schemaVersion': 1,
      'attemptId': attemptId,
      'quizId': attempt.quizId,
      'quizLevel': attempt.quizLevel,
      'status': completed ? 'completed' : 'abandoned',
      'startedAtMillis': attempt.startedAtMillis,
      'completedAtMillis': now,
      'correctAnswers': correct,
      'wrongAnswers': wrong,
      'bonusCorrect': bonus,
      'totalScore': score,
      'durationSeconds': ((now - attempt.startedAtMillis) / 1000).round(),
      'answers': answers.map((a) => {'questionId': a.questionId, 'selectedAnswer': a.selectedAnswer, 'isAutoGraded': a.isAutoGraded, 'isCorrect': a.isCorrect, 'isBonusQuestion': a.isBonusQuestion, 'responseTimeMilliseconds': a.responseTimeMilliseconds, 'answeredAtMillis': a.answeredAtMillis}).toList(),
    };
    await db.transaction(() async {
      await (db.update(db.quizAttempts)..where((t) => t.attemptId.equals(attemptId))).write(QuizAttemptsCompanion(
        status: Value(completed ? 'completed' : 'abandoned'),
        completedAtMillis: Value(now),
        correctAnswers: Value(correct), wrongAnswers: Value(wrong), bonusCorrect: Value(bonus), totalScore: Value(score),
        durationSeconds: Value(((now - attempt.startedAtMillis) / 1000).round()),
      ));
      await createEvent(type: completed ? LearningEventType.quizCompleted : LearningEventType.quizAbandoned, entityType: LearningEntityType.quiz, entityId: attemptId, payload: {'score': score});
      await enqueueDocument(relativePath: 'quiz_attempts/$attemptId', documentId: attemptId, payload: payload);
    });
  }

  Future<void> recordGame({required String gameType, required String gameId, required int earned, required int possible, int? attemptCount}) async {
    final profile = await currentProfile();
    if (profile == null) return;
    final id = const Uuid().v4();
    final now = _now;
    final payload = {'schemaVersion': 1, 'gameSessionId': id, 'gameType': gameType, 'gameId': gameId, 'status': 'completed', 'startedAtMillis': now, 'completedAtMillis': now, 'durationSeconds': 0, 'score': possible <= 0 ? 0 : ((earned / possible) * 100).round(), 'correctCount': earned, 'wrongCount': _max(0, possible - earned), 'attemptCount': attemptCount};
    await db.transaction(() async {
      await db.into(db.gameSessions).insert(GameSessionsCompanion.insert(
        gameSessionId: id, localProfileId: profile.localId, gameType: gameType, gameId: gameId,
        status: const Value('completed'), startedAtMillis: now, completedAtMillis: Value(now),
        score: Value(payload['score'] as int), correctCount: Value(earned), wrongCount: Value(_max(0, possible - earned)), attemptCount: Value(attemptCount),
      ));
      await createEvent(type: LearningEventType.gameCompleted, entityType: LearningEntityType.game, entityId: id, payload: {'gameType': gameType, 'gameId': gameId});
      await enqueueDocument(relativePath: 'game_sessions/$id', documentId: id, payload: payload);
    });
  }

  Future<String> startGame({required String gameType, required String gameId}) async {
    final profile = await currentProfile();
    if (profile == null) return '';
    final id = const Uuid().v4();
    final now = _now;
    await db.transaction(() async {
      await db.into(db.gameSessions).insert(GameSessionsCompanion.insert(
        gameSessionId: id,
        localProfileId: profile.localId,
        gameType: gameType,
        gameId: gameId,
        startedAtMillis: now,
      ));
      await createEvent(type: LearningEventType.gameStarted, entityType: LearningEntityType.game, entityId: id, payload: {'gameType': gameType, 'gameId': gameId});
    });
    return id;
  }

  Future<void> finishStartedGame(String sessionId, {required int earned, required int possible, required bool completed}) async {
    if (sessionId.isEmpty) return;
    final row = await (db.select(db.gameSessions)..where((t) => t.gameSessionId.equals(sessionId))).getSingleOrNull();
    if (row == null || row.status != 'started') return;
    final now = _now;
    final status = completed ? 'completed' : 'abandoned';
    final payload = {'schemaVersion': 1, 'gameSessionId': sessionId, 'gameType': row.gameType, 'gameId': row.gameId, 'status': status, 'startedAtMillis': row.startedAtMillis, 'completedAtMillis': now, 'durationSeconds': ((now - row.startedAtMillis) / 1000).round(), 'score': possible <= 0 ? 0 : ((earned / possible) * 100).round(), 'correctCount': earned, 'wrongCount': _max(0, possible - earned)};
    await db.transaction(() async {
      await (db.update(db.gameSessions)..where((t) => t.gameSessionId.equals(sessionId))).write(GameSessionsCompanion(
        status: Value(status), completedAtMillis: Value(now), durationSeconds: Value(((now - row.startedAtMillis) / 1000).round()),
        score: Value(payload['score'] as int), correctCount: Value(earned), wrongCount: Value(_max(0, possible - earned)),
      ));
      await createEvent(type: completed ? LearningEventType.gameCompleted : LearningEventType.gameAbandoned, entityType: LearningEntityType.game, entityId: sessionId, payload: {'gameType': row.gameType, 'gameId': row.gameId});
      await enqueueDocument(relativePath: 'game_sessions/$sessionId', documentId: sessionId, payload: payload);
    });
  }

  Future<void> startLearningSession() async {
    if (_activeLearningSessionId != null) return;
    final profile = await currentProfile();
    if (profile == null) return;
    final id = const Uuid().v4();
    final now = _now;
    _activeLearningSessionId = id;
    _activeSessionStartedAt = now;
    await db.transaction(() async {
      await db.into(db.learningSessions).insert(LearningSessionsCompanion.insert(
        sessionId: id,
        localProfileId: profile.localId,
        startedAtMillis: now,
      ));
      await createEvent(type: LearningEventType.learningSessionStarted, entityType: LearningEntityType.session, entityId: id);
    });
  }

  Future<void> endLearningSession() async {
    final id = _activeLearningSessionId;
    final startedAt = _activeSessionStartedAt;
    if (id == null || startedAt == null) return;
    _activeLearningSessionId = null;
    _activeSessionStartedAt = null;
    final now = _now;
    final seconds = ((now - startedAt) / 1000).round().clamp(0, 300);
    await db.transaction(() async {
      await (db.update(db.learningSessions)..where((t) => t.sessionId.equals(id))).write(
        LearningSessionsCompanion(endedAtMillis: Value(now), activeLearningSeconds: Value(seconds), status: const Value('ended')),
      );
      await createEvent(type: LearningEventType.learningSessionEnded, entityType: LearningEntityType.session, entityId: id, payload: {'activeLearningSeconds': seconds});
      await enqueueDocument(relativePath: 'learning_sessions/$id', documentId: id, payload: {
        'schemaVersion': 1, 'sessionId': id, 'startedAtMillis': startedAt, 'endedAtMillis': now, 'activeLearningSeconds': seconds,
      });
    });
  }

  Future<void> createEvent({required LearningEventType type, required LearningEntityType entityType, required String entityId, Map<String, Object?> payload = const {}}) async {
    final profile = await currentProfile();
    if (profile == null) return;
    final id = const Uuid().v4();
    final now = _now;
    final body = {'schemaVersion': 1, 'eventId': id, 'installationId': installationId, 'eventType': type.name, 'entityType': entityType.name, 'entityId': entityId, 'timestampMillis': now, 'payload': payload, 'createdAtMillis': now};
    await db.into(db.learningEvents).insert(LearningEventsCompanion.insert(
      eventId: id, localProfileId: profile.localId, firebaseUid: Value(profile.firebaseUid), installationId: installationId,
      eventType: type.name, entityType: entityType.name, entityId: entityId, timestampMillis: now, payloadJson: jsonEncode(payload), createdAtMillis: now,
    ));
    await enqueueDocument(relativePath: 'learning_events/$id', documentId: id, payload: body, queueId: 'event:$id');
    if (kDebugMode) {
      debugPrint('[AmiNProgress] event_created {type: ${type.name}, entityType: ${entityType.name}, entityId: $entityId}');
    }
  }

  Future<void> enqueueDocument({required String relativePath, required String documentId, required Map<String, Object?> payload, String? queueId}) async {
    final profile = await currentProfile();
    if (profile == null) return;
    final now = _now;
    await db.into(db.syncQueueItems).insertOnConflictUpdate(SyncQueueItemsCompanion.insert(
      queueId: queueId ?? '$relativePath:$documentId', localProfileId: profile.localId,
      documentPath: relativePath, documentId: documentId, payloadJson: jsonEncode(payload), createdAtMillis: now, updatedAtMillis: now,
    ));
  }

  Future<int> pendingCount() async {
    final count = db.syncQueueItems.queueId.count();
    final query = db.selectOnly(db.syncQueueItems)..addColumns([count])..where(db.syncQueueItems.status.isIn(['pending', 'failed']));
    return (await query.getSingle()).read(count) ?? 0;
  }

  Future<void> enqueueSummary(ProgressSnapshot snapshot) {
    return enqueueDocument(
      relativePath: 'summary/current',
      documentId: 'current',
      payload: {
        'schemaVersion': 1,
        'overallProgress': snapshot.overallRatio,
        'lessonsCompleted': snapshot.totalLearningReached,
        'quizQuestionsCompleted': snapshot.quizAnswered,
        'quizCorrectAnswers': snapshot.quizAutoCorrect,
        'quizAutoTotal': snapshot.quizAutoTotal,
        'quizLevelsCompleted': snapshot.quizSessionsCompleted,
        'averageQuizAccuracy': snapshot.quizAccuracyRatio,
        'gamesCompleted': snapshot.gameSessionsCompleted,
        'gameScoreEarned': snapshot.gameStarsEarned,
        'gameScorePossible': snapshot.gameStarsPossible,
        'updatedAtMillis': snapshot.lastUpdatedUtcMillis,
      },
    );
  }

  Future<void> resetStaleSyncing() => (db.update(db.syncQueueItems)..where((t) => t.status.equals('syncing'))).write(const SyncQueueItemsCompanion(status: Value('pending')));

  Future<void> clearLocalData() async {
    await db.transaction(() async {
      await db.delete(db.syncQueueItems).go();
      await db.delete(db.learningEvents).go();
      await db.delete(db.quizAnswers).go();
      await db.delete(db.quizAttempts).go();
      await db.delete(db.gameSessions).go();
      await db.delete(db.learningSessions).go();
      await db.delete(db.lessonProgressRows).go();
      await db.delete(db.legacyProgressBaselines).go();
      await db.delete(db.installations).go();
      await db.delete(db.studentProfiles).go();
    });
  }

  static int get _now => DateTime.now().toUtc().millisecondsSinceEpoch;
  static int _max(int a, int b) => a > b ? a : b;
}
