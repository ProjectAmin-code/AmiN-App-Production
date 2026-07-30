import 'dart:async';

import 'package:aminapp/shared/progress/data/local_progress_repository.dart';
import 'package:aminapp/shared/progress/data/progress_database.dart';
import 'package:aminapp/shared/progress/data/remote_data_sources.dart';
import 'package:aminapp/shared/progress/sync/progress_sync_coordinator.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ProgressDatabase database;
  late LocalProgressRepository local;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'AmiN',
      packageName: 'com.example.aminapp',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
    database = ProgressDatabase.forTesting(NativeDatabase.memory());
    local = LocalProgressRepository(database);
    await local.initialize();
    await local.ensureProfile('Amin');
  });

  tearDown(() => database.close());

  test('offline lesson completion updates progress and durable outbox', () async {
    await local.startLesson('S007');
    await local.completeLesson('S007');

    final snapshot = await local.loadSnapshot();
    final events = await database.select(database.learningEvents).get();

    expect(snapshot.learningReached, 1);
    expect(events.map((event) => event.eventType), containsAll(['lessonStarted', 'lessonCompleted']));
    expect(await local.pendingCount(), greaterThanOrEqualTo(3));
  });

  test('legacy snapshot migrates once without inventing attempts', () async {
    await database.close();
    SharedPreferences.setMockInitialValues({
      'amin_progress_user_v1': 'Suriya',
      'amin_progress_user_id_v1': 'legacy-uuid',
      'amin_progress_snapshot_v1':
          '{"onboardingReached":3,"belajarReached":2,"learningReached":4,"quizAnswered":7,"quizAutoCorrect":5,"quizAutoTotal":6,"gameStarsEarned":8,"gameStarsPossible":10,"gameSessionsCompleted":2}',
    });
    database = ProgressDatabase.forTesting(NativeDatabase.memory());
    local = LocalProgressRepository(database);

    await local.initialize();
    await local.initialize();

    final snapshot = await local.loadSnapshot();
    final profiles = await database.select(database.studentProfiles).get();
    expect(profiles.single.displayName, 'Suriya');
    expect(profiles.single.legacyUserId, 'legacy-uuid');
    expect(snapshot.learningReached, 4);
    expect(snapshot.quizAnswered, 7);
    expect(await database.select(database.quizAttempts).get(), isEmpty);
  });

  test('offline quiz stores attempt, answer, completion, and outbox', () async {
    final attemptId = await local.startQuiz(quizId: 'MALAYALAM_QUIZ', level: 'easy');
    await local.answerQuiz(
      attemptId: attemptId,
      questionId: 'EK1',
      selectedAnswer: 'A',
      isAutoGraded: true,
      isCorrect: true,
      isBonus: false,
      responseMillis: 900,
    );
    await local.finishQuiz(attemptId, completed: true, score: 100);

    final attempt = await (database.select(database.quizAttempts)
          ..where((row) => row.attemptId.equals(attemptId)))
        .getSingle();
    final answers = await (database.select(database.quizAnswers)
          ..where((row) => row.attemptId.equals(attemptId)))
        .get();

    expect(attempt.status, 'completed');
    expect(answers.single.questionId, 'EK1');
    expect(await local.pendingCount(), greaterThan(0));
  });

  test('completed game creates a local session', () async {
    final id = await local.startGame(gameType: 'pilih_pantas', gameId: 'M003_PilihPantas');
    await local.finishStartedGame(id, earned: 8, possible: 10, completed: true);

    final session = await (database.select(database.gameSessions)
          ..where((row) => row.gameSessionId.equals(id)))
        .getSingle();
    expect(session.status, 'completed');
    expect(session.correctCount, 8);
    expect(session.wrongCount, 2);
  });

  test('sync success marks rows synced and uses idempotent document paths', () async {
    await local.completeLesson('S007');
    final remote = _FakeRemote();
    final coordinator = ProgressSyncCoordinator(
      database: database,
      local: local,
      remote: remote,
      uidProvider: () => 'firebase-user',
    );

    expect(await coordinator.syncNow(), isTrue);
    final queue = await database.select(database.syncQueueItems).get();
    expect(queue, isNotEmpty);
    expect(queue.every((row) => row.status == 'synced'), isTrue);
    expect(remote.paths.toSet().length, remote.paths.length);
    await coordinator.dispose();
  });

  test('sync failure retains learning data and makes rows retryable', () async {
    await local.completeLesson('S007');
    final coordinator = ProgressSyncCoordinator(
      database: database,
      local: local,
      remote: _FakeRemote(fail: true),
      uidProvider: () => 'firebase-user',
    );

    await coordinator.syncNow();
    final queue = await database.select(database.syncQueueItems).get();
    final lesson = await database.select(database.lessonProgressRows).getSingle();
    expect(queue.every((row) => row.status == 'failed'), isTrue);
    expect(lesson.status, 'completed');
    await coordinator.dispose();
  });

  test('manual retry reuses the same cloud document IDs', () async {
    await local.completeLesson('S007');
    final remote = _FailOnceRemote();
    final coordinator = ProgressSyncCoordinator(
      database: database,
      local: local,
      remote: remote,
      uidProvider: () => 'firebase-user',
    );

    await coordinator.syncNow();
    await coordinator.syncNow(ignoreBackoff: true);

    final queue = await database.select(database.syncQueueItems).get();
    expect(queue.every((row) => row.status == 'synced'), isTrue);
    expect(remote.successfulPaths.toSet().length, remote.successfulPaths.length);
    await coordinator.dispose();
  });

  test('concurrent sync triggers run only one remote batch', () async {
    await local.completeLesson('S007');
    final remote = _BlockingRemote();
    final coordinator = ProgressSyncCoordinator(
      database: database,
      local: local,
      remote: remote,
      uidProvider: () => 'firebase-user',
    );

    final first = coordinator.syncNow();
    await remote.started.future;
    expect(await coordinator.syncNow(), isFalse);
    remote.release.complete();
    expect(await first, isTrue);
    expect(remote.calls, 1);
    await coordinator.dispose();
  });
}

class _FakeRemote implements SyncRemoteDataSource {
  _FakeRemote({this.fail = false});

  final bool fail;
  final List<String> paths = [];

  @override
  Future<void> writeBatch(List<RemoteWrite> writes) async {
    if (fail) throw StateError('offline');
    paths.addAll(writes.map((write) => write.path));
  }
}

class _FailOnceRemote implements SyncRemoteDataSource {
  bool _failed = false;
  final List<String> successfulPaths = [];

  @override
  Future<void> writeBatch(List<RemoteWrite> writes) async {
    if (!_failed) {
      _failed = true;
      throw StateError('temporary failure');
    }
    successfulPaths.addAll(writes.map((write) => write.path));
  }
}

class _BlockingRemote implements SyncRemoteDataSource {
  final Completer<void> started = Completer<void>();
  final Completer<void> release = Completer<void>();
  int calls = 0;

  @override
  Future<void> writeBatch(List<RemoteWrite> writes) async {
    calls += 1;
    if (!started.isCompleted) started.complete();
    await release.future;
  }
}
