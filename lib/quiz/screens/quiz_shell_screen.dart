import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/audio/answer_audio_cue.dart';
import '../../shared/design/app_design_tokens.dart';
import '../../shared/gamification/gamification.dart';
import '../../shared/motion/app_motion_navigation.dart';
import '../../shared/motion/app_motion_spec.dart';
import '../../shared/progress/progress_tracker.dart';
import '../../shared/widgets/adaptive_asset_image.dart';
import '../constants/quiz_tokens.dart';
import '../data/quiz_bank.dart';
import '../logic/quiz_logic.dart';
import '../logic/quiz_level_utils.dart';
import '../logic/quiz_shuffle.dart';
import '../models/quiz_interaction_type.dart';
import '../models/quiz_level.dart';
import '../models/quiz_option.dart';
import '../models/quiz_question.dart';
import '../widgets/quiz_input_builders.dart';
import 'quiz_result_screen.dart';

class QuizShellScreen extends StatefulWidget {
  const QuizShellScreen({super.key, required this.name, this.level});

  final String name;
  final QuizLevel? level;

  @override
  State<QuizShellScreen> createState() => _QuizShellScreenState();
}

class _QuizShellScreenState extends State<QuizShellScreen> {
  // Debug-only quiz jump control. Set to false to hide it without removing code.
  static const bool _enableQuizBypasser = kDebugMode;
  late List<QuizQuestion> _questions;
  final Map<String, Set<String>> _selectedOptionIds = <String, Set<String>>{};
  final Map<String, String> _typedAnswers = <String, String>{};
  final Map<String, List<String?>> _matchingSelections =
      <String, List<String?>>{};
  final Map<String, List<String?>> _dragSelections = <String, List<String?>>{};
  final Map<String, bool> _autoResults = <String, bool>{};
  final Set<String> _manualCompleted = <String>{};
  final Map<String, List<QuizOption>> _optionOrder =
      <String, List<QuizOption>>{};
  final Map<String, List<String>> _matchingChoiceOrder =
      <String, List<String>>{};
  final Map<String, List<String>> _dragChoiceOrder = <String, List<String>>{};
  final Random _screenLoadRandom = Random();
  static const String _firstQuestionWithSeparatedMOptions = 'EK1';

  int _currentIndex = 0;
  DateTime _questionShownAt = DateTime.now();
  bool _quizFinished = false;

  bool _startsWithM(QuizOption option) =>
      option.label.trim().toLowerCase().startsWith('m');

  bool _isEasyCompactQuestion(QuizQuestion question) =>
      question.level == QuizLevel.easy && question.id != 'EK1';

  List<QuizOption> _jumbledOptionsForLoad(QuizQuestion question) {
    if (question.id == _firstQuestionWithSeparatedMOptions) {
      return shuffleForLoadWithSeparatedGroup<QuizOption>(
        items: question.options,
        random: _screenLoadRandom,
        shouldBeSeparated: _startsWithM,
      );
    }
    return shuffleForLoad<QuizOption>(
      items: question.options,
      random: _screenLoadRandom,
    );
  }

  @override
  void initState() {
    super.initState();
    _reloadQuestionDefinitions();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(
        ProgressTracker.instance.beginQuiz(
          quizId: 'MALAYALAM_QUIZ',
          level: widget.level?.name ?? 'all',
        ),
      );
    });
  }

  @override
  void dispose() {
    if (!_quizFinished) unawaited(ProgressTracker.instance.abandonQuiz());
    super.dispose();
  }

  void _reloadQuestionDefinitions() {
    final allQuestions = QuizBank.questions.toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    _questions = widget.level == null
        ? allQuestions
        : allQuestions.where((q) => q.level == widget.level).toList();
    _optionOrder.clear();
    _matchingChoiceOrder.clear();
    _dragChoiceOrder.clear();
    for (final question in _questions) {
      _optionOrder[question.id] =
          (question.shuffleOptions ||
              question.id == _firstQuestionWithSeparatedMOptions)
          ? _jumbledOptionsForLoad(question)
          : question.options;
      _matchingChoiceOrder[question.id] = question.shuffleChoices
          ? shuffleForLoad<String>(
              items: question.matchingChoices,
              random: _screenLoadRandom,
            )
          : question.matchingChoices;
      _dragChoiceOrder[question.id] = question.shuffleChoices
          ? shuffleForLoad<String>(
              items: question.dragChoices,
              random: _screenLoadRandom,
            )
          : question.dragChoices;
    }
  }

  @override
  void reassemble() {
    final currentQuestionId = _questions.isEmpty
        ? null
        : _questions[_currentIndex].id;
    super.reassemble();
    _reloadQuestionDefinitions();
    if (currentQuestionId != null) {
      final refreshedIndex = _questions.indexWhere(
        (question) => question.id == currentQuestionId,
      );
      _currentIndex = refreshedIndex < 0 ? 0 : refreshedIndex;
    }
  }

  QuizQuestion get _currentQuestion => _questions[_currentIndex];
  bool get _isLastQuestion => _currentIndex == _questions.length - 1;

  Set<String> _selectedFor(QuizQuestion question) =>
      _selectedOptionIds[question.id] ?? <String>{};

  List<QuizOption> _optionsFor(QuizQuestion question) =>
      _optionOrder[question.id] ?? question.options;

  List<String?> _matchingFor(QuizQuestion question) {
    final expectedLength = question.matchingLeft.length;
    final existing = _matchingSelections[question.id];
    if (existing == null) {
      return _matchingSelections[question.id] =
          List<String?>.filled(expectedLength, null);
    }
    if (existing.length == expectedLength) {
      return existing;
    }

    final resized = List<String?>.filled(expectedLength, null);
    final copyLength = existing.length < expectedLength
        ? existing.length
        : expectedLength;
    for (var i = 0; i < copyLength; i++) {
      resized[i] = existing[i];
    }
    return _matchingSelections[question.id] = resized;
  }

  List<String?> _dragFor(QuizQuestion question) {
    final expectedLength = question.dragTargets.length;
    final existing = _dragSelections[question.id];
    if (existing == null) {
      return _dragSelections[question.id] =
          List<String?>.filled(expectedLength, null);
    }
    if (existing.length == expectedLength) {
      return existing;
    }

    final resized = List<String?>.filled(expectedLength, null);
    final copyLength = existing.length < expectedLength
        ? existing.length
        : expectedLength;
    for (var i = 0; i < copyLength; i++) {
      resized[i] = existing[i];
    }
    return _dragSelections[question.id] = resized;
  }

  List<String> _matchingChoicesFor(QuizQuestion question, int index) {
    if (question.matchingChoicesByTarget.isNotEmpty) {
      return question.matchingChoicesByTarget[index].toList(growable: false);
    }

    return _matchingChoiceOrder[question.id] ?? question.matchingChoices;
  }

  List<String> _dragChoicesFor(QuizQuestion question) {
    final choices = _dragChoiceOrder[question.id] ?? question.dragChoices;
    if (question.allowRepeatedChoices) {
      return choices;
    }
    final selectedValues = _dragFor(question).whereType<String>().toList();
    return choices
        .where((choice) => !selectedValues.contains(choice))
        .toList(growable: false);
  }

  void _setSingleChoice(QuizQuestion question, String value) {
    setState(() {
      _selectedOptionIds[question.id] = <String>{value};
    });
  }

  void _toggleMultiChoice(QuizQuestion question, QuizOption option) {
    final current = _selectedFor(question).toSet();
    if (current.contains(option.id)) {
      current.remove(option.id);
    } else {
      current.add(option.id);
    }
    setState(() {
      _selectedOptionIds[question.id] = current;
    });
  }

  void _setMatchingChoice(QuizQuestion question, int index, String? value) {
    final current = _matchingFor(question).toList();
    current[index] = value;
    setState(() {
      _matchingSelections[question.id] = current;
    });
  }

  void _setDragChoice(QuizQuestion question, int index, String value) {
    final current = _dragFor(question).toList();
    if (question.allowRepeatedChoices) {
      current[index] = value;
      setState(() {
        _dragSelections[question.id] = current;
      });
      return;
    }
    final oldValue = current[index];
    final duplicateIndex = current.indexOf(value);
    if (duplicateIndex != -1) {
      current[duplicateIndex] = oldValue;
    }
    current[index] = value;
    setState(() {
      _dragSelections[question.id] = current;
    });
  }

  void _clearDragChoice(QuizQuestion question, int index) {
    final current = _dragFor(question).toList();
    current[index] = null;
    setState(() {
      _dragSelections[question.id] = current;
    });
  }

  bool _evaluateAutoQuestion(QuizQuestion question) {
    if (question.correctOptionIds.isNotEmpty) {
      final selected = _selectedFor(question);
      return selected.length == question.correctOptionIds.length &&
          selected.containsAll(question.correctOptionIds);
    }

    if (question.acceptableTextAnswers.isNotEmpty) {
      final rawTyped = _typedAnswers[question.id] ?? '';
      final typed = normalizeQuizText(rawTyped);
      if (typed.isEmpty) {
        return false;
      }

      if (question.acceptableTextAnswers.length == 1) {
        return typed == normalizeQuizText(question.acceptableTextAnswers.first);
      }

      if (question.id == 'HK10') {
        return matchesCommaSeparatedAnswers(
          rawTyped,
          question.acceptableTextAnswers,
        );
      }

      final requiredAnswers = question.acceptableTextAnswers
          .map(normalizeQuizText)
          .toList(growable: false);
      return requiredAnswers.every(typed.contains);
    }

    if (question.interactionType == QuizInteractionType.matching &&
        question.matchingAnswers.isNotEmpty) {
      final selected = _matchingFor(question);
      if (selected.length != question.matchingAnswers.length ||
          selected.any((value) => value == null || value.trim().isEmpty)) {
        return false;
      }
      for (var i = 0; i < question.matchingAnswers.length; i++) {
        if (normalizeQuizText(selected[i]!) !=
            normalizeQuizText(question.matchingAnswers[i])) {
          return false;
        }
      }
      return true;
    }

    if (question.interactionType == QuizInteractionType.dragDrop &&
        question.dragAnswers.isNotEmpty) {
      final selected = _dragFor(question);
      if (selected.length != question.dragAnswers.length ||
          selected.any((value) => value == null || value.trim().isEmpty)) {
        return false;
      }
      for (var i = 0; i < question.dragAnswers.length; i++) {
        if (normalizeQuizText(selected[i]!) !=
            normalizeQuizText(question.dragAnswers[i])) {
          return false;
        }
      }
      return true;
    }

    return false;
  }

  bool _canSubmit(QuizQuestion question) {
    if (!question.isAutoGraded) {
      return true;
    }

    switch (question.interactionType) {
      case QuizInteractionType.singleChoice:
      case QuizInteractionType.multiSelect:
        return _selectedFor(question).isNotEmpty;
      case QuizInteractionType.textInput:
        final typedAnswer = _typedAnswers[question.id] ?? '';
        if (question.id == 'HK10') {
          final answers = typedAnswer.split(',');
          return answers.length == 3 &&
              answers.every((answer) => answer.trim().isNotEmpty);
        }
        return typedAnswer.trim().isNotEmpty;
      case QuizInteractionType.matching:
        final selected = _matchingFor(question);
        return selected.isNotEmpty && selected.every((value) => value != null);
      case QuizInteractionType.dragDrop:
        final selected = _dragFor(question);
        return selected.isNotEmpty && selected.every((value) => value != null);
    }
  }

  Future<void> _goNext() async {
    if (_isLastQuestion) {
      final scoredQuestions = _questions.where(
        (q) => q.isAutoGraded && !q.isBonus,
      );
      final bonusQuestions = _questions.where(
        (q) => q.isAutoGraded && q.isBonus,
      );
      final autoGradedCount = scoredQuestions.length;
      final correctCount = scoredQuestions
          .where((question) => _autoResults[question.id] == true)
          .length;
      final bonusCorrectCount = bonusQuestions
          .where((question) => _autoResults[question.id] == true)
          .length;
      final quizPercent = autoGradedCount == 0
          ? 100
          : ((correctCount / autoGradedCount) * 100).round();
      final levelSuffix = widget.level == null
          ? 'ALL'
          : quizLevelTrackingSuffix(widget.level!);
      _quizFinished = true;
      await ProgressTracker.instance.recordQuizSessionCompleted(
        lessonId: 'QUIZ_LEVEL_$levelSuffix',
        score: quizPercent,
      );
      if (!mounted) {
        return;
      }
      pushReplacementAdaptive(
        context,
        QuizResultScreen(
          name: widget.name,
          level: widget.level,
          totalQuestions: autoGradedCount,
          autoGradedQuestions: autoGradedCount,
          correctAnswers: correctCount,
          manualCompleted: _manualCompleted.length,
          bonusCorrectAnswers: bonusCorrectCount,
        ),
      );
      return;
    }

    setState(() {
      _currentIndex += 1;
      _questionShownAt = DateTime.now();
    });
  }

  String _selectedAnswer(QuizQuestion question) {
    if (_typedAnswers.containsKey(question.id)) return _typedAnswers[question.id]!;
    if (_selectedOptionIds.containsKey(question.id)) {
      return (_selectedOptionIds[question.id]!.toList()..sort()).join('|');
    }
    if (_matchingSelections.containsKey(question.id)) {
      return _matchingSelections[question.id]!.map((v) => v ?? '').join('|');
    }
    if (_dragSelections.containsKey(question.id)) {
      return _dragSelections[question.id]!.map((v) => v ?? '').join('|');
    }
    return '';
  }

  void _jumpToQuestion(int questionIndex) {
    if (questionIndex < 0 ||
        questionIndex >= _questions.length ||
        questionIndex == _currentIndex) {
      return;
    }
    setState(() {
      _currentIndex = questionIndex;
    });
  }

  Future<void> _openQuizBypasser() async {
    final selectedIndex = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Jump to quiz question'),
          content: SizedBox(
            width: 360,
            height: 420,
            child: ListView.builder(
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final question = _questions[index];
                final isCurrentQuestion = index == _currentIndex;
                return ListTile(
                  dense: true,
                  selected: isCurrentQuestion,
                  leading: CircleAvatar(
                    radius: 16,
                    child: Text('${index + 1}'),
                  ),
                  title: Text(question.id),
                  subtitle: Text(
                    question.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: isCurrentQuestion ? const Icon(Icons.check) : null,
                  onTap: () => Navigator.of(dialogContext).pop(index),
                );
              },
            ),
          ),
        );
      },
    );
    if (selectedIndex != null) {
      _jumpToQuestion(selectedIndex);
    }
  }

  QuizAnswerGroupResult _answerGroupResultFor(QuizQuestion question) {
    if (question.interactionType == QuizInteractionType.matching &&
        question.matchingAnswers.isNotEmpty) {
      final selected = _matchingFor(question);
      return QuizAnswerGroupResult(
        questions: List.generate(question.matchingAnswers.length, (index) {
          final userAnswer = selected[index] ?? '';
          final correctAnswer = question.matchingAnswers[index];
          final label = index < question.matchingLeft.length
              ? question.matchingLeft[index]
              : 'Jawapan ${index + 1}';
          return QuizQuestionAnswerResult(
            id: '${question.id}-${index + 1}',
            label: label,
            userAnswer: userAnswer,
            correctAnswer: correctAnswer,
            isCorrect:
                normalizeQuizText(userAnswer) ==
                normalizeQuizText(correctAnswer),
          );
        }),
      );
    }

    if (question.interactionType == QuizInteractionType.dragDrop &&
        question.dragAnswers.isNotEmpty) {
      final selected = _dragFor(question);
      return QuizAnswerGroupResult(
        questions: List.generate(question.dragAnswers.length, (index) {
          final userAnswer = selected[index] ?? '';
          final correctAnswer = question.dragAnswers[index];
          final label = index < question.dragTargets.length
              ? question.dragTargets[index]
              : 'Jawapan ${index + 1}';
          return QuizQuestionAnswerResult(
            id: '${question.id}-${index + 1}',
            label: label,
            userAnswer: userAnswer,
            correctAnswer: correctAnswer,
            isCorrect:
                normalizeQuizText(userAnswer) ==
                normalizeQuizText(correctAnswer),
          );
        }),
      );
    }

    if (question.interactionType == QuizInteractionType.textInput &&
        question.acceptableTextAnswers.length > 1) {
      final enteredAnswers = (_typedAnswers[question.id] ?? '').split(',');
      return QuizAnswerGroupResult(
        questions: List.generate(question.acceptableTextAnswers.length, (
          index,
        ) {
          final userAnswer = index < enteredAnswers.length
              ? enteredAnswers[index].trim()
              : '';
          final correctAnswer = question.acceptableTextAnswers[index];
          return QuizQuestionAnswerResult(
            id: '${question.id}-${index + 1}',
            label: 'Jawapan ${index + 1}',
            userAnswer: userAnswer,
            correctAnswer: correctAnswer,
            isCorrect:
                normalizeQuizText(userAnswer) ==
                normalizeQuizText(correctAnswer),
          );
        }),
      );
    }

    final expectedAnswers = _expectedAnswersFor(question);
    return QuizAnswerGroupResult(
      questions: [
        QuizQuestionAnswerResult(
          id: question.id,
          label: question.prompt,
          userAnswer: _selectedAnswer(question),
          correctAnswer: expectedAnswers.isEmpty ? '' : expectedAnswers.first,
          isCorrect: _evaluateAutoQuestion(question),
        ),
      ],
    );
  }

  List<String> _expectedAnswersFor(QuizQuestion question) {
    if (question.correctOptionIds.isNotEmpty && question.options.isNotEmpty) {
      return question.options
          .where((option) => question.correctOptionIds.contains(option.id))
          .map((option) => option.label.trim())
          .toList(growable: false);
    }
    if (question.acceptableTextAnswers.isNotEmpty) {
      return question.acceptableTextAnswers
          .map((answer) => answer.trim())
          .toList(growable: false);
    }
    if (question.matchingAnswers.isNotEmpty) {
      return question.matchingAnswers
          .map((answer) => answer.trim())
          .toList(growable: false);
    }
    if (question.dragAnswers.isNotEmpty) {
      return question.dragAnswers
          .map((answer) => answer.trim())
          .toList(growable: false);
    }
    return const [];
  }

  ({
    String title,
    String message,
    List<String> answers,
    bool answersAreVertical,
  })?
  _compactFeedbackFor(QuizQuestion question, bool isCorrect) {
    final expectedAnswers = _expectedAnswersFor(question);
    final isMultiSelect =
        question.interactionType == QuizInteractionType.multiSelect;
    if (!isMultiSelect &&
        (expectedAnswers.length < 2 || expectedAnswers.length > 3)) {
      return null;
    }

    if (isCorrect) {
      return (
        title: 'Tahniah!',
        message: 'Semua jawapan betul.',
        answers: const [],
        answersAreVertical: false,
      );
    }

    if (isMultiSelect) {
      final selected = _selectedFor(question);
      final selectedCorrectCount = selected
          .where(question.correctOptionIds.contains)
          .length;
      final selectedIncorrectCount = selected
          .where((id) => !question.correctOptionIds.contains(id))
          .length;
      if (selectedIncorrectCount == 0 &&
          selectedCorrectCount < question.correctOptionIds.length) {
        return (
          title: 'Belum lengkap.',
          message: 'Pilih semua jawapan yang betul.',
          answers: const [],
          answersAreVertical: false,
        );
      }
      return (
        title: 'Belum tepat.',
        message:
            '$selectedCorrectCount daripada '
            '${question.correctOptionIds.length} jawapan betul.',
        answers: expectedAnswers,
        answersAreVertical: true,
      );
    }

    final shortAnswers =
        expectedAnswers.every((answer) => !answer.contains(RegExp(r'\s'))) &&
        expectedAnswers.join(', ').length <= 32;
    return (
      title: 'Belum tepat.',
      message: 'Jawapan yang betul ialah:',
      answers: expectedAnswers,
      answersAreVertical: !shortAnswers,
    );
  }

  String _joinShortAnswers(List<String> answers) {
    if (answers.length == 2) {
      return '${answers.first} dan ${answers.last}.';
    }
    return '${answers[0]}, ${answers[1]} dan ${answers[2]}.';
  }

  Widget _buildGroupedFeedback(QuizAnswerGroupResult result) {
    final overallStatus = result.overallStatus;
    final isCorrect = overallStatus == QuizAnswerOverallStatus.correct;
    if (isCorrect) {
      return const Text(
        'Tahniah!\nSemua jawapan betul.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: QuizTokens.headingTextSize,
          fontWeight: FontWeight.w900,
          color: Color(0xFF0B6B58),
          height: 1.3,
        ),
      );
    }

    final verdict = switch (overallStatus) {
      QuizAnswerOverallStatus.correct => 'Tahniah!',
      QuizAnswerOverallStatus.partial => 'Hampir tepat',
      QuizAnswerOverallStatus.incorrect => 'Belum tepat.',
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          verdict,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: QuizTokens.headingTextSize,
            fontWeight: FontWeight.w900,
            color: const Color(0xFFB42318),
            height: 1.25,
          ),
        ),
        const SizedBox(height: 12),
        ...result.questions.asMap().entries.map((entry) {
          final index = entry.key;
          final answer = entry.value;
          // Correctness is checked per row so partial groups reveal only wrong answers.
          final rowIsCorrect = answer.isCorrect;
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: rowIsCorrect
                    ? const Color(0xFF86D39B)
                    : const Color(0xFFF2AAA2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 28,
                  child: Text(
                    '${index + 1}.',
                    style: const TextStyle(
                      fontSize: QuizTokens.headingTextSize,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F2937),
                      height: 1.3,
                    ),
                  ),
                ),
                Icon(
                  rowIsCorrect
                      ? Icons.check_circle_rounded
                      : Icons.cancel_rounded,
                  color: rowIsCorrect
                      ? const Color(0xFF15803D)
                      : const Color(0xFFB42318),
                  size: 26,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    rowIsCorrect
                        ? answer.correctAnswer
                        : 'Jawapan betul: ${answer.correctAnswer}',
                    style: TextStyle(
                      fontSize: QuizTokens.headingTextSize,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF15803D),
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Future<void> _showFeedbackDialog({
    required bool isCorrect,
    required QuizQuestion question,
    required QuizAnswerGroupResult result,
  }) async {
    final reduceMotion = AppMotionSpec.reduceMotion(context);
    final expectedAnswers = _expectedAnswersFor(question);
    final compactFeedback = _compactFeedbackFor(question, isCorrect);
    final isGrouped = result.questions.length > 1;
    final modalIsCorrect =
        result.overallStatus == QuizAnswerOverallStatus.correct;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final imageSize = (screenHeight * 0.20).clamp(120.0, 220.0);
    final dialogDuration = AppMotionSpec.chooseDuration(
      context,
      AppMotionSpec.feedbackEnter,
      AppMotionSpec.feedbackEnterReduced,
    );
    final dialogColor = modalIsCorrect
        ? const Color(0xFFDFF5E6)
        : const Color(0xFFFFE2DD);

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: dialogDuration,
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              final scale = reduceMotion ? 1.0 : (0.94 + (0.06 * value));
              final shakeOffset = !modalIsCorrect && !reduceMotion
                  ? (1 - value) * 12
                  : 0.0;
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(shakeOffset, 0),
                  child: Transform.scale(scale: scale, child: child),
                ),
              );
            },
            child: ConfettiCelebration(
              active: modalIsCorrect,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: dialogColor.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AdaptiveAssetImage(
                      assetPath: modalIsCorrect
                          ? 'assets/Action Figures/AmiN answer correct.svg'
                          : 'assets/Action Figures/AmiN answer wrong.svg',
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 6),
                    if (isGrouped)
                      _buildGroupedFeedback(result)
                    else if (compactFeedback == null) ...[
                      if (!isCorrect && expectedAnswers.length == 1) ...[
                        const Text(
                          'Belum tepat.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: QuizTokens.headingTextSize,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFB42318),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Jawapan betul: ${expectedAnswers.first}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: QuizTokens.headingTextSize,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF15803D),
                            height: 1.3,
                          ),
                        ),
                      ] else
                        Text(
                          isCorrect
                              ? (expectedAnswers.length <= 1
                                    ? 'Tahniah!\nJawapan betul.'
                                    : 'Tahniah!\nSemua jawapan betul.')
                              : (question.wrongFeedback.trim().isNotEmpty
                                    ? question.wrongFeedback
                                    : 'Cuba lagi. Semak jawapan anda.'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: QuizTokens.headingTextSize,
                            fontWeight: FontWeight.w800,
                            color: isCorrect
                                ? const Color(0xFF0B6B58)
                                : const Color(0xFFB42318),
                            height: 1.3,
                          ),
                        ),
                    ] else if (!isCorrect &&
                        expectedAnswers.length == 2 &&
                        question.interactionType !=
                            QuizInteractionType.multiSelect) ...[
                      const Text(
                        'Belum tepat.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: QuizTokens.headingTextSize,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFB42318),
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Jawapan betul: ${expectedAnswers.first} dan '
                        '${expectedAnswers.last}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: QuizTokens.headingTextSize,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF15803D),
                          height: 1.3,
                        ),
                      ),
                    ] else ...[
                      Text(
                        compactFeedback.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: QuizTokens.headingTextSize,
                          fontWeight: FontWeight.w900,
                          color: isCorrect
                              ? const Color(0xFF0B6B58)
                              : const Color(0xFFB42318),
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        compactFeedback.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: QuizTokens.headingTextSize,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F2937),
                          height: 1.3,
                        ),
                      ),
                      if (compactFeedback.answers.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        if (compactFeedback.answersAreVertical)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: compactFeedback.answers
                                  .map(
                                    (answer) => Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        '✓  $answer',
                                        style: const TextStyle(
                                          fontSize:
                                              QuizTokens.headingTextSize,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF15803D),
                                          height: 1.25,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(growable: false),
                            ),
                          )
                        else
                          Text(
                            _joinShortAnswers(compactFeedback.answers),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: QuizTokens.headingTextSize,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF15803D),
                              height: 1.3,
                            ),
                          ),
                      ],
                    ],
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: AnimatedKidButton(
                        label: 'Seterusnya',
                        icon: Icons.arrow_forward_rounded,
                        onPressed: () => Navigator.pop(context),
                        backgroundColor: const Color(0xFF2563EB),
                        labelFontSize: QuizTokens.buttonTextSize,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _submitCurrent() async {
    final gamification = GamificationScope.of(context);
    final question = _currentQuestion;
    if (!question.isAutoGraded) {
      setState(() {
        _manualCompleted.add(question.id);
      });
      await ProgressTracker.instance.recordQuizSubmission(
        isAutoGraded: false,
        isCorrect: false,
        questionGoal: QuizBank.questions.length,
        lessonId: question.id,
        score: 100,
        selectedAnswer: _selectedAnswer(question),
        isBonus: question.isBonus,
        responseTimeMilliseconds: DateTime.now().difference(_questionShownAt).inMilliseconds,
      );
      gamification.awardXp(
        4,
        reason: 'Soalan subjektif disiapkan',
        showOverlay: false,
      );
      gamification.updateStreak(success: true);
      await _goNext();
      return;
    }

    final isCorrect = _evaluateAutoQuestion(question);
    await _processAutoSubmission(
      question: question,
      isCorrect: isCorrect,
      correctReason: 'Jawapan kuiz betul',
      wrongReason: 'Teruskan mencuba',
    );
  }

  Future<void> _processAutoSubmission({
    required QuizQuestion question,
    required bool isCorrect,
    required String correctReason,
    required String wrongReason,
  }) async {
    final gamification = GamificationScope.of(context);
    setState(() {
      _autoResults[question.id] = isCorrect;
    });
    await ProgressTracker.instance.recordQuizSubmission(
      isAutoGraded: true,
      isCorrect: isCorrect,
      questionGoal: QuizBank.questions.length,
      lessonId: question.id,
      score: isCorrect ? 100 : 0,
      selectedAnswer: _selectedAnswer(question),
      isBonus: question.isBonus,
      responseTimeMilliseconds: DateTime.now().difference(_questionShownAt).inMilliseconds,
    );
    if (isCorrect) {
      gamification.awardXp(10, reason: correctReason, showOverlay: false);
      gamification.updateStreak(success: true);
      await AnswerAudioCue.playCorrect();
    } else {
      gamification.awardXp(2, reason: wrongReason, showOverlay: false);
      gamification.updateStreak(success: false);
      await AnswerAudioCue.playWrong();
    }

    await _showFeedbackDialog(
      isCorrect: isCorrect,
      question: question,
      result: _answerGroupResultFor(question),
    );
    if (!mounted) {
      return;
    }
    await _goNext();
  }

  Widget _buildImageReference(QuizQuestion question) {
    if (question.imageAssetPath != null &&
        question.imageAssetPath!.trim().isNotEmpty) {
      final isEasyCompact = _isEasyCompactQuestion(question);
      final isLargeHardImage = const {'HK1', 'HK12'}.contains(question.id);
      final usesHardStyleImageSizing =
          question.level == QuizLevel.hard || question.level == QuizLevel.easy;
      final screenHeight = MediaQuery.sizeOf(context).height;
      final imageHeight = isLargeHardImage
          ? (screenHeight * 0.52).clamp(320.0, 620.0)
          : usesHardStyleImageSizing
          ? (screenHeight * 0.36).clamp(240.0, 460.0)
          : isEasyCompact
          ? (screenHeight * 0.13).clamp(82.0, 124.0)
          : (screenHeight * 0.24).clamp(170.0, 280.0);
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(
          top: (isLargeHardImage || usesHardStyleImageSizing)
              ? 12
              : (isEasyCompact ? 6 : 12),
        ),
        padding: EdgeInsets.all(
          (isLargeHardImage || usesHardStyleImageSizing)
              ? 0
              : (isEasyCompact ? 6 : 10),
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF2D9A9)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: double.infinity,
            height: imageHeight,
            child: AdaptiveAssetImage(
              assetPath: question.imageAssetPath!,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    }

    if (question.imageReferences.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF2D9A9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rujukan Gambar',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: QuizTokens.headingTextSize,
            ),
          ),
          const SizedBox(height: 4),
          ...question.imageReferences.map(
            (line) => Text(
              '- $line',
              style: const TextStyle(fontSize: QuizTokens.headingTextSize),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionInput(QuizQuestion question) {
    switch (question.interactionType) {
      case QuizInteractionType.multiSelect:
        return buildQuizMultiSelectInput(
          question: question,
          options: _optionsFor(question),
          selectedIds: _selectedFor(question),
          onToggle: (option) => _toggleMultiChoice(question, option),
          revealCorrectness: _autoResults.containsKey(question.id),
        );
      case QuizInteractionType.singleChoice:
        final selected = _selectedFor(question);
        final selectedValue = selected.isEmpty ? null : selected.first;
        return buildQuizSingleChoiceInput(
          options: _optionsFor(question),
          selectedValue: selectedValue,
          onSelect: (value) => _setSingleChoice(question, value),
          questionId: question.id,
        );
      case QuizInteractionType.textInput:
        return buildQuizTextInput(
          question: question,
          currentValue: _typedAnswers[question.id] ?? '',
          onChanged: (value) {
            if (_typedAnswers[question.id] == value) {
              return;
            }
            setState(() {
              _typedAnswers[question.id] = value;
            });
          },
        );
      case QuizInteractionType.matching:
        return buildQuizMatchingInput(
          question: question,
          selected: _matchingFor(question),
          choicesForIndex: (index) => _matchingChoicesFor(question, index),
          onChanged: (index, value) =>
              _setMatchingChoice(question, index, value),
        );
      case QuizInteractionType.dragDrop:
        return buildQuizDragInput(
          question: question,
          selected: _dragFor(question),
          availableChoices: _dragChoicesFor(question),
          onSetChoice: (index, value) => _setDragChoice(question, index, value),
          onClearChoice: (index) => _clearDragChoice(question, index),
        );
    }
  }

  Widget _buildHighlightedBody(QuizQuestion question) {
    if (question.bodyText.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final bodyTextSize = QuizTokens.headingTextSize;
    final bodyTextAlign = question.id == 'MK5'
        ? TextAlign.justify
        : TextAlign.start;

    if (question.highlightedBodyPhrases.isEmpty) {
      return Text(
        question.bodyText,
        textAlign: bodyTextAlign,
        style: TextStyle(
          fontSize: bodyTextSize,
          height: 1.5,
          color: const Color(0xFF0F172A),
          fontWeight: FontWeight.w600,
        ),
      );
    }

    final spans = <TextSpan>[];
    var remaining = question.bodyText;
    while (remaining.isNotEmpty) {
      final nextMatch = question.highlightedBodyPhrases
          .map((phrase) {
            final index = remaining.indexOf(phrase);
            return index == -1 ? null : (phrase: phrase, index: index);
          })
          .whereType<({String phrase, int index})>()
          .fold<({String phrase, int index})?>(
            null,
            (best, current) =>
                best == null || current.index < best.index ? current : best,
          );

      if (nextMatch == null) {
        spans.add(
          TextSpan(
            text: remaining,
            style: TextStyle(
              fontSize: bodyTextSize,
              height: 1.5,
              color: const Color(0xFF0F172A),
              fontWeight: FontWeight.w600,
            ),
          ),
        );
        break;
      }

      if (nextMatch.index > 0) {
        spans.add(
          TextSpan(
            text: remaining.substring(0, nextMatch.index),
            style: TextStyle(
              fontSize: bodyTextSize,
              height: 1.5,
              color: const Color(0xFF0F172A),
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }

      spans.add(
        TextSpan(
          text: nextMatch.phrase,
          style: TextStyle(
            fontSize: bodyTextSize,
            height: 1.5,
            color: AppColors.danger,
            fontWeight: FontWeight.w800,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.danger,
          ),
        ),
      );
      remaining = remaining.substring(
        nextMatch.index + nextMatch.phrase.length,
      );
    }

    return RichText(
      textAlign: bodyTextAlign,
      text: TextSpan(children: spans),
    );
  }

  Widget _buildBodyCard(QuizQuestion question) {
    if (question.bodyText.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final isEasyCompact = _isEasyCompactQuestion(question);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: isEasyCompact ? 6 : 12),
      padding: EdgeInsets.all(isEasyCompact ? 10 : 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: _buildHighlightedBody(question),
    );
  }

  TextSpan _italicizeMeN(String text, TextStyle style) {
    final matches = RegExp(r'meN-').allMatches(text);
    if (matches.isEmpty) {
      return TextSpan(text: text, style: style);
    }

    final spans = <InlineSpan>[];
    var start = 0;
    for (final match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }
      spans.add(
        TextSpan(
          text: match.group(0),
          style: style.copyWith(fontStyle: FontStyle.italic),
        ),
      );
      start = match.end;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }
    return TextSpan(style: style, children: spans);
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Kuiz',
            style: TextStyle(fontSize: QuizTokens.headingTextSize),
          ),
        ),
        body: const Center(
          child: Text(
            'Tiada soalan untuk tahap ini.',
            style: TextStyle(fontSize: QuizTokens.headingTextSize),
          ),
        ),
      );
    }

    final question = _currentQuestion;
    final isEasyCompact = _isEasyCompactQuestion(question);
    final hasInlineImage =
        (question.imageAssetPath?.trim().isNotEmpty ?? false);
    final isWideImageQuestion =
        hasInlineImage &&
        (question.level == QuizLevel.hard || question.level == QuizLevel.easy);
    final questionHeaderTextSize = QuizTokens.headingTextSize;
    final verticalPagePadding = isEasyCompact ? 12.0 : 16.0;
    final horizontalPagePadding = isWideImageQuestion
        ? 8.0
        : (isEasyCompact ? 12.0 : 16.0);
    final actionLabel = question.level == QuizLevel.medium ||
            (question.level == QuizLevel.hard && question.submitLabel == null)
        ? 'Semak'
        : question.submitLabel ??
              (_isLastQuestion
                  ? 'Selesai Kuiz'
                  : question.isAutoGraded
                  ? 'Semak dan Seterusnya'
                  : 'Tandakan Siap dan Seterusnya');

    return Scaffold(
      backgroundColor: quizLevelBackground(question.level),
      // Remove this property to delete the bypasser entirely.
      floatingActionButton: _enableQuizBypasser
          ? FloatingActionButton.small(
              heroTag: 'quiz-bypasser',
              tooltip: 'Jump to quiz question',
              onPressed: _openQuizBypasser,
              child: const Icon(Icons.skip_next_rounded),
            )
          : null,
      appBar: AppBar(
        backgroundColor: quizLevelBackground(question.level),
        elevation: 0,
        title: Text(
          'Kuiz ${_currentIndex + 1}/${_questions.length}',
          style: const TextStyle(
            fontSize: QuizTokens.headingTextSize,
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth =
                constraints.maxWidth - (horizontalPagePadding * 2);
            final contentWidth = availableWidth.clamp(0.0, 760.0).toDouble();

            return Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPagePadding,
                verticalPagePadding,
                horizontalPagePadding,
                verticalPagePadding,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: contentWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: (_currentIndex + 1) / _questions.length,
                                minHeight: isEasyCompact ? 8 : 10,
                                backgroundColor: const Color(0xFFE2E8F0),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  quizLevelColor(question.level),
                                ),
                              ),
                            ),
                            SizedBox(height: isEasyCompact ? 8 : 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isEasyCompact ? 10 : 12,
                                  vertical: isEasyCompact ? 6 : 7,
                                ),
                                decoration: BoxDecoration(
                                  color: quizLevelColor(question.level),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  quizLevelLabel(question.level),
                                  style: TextStyle(
                                    fontSize: isEasyCompact ? 14 : 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: isEasyCompact ? 8 : 14),
                            if (question.isBonus && !isEasyCompact) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF4CF),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFF3CE73),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.workspace_premium_rounded,
                                      color: Color(0xFF8A5A00),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Bahagian Bonus',
                                        style: TextStyle(
                                          fontSize: QuizTokens.headingTextSize,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF8A5A00),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                            Text(
                              'Hai, ${widget.name}',
                              style: const TextStyle(
                                fontSize: QuizTokens.headingTextSize,
                                color: Color(0xFF1D3557),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(isEasyCompact ? 10 : 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    question.title,
                                    style: TextStyle(
                                      fontSize: questionHeaderTextSize,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF0E7490),
                                    ),
                                  ),
                                  SizedBox(height: isEasyCompact ? 4 : 6),
                                  Text.rich(
                                    _italicizeMeN(
                                      question.prompt,
                                      TextStyle(
                                      fontSize: questionHeaderTextSize,
                                      height: 1.35,
                                      ),
                                    ),
                                  ),
                                  _buildImageReference(question),
                                  _buildBodyCard(question),
                                ],
                              ),
                            ),
                            SizedBox(height: isEasyCompact ? 8 : 12),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(isEasyCompact ? 10 : 20),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.96),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: QuizTokens.answerPanelBorder,
                                ),
                              ),
                              child: _buildQuestionInput(question),
                            ),
                            SizedBox(height: isEasyCompact ? 8 : 12),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      AnimatedKidButton(
                        label: actionLabel,
                        icon: Icons.play_circle_fill_rounded,
                        onPressed: _canSubmit(question) ? _submitCurrent : null,
                        backgroundColor: const Color(0xFFFFC300),
                        foregroundColor: Colors.black87,
                        height: isEasyCompact ? 48 : 54,
                        labelFontSize: isEasyCompact
                            ? QuizTokens.buttonTextSize - 2
                            : QuizTokens.buttonTextSize,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
