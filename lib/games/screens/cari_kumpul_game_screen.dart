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
import '../widgets/game_audio_toggle_button.dart';
import '../widgets/game_completion_template.dart';
import 'game_menu_screen.dart';

class CariKumpulGameScreen extends StatefulWidget {
  const CariKumpulGameScreen({super.key});

  @override
  State<CariKumpulGameScreen> createState() => _CariKumpulGameScreenState();
}

class _CariKumpulGameScreenState extends State<CariKumpulGameScreen> {
  // Flip this to false for a quick rollback of the intro modal experience.
  static const bool _enableIntroCoachOverlay = true;
  static const String _introInstructionScript =
      'Arahan: Cari 5 kata berimbuhan meN- dan pilih semua perkataan yang betul.';
  static const String _introMascotAsset =
      'assets/Action Figures/AmiN pointing right.svg';

  static const Set<String> _targetWords = {
    'melihat',
    'menari',
    'mengikat',
    'mencipta',
    'membalas',
  };

  static const List<String> _allWords = [
    'buku',
    'pensel',
    'makan',
    'tidur',
    'kuku',
    'rumah',
    'merah',
    'melihat',
    'menari',
    'mengikat',
    'mencipta',
    'membalas',
  ];

  final Random _random = Random();

  late List<String> _displayWords;
  final Map<String, Rect> _cardRects = <String, Rect>{};
  Size _lastBoardSize = Size.zero;
  int _roundSeed = 0;
  final Set<String> _foundCorrect = <String>{};
  final Map<String, int> _wordBurstKeys = <String, int>{};
  String? _wrongTappedWord;
  String _feedbackText = '';
  bool _completed = false;
  Timer? _feedbackTimer;
  Timer? _introWordTimer;
  bool _showIntroOverlay = _enableIntroCoachOverlay;
  bool _introOverlayVisible = false;
  bool _introClosing = false;
  bool _introIsTyping = false;
  bool _introCoachStarted = false;
  List<String> _introWords = const <String>[];
  int _visibleIntroWordCount = 0;
  int _introTypingSession = 0;

  @override
  void initState() {
    super.initState();
    _resetRound();
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
    _feedbackTimer?.cancel();
    _introWordTimer?.cancel();
    unawaited(GameInstructionVoice.stop());
    unawaited(GameBackgroundAudio.stopAll());
    super.dispose();
  }

  void _resetRound() {
    _displayWords = List<String>.from(_allWords)..shuffle(_random);
    _cardRects.clear();
    _lastBoardSize = Size.zero;
    _roundSeed = _random.nextInt(1 << 30);
  }

  bool _sameSize(Size a, Size b) {
    return (a.width - b.width).abs() < 0.5 && (a.height - b.height).abs() < 0.5;
  }

  void _ensureCardLayout(Size boardSize) {
    if (_cardRects.isNotEmpty && _sameSize(_lastBoardSize, boardSize)) {
      return;
    }
    _lastBoardSize = boardSize;
    _cardRects.clear();
    final random = Random(_roundSeed);
    final placedRects = <Rect>[];
    const edgePadding = 10.0;
    const verticalGap = 8.0;

    for (final word in _displayWords) {
      final estimatedWidth = (word.length * 13.0) + 46;
      final cardWidth = estimatedWidth.clamp(86.0, boardSize.width * 0.44);
      const cardHeight = 46.0;

      final maxLeft = max(
        edgePadding,
        boardSize.width - cardWidth - edgePadding,
      );
      final maxTop = max(
        edgePadding,
        boardSize.height - cardHeight - edgePadding,
      );

      Rect? accepted;
      for (var attempt = 0; attempt < 260; attempt++) {
        final left =
            edgePadding + (random.nextDouble() * (maxLeft - edgePadding));
        final top =
            edgePadding + (random.nextDouble() * (maxTop - edgePadding));
        final rect = Rect.fromLTWH(left, top, cardWidth, cardHeight);

        final hasOverlap = placedRects.any(
          (existing) => existing.inflate(verticalGap).overlaps(rect),
        );
        if (!hasOverlap) {
          accepted = rect;
          break;
        }
      }

      accepted ??= _fallbackRect(
        index: placedRects.length,
        width: cardWidth,
        height: cardHeight,
        boardSize: boardSize,
      );

      _cardRects[word] = accepted;
      placedRects.add(accepted);
    }
  }

  Rect _fallbackRect({
    required int index,
    required double width,
    required double height,
    required Size boardSize,
  }) {
    const edgePadding = 10.0;
    const gap = 12.0;
    final row = index ~/ 3;
    final col = index % 3;
    final maxLeft = max(edgePadding, boardSize.width - width - edgePadding);
    final maxTop = max(edgePadding, boardSize.height - height - edgePadding);
    final left = min(maxLeft, edgePadding + (col * (width + gap)));
    final top = min(maxTop, edgePadding + (row * (height + gap)));
    return Rect.fromLTWH(left, top, width, height);
  }

  void _tapWord(String word) {
    if (_completed || _showIntroOverlay) {
      return;
    }

    if (_targetWords.contains(word)) {
      if (_foundCorrect.contains(word)) {
        setState(() {
          _feedbackText = 'Perkataan ini sudah dipilih.';
          _wrongTappedWord = null;
        });
        unawaited(GameBackgroundAudio.playWrongSfx());
        return;
      }
      setState(() {
        _foundCorrect.add(word);
        _wordBurstKeys[word] = (_wordBurstKeys[word] ?? 0) + 1;
        _feedbackText = 'Bagus!';
        _wrongTappedWord = null;
      });
      unawaited(GameBackgroundAudio.playCorrectSfx());
      if (_foundCorrect.length == _targetWords.length) {
        _completeRound();
      }
      return;
    }

    setState(() {
      _feedbackText = 'Cuba lagi.';
      _wrongTappedWord = word;
    });
    unawaited(GameBackgroundAudio.playWrongSfx());
    _feedbackTimer?.cancel();
    _feedbackTimer = Timer(
      AppMotionSpec.chooseDuration(
        context,
        const Duration(milliseconds: 700),
        const Duration(milliseconds: 380),
      ),
      () {
        if (!mounted) {
          return;
        }
        setState(() => _wrongTappedWord = null);
      },
    );
  }

  void _completeRound() {
    setState(() => _completed = true);

    ProgressTracker.instance.recordGameSession(
      starsEarned: _foundCorrect.length,
      starsPossible: _targetWords.length,
      lessonId: 'M004_CariKumpul',
    );
    final gamification = GamificationScope.of(context);
    gamification.awardXp((_foundCorrect.length * 4).clamp(8, 24));
    gamification.awardStars(1);

    _feedbackTimer?.cancel();
    _feedbackTimer = Timer(
      AppMotionSpec.chooseDuration(
        context,
        const Duration(milliseconds: 950),
        const Duration(milliseconds: 500),
      ),
      () {
        if (!mounted) {
          return;
        }
        pushReplacementAdaptive(
          context,
          CariKumpulResultScreen(found: _foundCorrect.length),
        );
      },
    );
  }

  Color _baseCardColor(int index) {
    const palette = [
      Color(0xFFFFA94D),
      Color(0xFF4DABF7),
      Color(0xFF69DB7C),
      Color(0xFFF783AC),
      Color(0xFFB197FC),
      Color(0xFFFFD43B),
    ];
    return palette[index % palette.length];
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

    if (words.isEmpty || reduceMotion) {
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
    unawaited(GameBackgroundAudio.playGameTrack(2));
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
      backgroundColor: const Color(0xFFE9FAFF),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                      const Expanded(
                        child: Text(
                          'Pilih & Kumpul',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1D3557),
                          ),
                        ),
                      ),
                      GameAudioToggleButton(
                        gameNumber: 2,
                        canPlay: !_showIntroOverlay,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFD6E4F1)),
                        ),
                        child: Text(
                          '${_foundCorrect.length} / ${_targetWords.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1D3557),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFDCEAF7)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          _ensureCardLayout(
                            Size(constraints.maxWidth, constraints.maxHeight),
                          );
                          return Stack(
                            children: _displayWords.asMap().entries.map((
                              entry,
                            ) {
                              final index = entry.key;
                              final word = entry.value;
                              final found = _foundCorrect.contains(word);
                              final isWrongTap = _wrongTappedWord == word;
                              final rect =
                                  _cardRects[word] ??
                                  Rect.fromLTWH(12, 12, 100, 46);
                              return Positioned(
                                left: rect.left,
                                top: rect.top,
                                width: rect.width,
                                child: GestureDetector(
                                  onTap: () => _tapWord(word),
                                  child: StarBurstOverlay(
                                    burstKey: _wordBurstKeys[word] ?? 0,
                                    size: 26,
                                    alignment: Alignment.topRight,
                                    child: AnimatedContainer(
                                      duration: AppMotionSpec.chooseDuration(
                                        context,
                                        const Duration(milliseconds: 180),
                                        const Duration(milliseconds: 120),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: found
                                            ? const Color(0xFFD7FFE2)
                                            : isWrongTap
                                            ? const Color(0xFFFFE2DD)
                                            : _baseCardColor(index),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: found
                                              ? const Color(0xFF2A9D8F)
                                              : isWrongTap
                                              ? const Color(0xFFE45832)
                                              : Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          word,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            color: found || isWrongTap
                                                ? const Color(0xFF1D3557)
                                                : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 30,
                    child: Text(
                      _feedbackText,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: _feedbackText == 'Bagus!'
                            ? const Color(0xFF0B6B58)
                            : const Color(0xFFE45832),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_showIntroOverlay) _buildIntroOverlay(context),
        ],
      ),
    );
  }
}

class CariKumpulResultScreen extends StatelessWidget {
  const CariKumpulResultScreen({super.key, required this.found});

  final int found;

  @override
  Widget build(BuildContext context) {
    return GameCompletionTemplate(
      score: found,
      total: 5,
      statusTitle: 'Hebat!',
      statusSubtitle: 'Anda berjaya!',
      confettiActive: true,
      completionText: 'Anda telah menamatkan permainan Pilih & Kumpul.',
      onPlayAgain: () {
        pushReplacementAdaptive(context, const CariKumpulGameScreen());
      },
      onMainMenu: () {
        pushReplacementAdaptive(context, const GameMenuScreen());
      },
    );
  }
}
