import 'package:flutter/material.dart';

import '../../core/audio/answer_audio_cue.dart';
import '../../shared/design/app_design_tokens.dart';
import '../../shared/gamification/gamification.dart';
import '../../shared/motion/app_motion_navigation.dart';
import '../../shared/motion/app_motion_spec.dart';
import '../../shared/progress/progress_tracker.dart';
import '../data/quiz_bank.dart';
import '../models/quiz_interaction_type.dart';
import '../models/quiz_level.dart';
import '../models/quiz_option.dart';
import '../models/quiz_question.dart';
import 'quiz_result_screen.dart';

class QuizShellScreen extends StatefulWidget {
  const QuizShellScreen({super.key, required this.name, this.level});

  final String name;
  final QuizLevel? level;

  @override
  State<QuizShellScreen> createState() => _QuizShellScreenState();
}

class _QuizShellScreenState extends State<QuizShellScreen> {
  late final List<QuizQuestion> _questions;
  final Map<String, Set<String>> _selectedOptionIds = <String, Set<String>>{};
  final Map<String, String> _typedAnswers = <String, String>{};
  final Map<String, List<String?>> _matchingSelections =
      <String, List<String?>>{};
  final Map<String, List<String?>> _dragSelections = <String, List<String?>>{};
  final Map<String, bool> _autoResults = <String, bool>{};
  final Set<String> _manualCompleted = <String>{};

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    final allQuestions = QuizBank.questions.toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    _questions = widget.level == null
        ? allQuestions
        : allQuestions.where((q) => q.level == widget.level).toList();
  }

  QuizQuestion get _currentQuestion => _questions[_currentIndex];
  bool get _isLastQuestion => _currentIndex == _questions.length - 1;

  String _levelLabel(QuizLevel level) {
    switch (level) {
      case QuizLevel.easy:
        return 'Mudah';
      case QuizLevel.medium:
        return 'Sederhana';
      case QuizLevel.hard:
        return 'Tinggi';
    }
  }

  Color _levelColor(QuizLevel level) {
    switch (level) {
      case QuizLevel.easy:
        return const Color(0xFF2EAD63);
      case QuizLevel.medium:
        return const Color(0xFFF4A52E);
      case QuizLevel.hard:
        return const Color(0xFFE45832);
    }
  }

  Set<String> _selectedFor(QuizQuestion question) =>
      _selectedOptionIds[question.id] ?? <String>{};

  List<String?> _matchingFor(QuizQuestion question) {
    return _matchingSelections.putIfAbsent(
      question.id,
      () => List<String?>.filled(question.matchingLeft.length, null),
    );
  }

  List<String?> _dragFor(QuizQuestion question) {
    return _dragSelections.putIfAbsent(
      question.id,
      () => List<String?>.filled(question.dragTargets.length, null),
    );
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

  String _normalize(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  bool _evaluateAutoQuestion(QuizQuestion question) {
    if (question.correctOptionIds.isNotEmpty) {
      final selected = _selectedFor(question);
      return selected.length == question.correctOptionIds.length &&
          selected.containsAll(question.correctOptionIds);
    }

    if (question.acceptableTextAnswers.isNotEmpty) {
      final typed = _normalize(_typedAnswers[question.id] ?? '');
      if (typed.isEmpty) {
        return false;
      }

      if (question.acceptableTextAnswers.length == 1) {
        return typed == _normalize(question.acceptableTextAnswers.first);
      }

      final requiredAnswers = question.acceptableTextAnswers
          .map(_normalize)
          .toList(growable: false);
      return requiredAnswers.every(typed.contains);
    }

    if (question.interactionType == QuizInteractionType.matching &&
        question.matchingAnswers.isNotEmpty) {
      final selected = _matchingFor(question);
      if (selected.any((value) => value == null || value.trim().isEmpty)) {
        return false;
      }
      for (var i = 0; i < question.matchingAnswers.length; i++) {
        if (_normalize(selected[i]!) !=
            _normalize(question.matchingAnswers[i])) {
          return false;
        }
      }
      return true;
    }

    if (question.interactionType == QuizInteractionType.dragDrop &&
        question.dragAnswers.isNotEmpty) {
      final selected = _dragFor(question);
      if (selected.any((value) => value == null || value.trim().isEmpty)) {
        return false;
      }
      for (var i = 0; i < question.dragAnswers.length; i++) {
        if (_normalize(selected[i]!) != _normalize(question.dragAnswers[i])) {
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
        return (_typedAnswers[question.id] ?? '').trim().isNotEmpty;
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
      final autoGradedCount = _questions.where((q) => q.isAutoGraded).length;
      final correctCount = _autoResults.values.where((result) => result).length;
      final quizPercent = autoGradedCount == 0
          ? 100
          : ((correctCount / autoGradedCount) * 100).round();
      final levelSuffix = widget.level == null
          ? 'ALL'
          : _levelLabel(widget.level!).toUpperCase();
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
          totalQuestions: _questions.length,
          autoGradedQuestions: autoGradedCount,
          correctAnswers: correctCount,
          manualCompleted: _manualCompleted.length,
        ),
      );
      return;
    }

    setState(() {
      _currentIndex += 1;
    });
  }

  Future<void> _showFeedbackDialog({
    required bool isCorrect,
    required QuizQuestion question,
  }) async {
    final reduceMotion = AppMotionSpec.reduceMotion(context);
    final dialogDuration = AppMotionSpec.chooseDuration(
      context,
      AppMotionSpec.feedbackEnter,
      AppMotionSpec.feedbackEnterReduced,
    );
    final dialogColor = isCorrect
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
              final shakeOffset = !isCorrect && !reduceMotion
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
              active: isCorrect,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: dialogColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MascotWidget(
                      assetPath: 'assets/aminPage3.png',
                      width: 74,
                      height: 74,
                      state: isCorrect
                          ? MascotState.celebrate
                          : MascotState.errorReact,
                      speech: isCorrect ? 'Tahniah!' : 'Jom cuba lagi!',
                    ),
                    const SizedBox(height: 8),
                    Icon(
                      isCorrect
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      color: isCorrect ? AppColors.success : AppColors.danger,
                      size: 56,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isCorrect ? 'Betul' : 'Salah',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (isCorrect)
                      Column(
                        children: const [
                          Icon(
                            Icons.sentiment_satisfied_rounded,
                            color: AppColors.secondary,
                            size: 34,
                          ),
                          SizedBox(height: 8),
                          XPAnimation(amount: 10),
                        ],
                      )
                    else
                      const Icon(
                        Icons.sentiment_dissatisfied_rounded,
                        color: Color(0xFFE45832),
                        size: 38,
                      ),
                    if (question.explanation.trim().isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        question.explanation,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2F4858),
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    AnimatedKidButton(
                      label: 'Seterusnya',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: () => Navigator.pop(context),
                      backgroundColor: const Color(0xFF2563EB),
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
      );
      gamification.awardXp(4, reason: 'Soalan subjektif disiapkan');
      gamification.updateStreak(success: true);
      await _goNext();
      return;
    }

    final isCorrect = _evaluateAutoQuestion(question);
    setState(() {
      _autoResults[question.id] = isCorrect;
    });
    await ProgressTracker.instance.recordQuizSubmission(
      isAutoGraded: true,
      isCorrect: isCorrect,
      questionGoal: QuizBank.questions.length,
      lessonId: question.id,
      score: isCorrect ? 100 : 0,
    );
    if (isCorrect) {
      gamification.awardXp(10, reason: 'Jawapan kuiz betul');
      gamification.updateStreak(success: true);
      await AnswerAudioCue.playCorrect();
    } else {
      gamification.awardXp(2, reason: 'Teruskan mencuba');
      gamification.updateStreak(success: false);
      await AnswerAudioCue.playWrong();
    }

    await _showFeedbackDialog(isCorrect: isCorrect, question: question);
    if (!mounted) {
      return;
    }
    await _goNext();
  }

  Widget _buildImageReference(QuizQuestion question) {
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
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                'assets/classroom_background.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFE6ECF3),
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_rounded, size: 44),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Rujukan Gambar',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          ...question.imageReferences.map((line) => Text('- $line')),
        ],
      ),
    );
  }

  Widget _buildMultiSelectInput(QuizQuestion question) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: question.options.map((option) {
        final selected = _selectedFor(question).contains(option.id);
        return FilterChip(
          label: Text(option.label),
          selected: selected,
          selectedColor: const Color(0xFFB8ECFF),
          onSelected: (_) => _toggleMultiChoice(question, option),
          labelStyle: const TextStyle(fontWeight: FontWeight.w700),
        );
      }).toList(),
    );
  }

  Widget _buildSingleChoiceInput(QuizQuestion question) {
    final selected = _selectedFor(question);
    final selectedValue = selected.isEmpty ? null : selected.first;
    return Column(
      children: question.options
          .map(
            (option) => InkWell(
              onTap: () => _setSingleChoice(question, option.id),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: selectedValue == option.id
                      ? const Color(0xFFD8F3FF)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selectedValue == option.id
                        ? const Color(0xFF0E7490)
                        : const Color(0xFFD9D9D9),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      selectedValue == option.id
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: selectedValue == option.id
                          ? const Color(0xFF0E7490)
                          : Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        option.label,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildTextInput(QuizQuestion question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          key: ValueKey(question.id),
          initialValue: _typedAnswers[question.id] ?? '',
          onChanged: (value) {
            if (_typedAnswers[question.id] == value) {
              return;
            }
            setState(() {
              _typedAnswers[question.id] = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Taip jawapan anda di sini',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          minLines: 2,
          maxLines: 4,
        ),
        if (question.helperLines.isNotEmpty) ...[
          const SizedBox(height: 8),
          ...question.helperLines.map(
            (line) => Text(
              line,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF4A5568),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMatchingInput(QuizQuestion question) {
    final selected = _matchingFor(question);
    final choices = question.matchingChoices;

    return Column(
      children: List.generate(question.matchingLeft.length, (index) {
        final leftText = question.matchingLeft[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFDDE6EF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                leftText,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1D3557),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: selected[index],
                hint: const Text('Pilih padanan'),
                items: choices
                    .map(
                      (choice) => DropdownMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    _setMatchingChoice(question, index, value),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDragInput(QuizQuestion question) {
    final selected = _dragFor(question);
    final selectedValues = selected.whereType<String>().toList();
    final availableChoices = question.dragChoices
        .where((choice) => !selectedValues.contains(choice))
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...availableChoices.map(
              (choice) => Draggable<String>(
                data: choice,
                feedback: Material(
                  color: Colors.transparent,
                  child: _choiceChip(choice, active: true),
                ),
                childWhenDragging: _choiceChip(choice, active: false),
                child: _choiceChip(choice, active: true),
              ),
            ),
            if (availableChoices.isEmpty)
              const Text(
                'Semua pilihan telah digunakan.',
                style: TextStyle(
                  color: Color(0xFF4A5568),
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ...List.generate(question.dragTargets.length, (index) {
          final target = question.dragTargets[index];
          final assigned = selected[index];

          return DragTarget<String>(
            onAcceptWithDetails: (details) {
              _setDragChoice(question, index, details.data);
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: candidateData.isNotEmpty
                        ? const Color(0xFF0EA5E9)
                        : const Color(0xFFDDE6EF),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      target,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D3557),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: assigned == null
                                  ? const Color(0xFFF3F7FB)
                                  : const Color(0xFFDFF4FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              assigned ?? 'Lepaskan pilihan di sini',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: assigned == null
                                    ? const Color(0xFF6B7280)
                                    : const Color(0xFF0E7490),
                              ),
                            ),
                          ),
                        ),
                        if (assigned != null) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => _clearDragChoice(question, index),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ],
    );
  }

  Widget _choiceChip(String text, {required bool active}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFFFC74D) : const Color(0xFFFFE6A8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          color: Color(0xFF1D3557),
        ),
      ),
    );
  }

  Widget _buildQuestionInput(QuizQuestion question) {
    switch (question.interactionType) {
      case QuizInteractionType.multiSelect:
        return _buildMultiSelectInput(question);
      case QuizInteractionType.singleChoice:
        return _buildSingleChoiceInput(question);
      case QuizInteractionType.textInput:
        return _buildTextInput(question);
      case QuizInteractionType.matching:
        return _buildMatchingInput(question);
      case QuizInteractionType.dragDrop:
        return _buildDragInput(question);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Kuiz')),
        body: const Center(child: Text('Tiada soalan untuk tahap ini.')),
      );
    }

    final question = _currentQuestion;
    final actionLabel = _isLastQuestion
        ? 'Selesai Kuiz'
        : question.isAutoGraded
        ? 'Semak dan Seterusnya'
        : 'Tandakan Siap dan Seterusnya';

    return Scaffold(
      backgroundColor: const Color(0xFFEAF7FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEAF7FF),
        elevation: 0,
        title: Text(
          'Kuiz ${_currentIndex + 1}/${_questions.length}',
          style: const TextStyle(
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: StarProgressBar(
                            value: (_currentIndex + 1) / _questions.length,
                            showLabel: false,
                            starCount: 3,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _levelColor(question.level),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 18,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _levelLabel(question.level),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Hai ${widget.name}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF1D3557),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0E7490),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            question.prompt,
                            style: const TextStyle(fontSize: 16, height: 1.35),
                          ),
                          _buildImageReference(question),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildQuestionInput(question),
                    const SizedBox(height: 12),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
