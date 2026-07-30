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

class PilihPantasGameScreen extends StatefulWidget {
  const PilihPantasGameScreen({super.key});

  @override
  State<PilihPantasGameScreen> createState() => _PilihPantasGameScreenState();
}

enum _PantasChoice { hasPrefix, noPrefix }

class _PilihPantasGameScreenState extends State<PilihPantasGameScreen> {
  // Flip this to false for a quick rollback of the intro modal experience.
  static const bool _enableIntroCoachOverlay = true;
  static const String _introInstructionScript =
      'Arahan: Lihat perkataan. Tentukan sama ada perkataan itu berimbuhan awalan meN-.';
  static const String _introMascotAsset =
      'assets/Action Figures/AmiN pointing right.svg';

  static const List<String> _withMenPrefix = [
    'meneroka',
    'melayan',
    'mengukus',
    'menangkap',
    'menambah',
    'menghias',
  ];

  static const List<String> _withoutMenPrefix = [
    'menara',
    'pelihara',
    'pancing',
    'melayu',
    'selam',
    'catat',
  ];

  final Random _random = Random();

  late List<_WordItem> _roundWords;
  int _currentIndex = 0;
  int _score = 0;
  bool _isLocked = false;
  bool? _lastAnswerCorrect;
  _PantasChoice? _selectedChoice;
  String _feedbackText = '';
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

  _WordItem get _currentWord => _roundWords[_currentIndex];

  @override
  void initState() {
    super.initState();
    unawaited(
      ProgressTracker.instance.beginGame(
        gameType: 'pilih_pantas',
        gameId: 'M003_PilihPantas',
      ),
    );
    _startNewRound();
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

  void _startNewRound() {
    final words = <_WordItem>[
      ..._withMenPrefix.map(
        (word) => _WordItem(word: word, hasMenPrefix: true),
      ),
      ..._withoutMenPrefix.map(
        (word) => _WordItem(word: word, hasMenPrefix: false),
      ),
    ]..shuffle(_random);
    _roundWords = words;
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

  TextSpan _buildIntroTextSpan(String text) {
    const marker = 'meN-';
    final markerIndex = text.indexOf(marker);
    if (markerIndex < 0) {
      return TextSpan(text: text);
    }

    return TextSpan(
      children: [
        TextSpan(text: text.substring(0, markerIndex)),
        const TextSpan(
          text: marker,
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        TextSpan(text: text.substring(markerIndex + marker.length)),
      ],
    );
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
    unawaited(GameBackgroundAudio.playGameTrack(1));
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

  Future<void> _submitAnswer(_PantasChoice choice) async {
    if (_isLocked || _showIntroOverlay) {
      return;
    }

    final correct =
        (choice == _PantasChoice.hasPrefix) == _currentWord.hasMenPrefix;
    setState(() {
      _isLocked = true;
      _selectedChoice = choice;
      _lastAnswerCorrect = correct;
      _feedbackText = correct ? 'Betul!' : 'Cuba lagi!';
      if (correct) {
        _score += 1;
      }
    });
    unawaited(
      correct
          ? GameBackgroundAudio.playCorrectSfx()
          : GameBackgroundAudio.playWrongSfx(),
    );

    _nextWordTimer?.cancel();
    _nextWordTimer = Timer(
      AppMotionSpec.chooseDuration(
        context,
        const Duration(milliseconds: 1100),
        const Duration(milliseconds: 550),
      ),
      _moveNext,
    );
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
      _feedbackText = '';
    });
  }

  void _finishRound() {
    if (!mounted) {
      return;
    }
    ProgressTracker.instance.recordGameSession(
      starsEarned: _score,
      starsPossible: _roundWords.length,
      lessonId: 'M003_PilihPantas',
    );
    final gamification = GamificationScope.of(context);
    gamification.awardXp((_score * 2).clamp(6, 30), reason: 'Pilih Pantas');
    gamification.awardStars(_score >= 10 ? 2 : (_score >= 6 ? 1 : 0));

    pushReplacementAdaptive(
      context,
      PilihPantasResultScreen(score: _score, total: _roundWords.length),
    );
  }

  Color _buttonColor(_PantasChoice choice) {
    const baseHasPrefix = Color(0xFF34C759);
    const baseNoPrefix = Color(0xFFFF6B6B);
    if (!_isLocked || _selectedChoice != choice) {
      return choice == _PantasChoice.hasPrefix ? baseHasPrefix : baseNoPrefix;
    }
    return _lastAnswerCorrect == true
        ? const Color(0xFF34C759)
        : const Color(0xFFFF6B6B);
  }

  Widget _choiceButton({required String label, required _PantasChoice choice}) {
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
        ),
      ),
    );
  }

  Widget _buildAnimatedFeedback() {
    final isCorrect = _lastAnswerCorrect == true;
    final foregroundColor = isCorrect
        ? const Color(0xFF087A5B)
        : const Color(0xFFC63C32);
    final backgroundColor = isCorrect
        ? const Color(0xFFE6F8F1)
        : const Color(0xFFFFECEA);

    return SizedBox(
      height: 42,
      child: AnimatedSwitcher(
        duration: AppMotionSpec.chooseDuration(
          context,
          const Duration(milliseconds: 260),
          const Duration(milliseconds: 120),
        ),
        reverseDuration: AppMotionSpec.chooseDuration(
          context,
          const Duration(milliseconds: 160),
          const Duration(milliseconds: 100),
        ),
        transitionBuilder: (child, animation) {
          if (AppMotionSpec.reduceMotion(context)) {
            return FadeTransition(opacity: animation, child: child);
          }
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          );
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.25),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: ScaleTransition(
                scale: Tween<double>(
                  begin: 0.88,
                  end: 1,
                ).animate(curvedAnimation),
                child: child,
              ),
            ),
          );
        },
        child: _feedbackText.isEmpty
            ? const SizedBox(key: ValueKey('empty-feedback'))
            : Container(
                key: ValueKey('$_currentIndex-$_feedbackText'),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: foregroundColor, width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isCorrect
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      size: 22,
                      color: foregroundColor,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      _feedbackText,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: foregroundColor,
                      ),
                    ),
                  ],
                ),
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
                  child: Text.rich(
                    _buildIntroTextSpan(
                      _introTypedText.isEmpty ? '...' : _introTypedText,
                    ),
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
    final buttonLift = MediaQuery.sizeOf(context).height * 0.03;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background/bg_img_for_main1.jpg'),
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
                            gameNumber: 1,
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
                        'Pilih Pantas',
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
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(text: 'Berimbuhan awalan '),
                                        TextSpan(
                                          text: 'meN-',
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        TextSpan(text: '?'),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1D3557),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  AnimatedSwitcher(
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
                                    child: Text(
                                      _currentWord.word,
                                      key: ValueKey(_currentWord.word),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF1D3557),
                                        height: 1.05,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildAnimatedFeedback(),
                      const SizedBox(height: 6),
                      Padding(
                        padding: EdgeInsets.only(bottom: buttonLift),
                        child: Row(
                          children: [
                            _choiceButton(
                              label: 'Ya',
                              choice: _PantasChoice.hasPrefix,
                            ),
                            const SizedBox(width: 10),
                            _choiceButton(
                              label: 'Tidak',
                              choice: _PantasChoice.noPrefix,
                            ),
                          ],
                        ),
                      ),
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

class PilihPantasResultScreen extends StatelessWidget {
  const PilihPantasResultScreen({
    super.key,
    required this.score,
    required this.total,
  });

  final int score;
  final int total;

  String get _statusTitle {
    if (score >= 10) {
      return 'Hebat!';
    }
    if (score >= 6) {
      return 'Bagus!';
    }
    return 'Cuba lagi!';
  }

  String get _statusSubtitle {
    if (score >= 10) {
      return 'Anda berjaya!';
    }
    if (score >= 6) {
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
      confettiActive: score >= 10,
      completionText: 'Anda telah menamatkan permainan Pilih Pantas.',
      onPlayAgain: () {
        pushReplacementAdaptive(context, const PilihPantasGameScreen());
      },
      onMainMenu: () {
        pushReplacementAdaptive(context, const GameMenuScreen());
      },
    );
  }
}

class _WordItem {
  const _WordItem({required this.word, required this.hasMenPrefix});

  final String word;
  final bool hasMenPrefix;
}
