import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/audio/game_background_audio.dart';
import '../../core/audio/game_instruction_voice.dart';
import '../../shared/gamification/gamification.dart';
import '../../shared/motion/app_motion_navigation.dart';
import '../../shared/motion/app_motion_spec.dart';
import '../../shared/motion/app_motion_widgets.dart';
import '../../shared/progress/progress_tracker.dart';
import 'game_menu_screen.dart';
import '../widgets/game_audio_toggle_button.dart';
import '../widgets/game_completion_template.dart';
import '../widgets/game_score_badge.dart';

class BetulAtauSalahGameScreen extends StatefulWidget {
  const BetulAtauSalahGameScreen({super.key});

  @override
  State<BetulAtauSalahGameScreen> createState() =>
      _BetulAtauSalahGameScreenState();
}

enum _WordChoice { left, right }

class _BetulAtauSalahGameScreenState extends State<BetulAtauSalahGameScreen> {
  // Flip this to false for a quick rollback of the intro modal experience.
  static const bool _enableIntroCoachOverlay = true;
  static const String _introInstructionScript =
      'Arahan: Pilih perkataan yang betul.';
  static const String _introMascotAsset =
      'assets/Action Figures/AmiN pointing right.svg';

  static const List<_WordPair> _wordPairs = [
    _WordPair(correct: 'menutup', incorrect: 'mentutup'),
    _WordPair(correct: 'memeriksa', incorrect: 'meperiksa'),
    _WordPair(correct: 'menyerap', incorrect: 'menserap'),
    _WordPair(correct: 'mengarang', incorrect: 'mengkarang'),
    _WordPair(correct: 'menyimpan', incorrect: 'mensimpan'),
    _WordPair(correct: 'mengira', incorrect: 'mengkira'),
    _WordPair(correct: 'memohon', incorrect: 'menmohon'),
    _WordPair(correct: 'menabung', incorrect: 'mentabung'),
    _WordPair(correct: 'mengutip', incorrect: 'mengkutip'),
    _WordPair(correct: 'menyambut', incorrect: 'mensambut'),
    _WordPair(correct: 'memegang', incorrect: 'mepegang'),
    _WordPair(correct: 'menolak', incorrect: 'mengtolak'),
    _WordPair(correct: 'menyusun', incorrect: 'mesusun'),
    _WordPair(correct: 'memadam', incorrect: 'menpadam'),
    _WordPair(correct: 'mengupas', incorrect: 'mengkupas'),
  ];

  final Random _random = Random();
  late List<_WordRound> _roundWords;
  int _currentIndex = 0;
  int _score = 0;
  bool _isLocked = false;
  bool? _lastAnswerCorrect;
  _WordChoice? _selectedChoice;
  Timer? _nextWordTimer;
  Timer? _introWordTimer;
  bool _showIntroOverlay = _enableIntroCoachOverlay;
  bool _introOverlayVisible = false;
  bool _introClosing = false;
  bool _introIsTyping = false;
  bool _introCoachStarted = false;
  List<String> _introWords = const <String>[];
  int _visibleIntroWordCount = 0;
  int _introTypingSession = 0;

  _WordRound get _currentWord => _roundWords[_currentIndex];

  @override
  void initState() {
    super.initState();
    unawaited(
      ProgressTracker.instance.beginGame(
        gameType: 'betul_atau_salah',
        gameId: 'M006_BetulSalah',
      ),
    );
    _roundWords = _buildRoundWords();
    if (_showIntroOverlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_showIntroOverlay) {
          return;
        }
        unawaited(_startIntroCoachSequence());
      });
    }
  }

  @override
  void dispose() {
    unawaited(ProgressTracker.instance.abandonGame());
    _nextWordTimer?.cancel();
    _introWordTimer?.cancel();
    unawaited(GameInstructionVoice.stop());
    unawaited(GameBackgroundAudio.stopAll());
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    _nextWordTimer?.cancel();
    _roundWords = _buildRoundWords();
    _currentIndex = 0;
    _score = 0;
    _isLocked = false;
    _lastAnswerCorrect = null;
    _selectedChoice = null;
  }

  List<_WordRound> _buildRoundWords() {
    final pairs = List<_WordPair>.of(_wordPairs)..shuffle(_random);
    final correctSidePattern = List<bool>.generate(
      pairs.length,
      (index) => index.isEven,
    )..shuffle(_random);

    return List<_WordRound>.generate(pairs.length, (index) {
      final pair = pairs[index];
      final correctOnLeft = correctSidePattern[index];
      return _WordRound(
        leftWord: correctOnLeft ? pair.correct : pair.incorrect,
        rightWord: correctOnLeft ? pair.incorrect : pair.correct,
        correctChoice: correctOnLeft ? _WordChoice.left : _WordChoice.right,
      );
    });
  }

  Future<void> _startIntroCoachSequence() async {
    if (!mounted || !_showIntroOverlay || _introCoachStarted) {
      return;
    }
    _introCoachStarted = true;
    final words = _introInstructionScript
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    final reduceMotion = AppMotionSpec.reduceMotion(context);
    _introWordTimer?.cancel();
    _introTypingSession += 1;
    setState(() {
      _introOverlayVisible = true;
      _introWords = words;
      _visibleIntroWordCount = reduceMotion ? words.length : 0;
      _introIsTyping = !reduceMotion && words.isNotEmpty;
    });
    unawaited(GameInstructionVoice.speak(_introInstructionScript));

    if (words.isEmpty) {
      return;
    }
    if (reduceMotion) {
      return;
    }
    _animateIntroWordsSilently(words, _introTypingSession);
  }

  String get _introTypedText {
    if (_introWords.isEmpty) {
      return '';
    }
    final clampedCount = _visibleIntroWordCount.clamp(0, _introWords.length);
    return _introWords.take(clampedCount).join(' ');
  }

  void _animateIntroWordsSilently(List<String> words, int token) {
    final wordStepDuration = AppMotionSpec.chooseDuration(
      context,
      const Duration(milliseconds: 140),
      const Duration(milliseconds: 80),
    );
    _introWordTimer = Timer.periodic(wordStepDuration, (timer) {
      if (!mounted || !_showIntroOverlay || token != _introTypingSession) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_visibleIntroWordCount < words.length) {
          _visibleIntroWordCount += 1;
        } else {
          _introIsTyping = false;
          timer.cancel();
        }
      });
    });
  }

  Future<void> _closeIntroOverlay() async {
    if (_introClosing) {
      return;
    }
    final stopVoice = GameInstructionVoice.stop();
    _introTypingSession += 1;
    _introWordTimer?.cancel();
    if (!mounted) {
      return;
    }
    setState(() {
      _introClosing = true;
      _introOverlayVisible = false;
    });
    await stopVoice;
    if (!mounted) {
      return;
    }
    unawaited(GameBackgroundAudio.playGameTrack(4));
    await Future<void>.delayed(
      AppMotionSpec.chooseDuration(
        context,
        const Duration(milliseconds: 220),
        const Duration(milliseconds: 120),
      ),
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _showIntroOverlay = false;
      _introClosing = false;
    });
  }

  Future<void> _submitAnswer(_WordChoice choice) async {
    if (_isLocked || _showIntroOverlay) {
      return;
    }

    final isCorrect = choice == _currentWord.correctChoice;
    setState(() {
      _isLocked = true;
      _selectedChoice = choice;
      _lastAnswerCorrect = isCorrect;
      if (isCorrect) {
        _score += 1;
      }
    });
    unawaited(
      isCorrect
          ? GameBackgroundAudio.playCorrectSfx()
          : GameBackgroundAudio.playWrongSfx(),
    );

    _nextWordTimer?.cancel();
    _nextWordTimer = Timer(
      AppMotionSpec.chooseDuration(
        context,
        Duration(milliseconds: isCorrect ? 750 : 550),
        Duration(milliseconds: isCorrect ? 400 : 300),
      ),
      isCorrect ? _moveNext : _allowRetry,
    );
  }

  void _allowRetry() {
    _nextWordTimer?.cancel();
    if (!mounted) {
      return;
    }
    setState(() {
      _isLocked = false;
      _selectedChoice = null;
      _lastAnswerCorrect = null;
    });
  }

  void _moveNext() {
    _nextWordTimer?.cancel();
    if (!mounted) {
      return;
    }
    if (_currentIndex >= _roundWords.length - 1) {
      _finishRound();
      return;
    }
    setState(() {
      _currentIndex += 1;
      _isLocked = false;
      _selectedChoice = null;
      _lastAnswerCorrect = null;
    });
  }

  void _finishRound() {
    if (!mounted) {
      return;
    }
    ProgressTracker.instance.recordGameSession(
      starsEarned: _score,
      starsPossible: _roundWords.length,
      lessonId: 'M006_BetulSalah',
    );
    final gamification = GamificationScope.of(context);
    gamification.awardXp((_score * 2).clamp(8, 36), reason: 'Pilih Kata Tepat');
    gamification.awardStars(_score >= 12 ? 2 : (_score >= 8 ? 1 : 0));

    pushReplacementAdaptive(
      context,
      BetulAtauSalahResultScreen(score: _score, total: _roundWords.length),
    );
  }

  Color _buttonColor(_WordChoice choice) {
    const neutral = Color(0xFF2563EB);
    if (!_isLocked || _selectedChoice != choice) {
      return neutral;
    }
    return _lastAnswerCorrect == true
        ? const Color(0xFF34C759)
        : const Color(0xFFFF6B6B);
  }

  Widget _choiceButton({required String label, required _WordChoice choice}) {
    return Expanded(
      child: AnimatedContainer(
        duration: AppMotionSpec.chooseDuration(
          context,
          const Duration(milliseconds: 180),
          const Duration(milliseconds: 120),
        ),
        curve: Curves.easeOutCubic,
        child: AnimatedKidButton(
          label: label,
          onPressed: _isLocked ? null : () => _submitAnswer(choice),
          backgroundColor: _buttonColor(choice),
          foregroundColor: Colors.white,
          height: 80,
          labelFontSize: 26,
        ),
      ),
    );
  }

  Widget _buildFeedback() {
    final isCorrect = _lastAnswerCorrect == true;
    final feedbackColor = isCorrect
        ? const Color(0xFF0B7A5A)
        : const Color(0xFFD6453D);

    return SizedBox(
      height: 38,
      child: AnimatedSwitcher(
        duration: AppMotionSpec.chooseDuration(
          context,
          const Duration(milliseconds: 200),
          const Duration(milliseconds: 100),
        ),
        transitionBuilder: (child, animation) {
          if (AppMotionSpec.reduceMotion(context)) {
            return FadeTransition(opacity: animation, child: child);
          }
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.85, end: 1).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
              ),
              child: child,
            ),
          );
        },
        child: _lastAnswerCorrect == null
            ? const SizedBox(key: ValueKey('empty-feedback'))
            : Icon(
                key: ValueKey('$_currentIndex-$isCorrect'),
                isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                size: 32,
                color: feedbackColor,
              ),
      ),
    );
  }

  Widget _buildIntroSpeechBubble(BuildContext context) {
    final showAction = !_introIsTyping;
    const actionLabel = 'Jom mula!';

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFDDE9F4), width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 84),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    _introTypedText.isEmpty ? '...' : _introTypedText,
                    style: const TextStyle(
                      fontSize: 22,
                      height: 1.25,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1D3557),
                    ),
                  ),
                ),
              ),
              if (showAction) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 170,
                    child: AnimatedKidButton(
                      label: actionLabel,
                      onPressed: _closeIntroOverlay,
                      icon: Icons.play_arrow_rounded,
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        Positioned(
          right: -8,
          bottom: 26,
          child: Transform.rotate(
            angle: pi / 4,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFDDE9F4), width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIntroOverlay(BuildContext context) {
    final modalDuration = AppMotionSpec.chooseDuration(
      context,
      const Duration(milliseconds: 280),
      const Duration(milliseconds: 160),
    );

    return Positioned.fill(
      child: IgnorePointer(
        ignoring: !_showIntroOverlay,
        child: AnimatedOpacity(
          opacity: _introOverlayVisible ? 1 : 0,
          duration: modalDuration,
          curve: Curves.easeOutCubic,
          child: Container(
            color: const Color(0xB3000000),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 700;
                  final mascot = MascotWidget(
                    assetPath: _introMascotAsset,
                    width: isNarrow ? 200 : 260,
                    height: isNarrow ? 200 : 260,
                    state: MascotState.encourage,
                  );
                  final speechBubble = _buildIntroSpeechBubble(context);

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 920),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: isNarrow ? double.infinity : 760,
                              child: speechBubble,
                            ),
                            const SizedBox(height: 16),
                            mascot,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background/bg_img_for_main2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Container(
                color: const Color(0x59FFFFFF),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 22),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          ),
                          const Spacer(),
                          GameAudioToggleButton(
                            gameNumber: 4,
                            canPlay: !_showIntroOverlay,
                          ),
                          const SizedBox(width: 8),
                          GameScoreBadge(
                            score: _score,
                            total: _roundWords.length,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Pilih Kata Tepat',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1D3557),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Center(
                          child: FractionallySizedBox(
                            heightFactor: 0.5,
                            widthFactor: 1,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: const Color(0xFFDDE9F4),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x1A000000),
                                    blurRadius: 8,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: AnimatedSwitcher(
                                duration: AppMotionSpec.chooseDuration(
                                  context,
                                  const Duration(milliseconds: 220),
                                  const Duration(milliseconds: 140),
                                ),
                                transitionBuilder: (child, animation) {
                                  return buildAdaptiveSwitcherTransition(
                                    context: context,
                                    animation: animation,
                                    child: child,
                                  );
                                },
                                child: Row(
                                  key: ValueKey(_currentIndex),
                                  children: [
                                    _choiceButton(
                                      label: _currentWord.leftWord,
                                      choice: _WordChoice.left,
                                    ),
                                    const SizedBox(width: 12),
                                    _choiceButton(
                                      label: _currentWord.rightWord,
                                      choice: _WordChoice.right,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildFeedback(),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_showIntroOverlay) _buildIntroOverlay(context),
        ],
      ),
    );
  }
}

class BetulAtauSalahResultScreen extends StatelessWidget {
  const BetulAtauSalahResultScreen({
    super.key,
    required this.score,
    required this.total,
  });

  final int score;
  final int total;

  String get _statusTitle {
    if (score >= 12) {
      return 'Hebat!';
    }
    if (score >= 8) {
      return 'Bagus!';
    }
    return 'Cuba lagi!';
  }

  String get _statusSubtitle {
    if (score >= 12) {
      return 'Anda berjaya!';
    }
    if (score >= 8) {
      return 'Teruskan usaha!';
    }
    return 'Boleh cuba sekali lagi.';
  }

  @override
  Widget build(BuildContext context) {
    return GameCompletionTemplate(
      score: score,
      total: total,
      statusTitle: _statusTitle,
      statusSubtitle: _statusSubtitle,
      confettiActive: score >= 12,
      completionText: 'Anda telah menamatkan permainan Pilih Kata Tepat.',
      onPlayAgain: () {
        pushReplacementAdaptive(context, const BetulAtauSalahGameScreen());
      },
      onMainMenu: () {
        pushReplacementAdaptive(context, const GameMenuScreen());
      },
    );
  }
}

class _WordPair {
  const _WordPair({required this.correct, required this.incorrect});

  final String correct;
  final String incorrect;
}

class _WordRound {
  const _WordRound({
    required this.leftWord,
    required this.rightWord,
    required this.correctChoice,
  });

  final String leftWord;
  final String rightWord;
  final _WordChoice correctChoice;
}
