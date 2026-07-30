import 'package:aminapp/quiz/logic/quiz_logic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  QuizQuestionAnswerResult answer(String id, {required bool isCorrect}) {
    return QuizQuestionAnswerResult(
      id: id,
      label: 'Question $id',
      userAnswer: 'user-$id',
      correctAnswer: 'correct-$id',
      isCorrect: isCorrect,
    );
  }

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

  test('one question correct', () {
    final result = QuizAnswerGroupResult(
      questions: [answer('1', isCorrect: true)],
    );

    expect(result.allCorrect, isTrue);
    expect(result.anyCorrect, isTrue);
    expect(result.overallStatus, QuizAnswerOverallStatus.correct);
  });

  test('one question incorrect', () {
    final result = QuizAnswerGroupResult(
      questions: [answer('1', isCorrect: false)],
    );

    expect(result.allCorrect, isFalse);
    expect(result.anyCorrect, isFalse);
    expect(result.overallStatus, QuizAnswerOverallStatus.incorrect);
  });

  test('two questions both correct', () {
    final result = QuizAnswerGroupResult(
      questions: [
        answer('1', isCorrect: true),
        answer('2', isCorrect: true),
      ],
    );

    expect(result.overallStatus, QuizAnswerOverallStatus.correct);
  });

  test('two questions mixed reveal only the incorrect answer', () {
    final result = QuizAnswerGroupResult(
      questions: [
        answer('1', isCorrect: true),
        answer('2', isCorrect: false),
      ],
    );

    expect(result.overallStatus, QuizAnswerOverallStatus.partial);
    expect(
      result.questions
          .where((answer) => !answer.isCorrect)
          .map((answer) => answer.id),
      ['2'],
    );
  });

  test('two questions both incorrect reveal both answers', () {
    final result = QuizAnswerGroupResult(
      questions: [
        answer('1', isCorrect: false),
        answer('2', isCorrect: false),
      ],
    );

    expect(result.overallStatus, QuizAnswerOverallStatus.incorrect);
    expect(
      result.questions.where((answer) => !answer.isCorrect).length,
      2,
    );
  });

  test('three mixed questions preserve order and reveal only wrong rows', () {
    final result = QuizAnswerGroupResult(
      questions: [
        answer('first', isCorrect: false),
        answer('second', isCorrect: true),
        answer('third', isCorrect: false),
      ],
    );

    expect(
      result.questions.map((answer) => answer.id),
      ['first', 'second', 'third'],
    );
    expect(result.overallStatus, QuizAnswerOverallStatus.partial);
    expect(
      result.questions
          .where((answer) => !answer.isCorrect)
          .map((answer) => answer.id),
      ['first', 'third'],
    );
  });
}
