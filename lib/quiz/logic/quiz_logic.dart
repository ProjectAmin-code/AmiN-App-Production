import 'dart:math';

String normalizeQuizText(String input) {
  return input
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9\s,-]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

String normalizeCommaSeparatedAnswers(String input) {
  final parts = input
      .split(',')
      .map((part) => normalizeQuizText(part).replaceAll(',', '').trim())
      .where((part) => part.isNotEmpty)
      .toList(growable: false);
  return parts.join(',');
}

bool matchesCommaSeparatedAnswers(String input, List<String> expectedAnswers) {
  final normalizedExpected = expectedAnswers
      .map((answer) => normalizeQuizText(answer).replaceAll(',', '').trim())
      .where((answer) => answer.isNotEmpty)
      .join(',');
  return normalizeCommaSeparatedAnswers(input) == normalizedExpected;
}

List<String> availableUniqueChoices(
  List<String> allChoices,
  List<String?> selections,
  int currentIndex,
) {
  final currentValue = selections[currentIndex];
  final takenByOthers = selections
      .asMap()
      .entries
      .where((entry) => entry.key != currentIndex)
      .map((entry) => entry.value)
      .whereType<String>()
      .toSet();

  return allChoices
      .where((choice) {
        if (choice == currentValue) {
          return true;
        }
        return !takenByOthers.contains(choice);
      })
      .toList(growable: false);
}

int quizStarsForScore({
  required int correctAnswers,
  required int totalQuestions,
}) {
  if (totalQuestions <= 0) {
    return 1;
  }
  final ratio = correctAnswers / totalQuestions;
  if (ratio >= 0.8) {
    return 3;
  }
  if (ratio >= 0.5) {
    return 2;
  }
  return 1;
}

int bonusXpForCorrectAnswers(int correctBonusAnswers, {int xpPerAnswer = 10}) {
  return max(0, correctBonusAnswers) * xpPerAnswer;
}
