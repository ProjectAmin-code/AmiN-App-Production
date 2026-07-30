enum SyncItemStatus { pending, syncing, synced, failed }

enum LearningEventType {
  appOpened,
  learningSessionStarted,
  learningSessionEnded,
  lessonStarted,
  lessonResumed,
  lessonCompleted,
  lessonRevisited,
  quizStarted,
  quizQuestionAnswered,
  quizCompleted,
  quizAbandoned,
  gameStarted,
  gameCompleted,
  gameAbandoned,
}

enum LearningEntityType { app, session, lesson, quiz, question, game }

enum AminGameType { pilihPantas, cariKumpul, cariBulatkan, betulAtauSalah }

class SyncStatus {
  const SyncStatus({
    this.inProgress = false,
    this.pendingCount = 0,
    this.lastSuccessfulSync,
    this.lastResult,
  });

  final bool inProgress;
  final int pendingCount;
  final DateTime? lastSuccessfulSync;
  final String? lastResult;
}

