import 'package:flutter/material.dart';

import '../models/quiz_level.dart';

String quizLevelLabel(QuizLevel level) {
  switch (level) {
    case QuizLevel.easy:
      return 'Mudah';
    case QuizLevel.medium:
      return 'Sederhana';
    case QuizLevel.hard:
      return 'Sukar';
  }
}

String quizLevelTrackingSuffix(QuizLevel level) {
  switch (level) {
    case QuizLevel.easy:
      return 'EASY';
    case QuizLevel.medium:
      return 'MEDIUM';
    case QuizLevel.hard:
      return 'HARD';
  }
}

Color quizLevelColor(QuizLevel level) {
  switch (level) {
    case QuizLevel.easy:
      return const Color(0xFF2EAD63);
    case QuizLevel.medium:
      return const Color(0xFFF4A52E);
    case QuizLevel.hard:
      return const Color(0xFFE45832);
  }
}

Color quizLevelBackground(QuizLevel level) {
  switch (level) {
    case QuizLevel.easy:
      return const Color(0xFFEAF7FF);
    case QuizLevel.medium:
      return const Color(0xFFFFF5E8);
    case QuizLevel.hard:
      return const Color(0xFFFFF0EE);
  }
}

int quizLevelStars(QuizLevel level) {
  switch (level) {
    case QuizLevel.easy:
      return 1;
    case QuizLevel.medium:
      return 2;
    case QuizLevel.hard:
      return 3;
  }
}

QuizLevel? nextQuizLevel(QuizLevel? level) {
  switch (level) {
    case QuizLevel.easy:
      return QuizLevel.medium;
    case QuizLevel.medium:
      return QuizLevel.hard;
    case QuizLevel.hard:
    case null:
      return null;
  }
}
