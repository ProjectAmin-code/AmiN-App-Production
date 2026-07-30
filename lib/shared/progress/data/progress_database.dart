import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'progress_database.g.dart';

class StudentProfiles extends Table {
  TextColumn get localId => text()();
  TextColumn get firebaseUid => text().nullable()();
  TextColumn get publicStudentId => text().unique()();
  TextColumn get displayName => text()();
  TextColumn get authState => text().withDefault(const Constant('pending'))();
  TextColumn get legacyUserId => text().nullable()();
  IntColumn get createdAtMillis => integer()();
  IntColumn get updatedAtMillis => integer()();

  @override
  Set<Column<Object>> get primaryKey => {localId};
}

class Installations extends Table {
  TextColumn get installationId => text()();
  TextColumn get localProfileId => text()();
  TextColumn get platform => text()();
  TextColumn get appVersion => text()();
  IntColumn get firstSeenAtMillis => integer()();
  IntColumn get lastSeenAtMillis => integer()();
  IntColumn get lastSyncAtMillis => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {installationId};
}

class LessonProgressRows extends Table {
  TextColumn get localProfileId => text()();
  TextColumn get lessonId => text()();
  TextColumn get status => text().withDefault(const Constant('started'))();
  IntColumn get startedAtMillis => integer()();
  IntColumn get completedAtMillis => integer().nullable()();
  IntColumn get totalTimeSpentSeconds => integer().withDefault(const Constant(0))();
  IntColumn get visitCount => integer().withDefault(const Constant(1))();
  IntColumn get updatedAtMillis => integer()();

  @override
  Set<Column<Object>> get primaryKey => {localProfileId, lessonId};
}

class QuizAttempts extends Table {
  TextColumn get attemptId => text()();
  TextColumn get localProfileId => text()();
  TextColumn get quizId => text()();
  TextColumn get quizLevel => text()();
  TextColumn get status => text().withDefault(const Constant('started'))();
  IntColumn get startedAtMillis => integer()();
  IntColumn get completedAtMillis => integer().nullable()();
  IntColumn get normalQuestionsTotal => integer().withDefault(const Constant(10))();
  IntColumn get bonusQuestionsTotal => integer().withDefault(const Constant(2))();
  IntColumn get correctAnswers => integer().withDefault(const Constant(0))();
  IntColumn get wrongAnswers => integer().withDefault(const Constant(0))();
  IntColumn get bonusCorrect => integer().withDefault(const Constant(0))();
  IntColumn get totalScore => integer().withDefault(const Constant(0))();
  IntColumn get durationSeconds => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {attemptId};
}

class QuizAnswers extends Table {
  TextColumn get answerId => text()();
  TextColumn get attemptId => text()();
  TextColumn get questionId => text()();
  TextColumn get selectedAnswer => text()();
  BoolColumn get isAutoGraded => boolean().withDefault(const Constant(true))();
  BoolColumn get isCorrect => boolean()();
  BoolColumn get isBonusQuestion => boolean()();
  IntColumn get responseTimeMilliseconds => integer()();
  IntColumn get attemptNumber => integer().withDefault(const Constant(1))();
  BoolColumn get hintUsed => boolean().nullable()();
  IntColumn get answeredAtMillis => integer()();

  @override
  Set<Column<Object>> get primaryKey => {answerId};
}

class GameSessions extends Table {
  TextColumn get gameSessionId => text()();
  TextColumn get localProfileId => text()();
  TextColumn get gameType => text()();
  TextColumn get gameId => text()();
  TextColumn get status => text().withDefault(const Constant('started'))();
  IntColumn get startedAtMillis => integer()();
  IntColumn get completedAtMillis => integer().nullable()();
  IntColumn get durationSeconds => integer().withDefault(const Constant(0))();
  IntColumn get score => integer().nullable()();
  IntColumn get correctCount => integer().nullable()();
  IntColumn get wrongCount => integer().nullable()();
  IntColumn get attemptCount => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {gameSessionId};
}

class LearningSessions extends Table {
  TextColumn get sessionId => text()();
  TextColumn get localProfileId => text()();
  IntColumn get startedAtMillis => integer()();
  IntColumn get endedAtMillis => integer().nullable()();
  IntColumn get activeLearningSeconds => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('active'))();

  @override
  Set<Column<Object>> get primaryKey => {sessionId};
}

class LearningEvents extends Table {
  TextColumn get eventId => text()();
  TextColumn get localProfileId => text()();
  TextColumn get firebaseUid => text().nullable()();
  TextColumn get installationId => text()();
  TextColumn get eventType => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  IntColumn get timestampMillis => integer()();
  TextColumn get payloadJson => text()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  IntColumn get createdAtMillis => integer()();
  IntColumn get syncedAtMillis => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {eventId};
}

class SyncQueueItems extends Table {
  TextColumn get queueId => text()();
  TextColumn get localProfileId => text()();
  TextColumn get documentPath => text()();
  TextColumn get documentId => text()();
  TextColumn get payloadJson => text()();
  IntColumn get payloadVersion => integer().withDefault(const Constant(1))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();
  IntColumn get nextAttemptAtMillis => integer().nullable()();
  TextColumn get lastError => text().nullable()();
  IntColumn get createdAtMillis => integer()();
  IntColumn get updatedAtMillis => integer()();

  @override
  Set<Column<Object>> get primaryKey => {queueId};
}

class SyncMetadataRows extends Table {
  TextColumn get localProfileId => text()();
  IntColumn get lastSyncAtMillis => integer().nullable()();
  TextColumn get lastResult => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {localProfileId};
}

class LegacyProgressBaselines extends Table {
  TextColumn get localProfileId => text()();
  IntColumn get onboardingReached => integer().withDefault(const Constant(0))();
  IntColumn get belajarReached => integer().withDefault(const Constant(0))();
  IntColumn get learningReached => integer().withDefault(const Constant(0))();
  IntColumn get quizAnswered => integer().withDefault(const Constant(0))();
  IntColumn get quizAutoCorrect => integer().withDefault(const Constant(0))();
  IntColumn get quizAutoTotal => integer().withDefault(const Constant(0))();
  IntColumn get quizSessionsCompleted => integer().withDefault(const Constant(0))();
  IntColumn get gameStarsEarned => integer().withDefault(const Constant(0))();
  IntColumn get gameStarsPossible => integer().withDefault(const Constant(0))();
  IntColumn get gameSessionsCompleted => integer().withDefault(const Constant(0))();
  IntColumn get migratedAtMillis => integer()();

  @override
  Set<Column<Object>> get primaryKey => {localProfileId};
}

@DriftDatabase(
  tables: [
    StudentProfiles,
    Installations,
    LessonProgressRows,
    QuizAttempts,
    QuizAnswers,
    GameSessions,
    LearningSessions,
    LearningEvents,
    SyncQueueItems,
    SyncMetadataRows,
    LegacyProgressBaselines,
  ],
)
class ProgressDatabase extends _$ProgressDatabase {
  ProgressDatabase._() : super(_openConnection());

  ProgressDatabase.forTesting(super.executor);

  static final ProgressDatabase instance = ProgressDatabase._();

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final directory = await getApplicationDocumentsDirectory();
      return NativeDatabase.createInBackground(
        File('${directory.path}/amin_progress.sqlite'),
      );
    });
  }
}
