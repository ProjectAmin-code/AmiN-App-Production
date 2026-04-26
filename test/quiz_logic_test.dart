import 'package:aminapp/quiz/logic/quiz_logic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('quizStarsForScore maps score bands to star counts', () {
    expect(quizStarsForScore(correctAnswers: 8, totalQuestions: 10), 3);
    expect(quizStarsForScore(correctAnswers: 5, totalQuestions: 10), 2);
    expect(quizStarsForScore(correctAnswers: 4, totalQuestions: 10), 1);
  });

  test('matchesCommaSeparatedAnswers ignores whitespace around commas', () {
    expect(
      matchesCommaSeparatedAnswers(
        ' membaca,  mendengar , mencari ',
        const ['membaca', 'mendengar', 'mencari'],
      ),
      isTrue,
    );
  });

  test('availableUniqueChoices keeps current choice and removes used choices', () {
    final choices = availableUniqueChoices(
      const ['menawan', 'mengitar', 'melayan'],
      const ['menawan', null, 'melayan'],
      1,
    );

    expect(choices, const ['mengitar']);
  });
}
