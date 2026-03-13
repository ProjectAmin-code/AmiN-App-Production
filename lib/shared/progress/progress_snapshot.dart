class ProgressSnapshot {
  const ProgressSnapshot({
    required this.onboardingReached,
    required this.onboardingTotal,
    required this.belajarReached,
    required this.belajarTotal,
    required this.learningReached,
    required this.learningTotal,
    required this.quizAnswered,
    required this.quizAutoCorrect,
    required this.quizAutoTotal,
    required this.quizQuestionGoal,
    required this.quizSessionsCompleted,
    required this.gameStarsEarned,
    required this.gameStarsPossible,
    required this.gameSessionsCompleted,
    required this.lastUpdatedUtcMillis,
  });

  factory ProgressSnapshot.empty() {
    return ProgressSnapshot(
      onboardingReached: 0,
      onboardingTotal: 3,
      belajarReached: 0,
      belajarTotal: 3,
      learningReached: 0,
      learningTotal: 15,
      quizAnswered: 0,
      quizAutoCorrect: 0,
      quizAutoTotal: 0,
      quizQuestionGoal: 32,
      quizSessionsCompleted: 0,
      gameStarsEarned: 0,
      gameStarsPossible: 0,
      gameSessionsCompleted: 0,
      lastUpdatedUtcMillis: DateTime.now().toUtc().millisecondsSinceEpoch,
    );
  }

  factory ProgressSnapshot.fromJson(Map<String, dynamic> json) {
    int intValue(String key, int fallback) {
      final value = json[key];
      if (value is int) {
        return value;
      }
      if (value is num) {
        return value.toInt();
      }
      return fallback;
    }

    return ProgressSnapshot(
      onboardingReached: intValue('onboardingReached', 0),
      onboardingTotal: intValue('onboardingTotal', 3),
      belajarReached: intValue('belajarReached', 0),
      belajarTotal: intValue('belajarTotal', 3),
      learningReached: intValue('learningReached', 0),
      learningTotal: intValue('learningTotal', 15),
      quizAnswered: intValue('quizAnswered', 0),
      quizAutoCorrect: intValue('quizAutoCorrect', 0),
      quizAutoTotal: intValue('quizAutoTotal', 0),
      quizQuestionGoal: intValue('quizQuestionGoal', 32),
      quizSessionsCompleted: intValue('quizSessionsCompleted', 0),
      gameStarsEarned: intValue('gameStarsEarned', 0),
      gameStarsPossible: intValue('gameStarsPossible', 0),
      gameSessionsCompleted: intValue('gameSessionsCompleted', 0),
      lastUpdatedUtcMillis: intValue(
        'lastUpdatedUtcMillis',
        DateTime.now().toUtc().millisecondsSinceEpoch,
      ),
    );
  }

  final int onboardingReached;
  final int onboardingTotal;
  final int belajarReached;
  final int belajarTotal;
  final int learningReached;
  final int learningTotal;
  final int quizAnswered;
  final int quizAutoCorrect;
  final int quizAutoTotal;
  final int quizQuestionGoal;
  final int quizSessionsCompleted;
  final int gameStarsEarned;
  final int gameStarsPossible;
  final int gameSessionsCompleted;
  final int lastUpdatedUtcMillis;

  int get totalLearningReached => belajarReached + learningReached;
  int get totalLearningSteps => belajarTotal + learningTotal;

  double get onboardingRatio => _ratio(onboardingReached, onboardingTotal);
  double get belajarRatio => _ratio(totalLearningReached, totalLearningSteps);
  double get quizCompletionRatio => _ratio(quizAnswered, quizQuestionGoal);
  double get quizAccuracyRatio => _ratio(quizAutoCorrect, quizAutoTotal);

  double get quizRatio {
    if (quizAnswered == 0 && quizAutoTotal == 0) {
      return 0;
    }
    return ((quizCompletionRatio * 0.6) + (quizAccuracyRatio * 0.4)).clamp(
      0.0,
      1.0,
    );
  }

  double get gameRatio => _ratio(gameStarsEarned, gameStarsPossible);
  int get quizAccuracyPercent => (quizAccuracyRatio * 100).round();
  int get quizCompletionPercent => (quizCompletionRatio * 100).round();

  double get overallRatio => ((belajarRatio + quizRatio + gameRatio) / 3).clamp(
    0.0,
    1.0,
  );

  int get overallPercent => (overallRatio * 100).round();

  DateTime get lastUpdatedUtc =>
      DateTime.fromMillisecondsSinceEpoch(lastUpdatedUtcMillis, isUtc: true);

  ProgressSnapshot copyWith({
    int? onboardingReached,
    int? onboardingTotal,
    int? belajarReached,
    int? belajarTotal,
    int? learningReached,
    int? learningTotal,
    int? quizAnswered,
    int? quizAutoCorrect,
    int? quizAutoTotal,
    int? quizQuestionGoal,
    int? quizSessionsCompleted,
    int? gameStarsEarned,
    int? gameStarsPossible,
    int? gameSessionsCompleted,
    int? lastUpdatedUtcMillis,
  }) {
    return ProgressSnapshot(
      onboardingReached: onboardingReached ?? this.onboardingReached,
      onboardingTotal: onboardingTotal ?? this.onboardingTotal,
      belajarReached: belajarReached ?? this.belajarReached,
      belajarTotal: belajarTotal ?? this.belajarTotal,
      learningReached: learningReached ?? this.learningReached,
      learningTotal: learningTotal ?? this.learningTotal,
      quizAnswered: quizAnswered ?? this.quizAnswered,
      quizAutoCorrect: quizAutoCorrect ?? this.quizAutoCorrect,
      quizAutoTotal: quizAutoTotal ?? this.quizAutoTotal,
      quizQuestionGoal: quizQuestionGoal ?? this.quizQuestionGoal,
      quizSessionsCompleted: quizSessionsCompleted ?? this.quizSessionsCompleted,
      gameStarsEarned: gameStarsEarned ?? this.gameStarsEarned,
      gameStarsPossible: gameStarsPossible ?? this.gameStarsPossible,
      gameSessionsCompleted: gameSessionsCompleted ?? this.gameSessionsCompleted,
      lastUpdatedUtcMillis: lastUpdatedUtcMillis ?? this.lastUpdatedUtcMillis,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'onboardingReached': onboardingReached,
      'onboardingTotal': onboardingTotal,
      'belajarReached': belajarReached,
      'belajarTotal': belajarTotal,
      'learningReached': learningReached,
      'learningTotal': learningTotal,
      'quizAnswered': quizAnswered,
      'quizAutoCorrect': quizAutoCorrect,
      'quizAutoTotal': quizAutoTotal,
      'quizQuestionGoal': quizQuestionGoal,
      'quizSessionsCompleted': quizSessionsCompleted,
      'gameStarsEarned': gameStarsEarned,
      'gameStarsPossible': gameStarsPossible,
      'gameSessionsCompleted': gameSessionsCompleted,
      'lastUpdatedUtcMillis': lastUpdatedUtcMillis,
    };
  }

  static double _ratio(int value, int total) {
    if (total <= 0) {
      return 0;
    }
    return (value / total).clamp(0.0, 1.0);
  }
}
