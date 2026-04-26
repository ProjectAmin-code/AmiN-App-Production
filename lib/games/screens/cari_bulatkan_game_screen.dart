import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../shared/gamification/gamification.dart';
import '../../shared/motion/app_motion_navigation.dart';
import '../../shared/motion/app_motion_spec.dart';
import '../../shared/progress/progress_tracker.dart';
import '../widgets/game_completion_template.dart';
import 'game_menu_screen.dart';

class CariBulatkanGameScreen extends StatefulWidget {
  const CariBulatkanGameScreen({super.key});

  @override
  State<CariBulatkanGameScreen> createState() => _CariBulatkanGameScreenState();
}

class _CariBulatkanGameScreenState extends State<CariBulatkanGameScreen> {
  // Flip this to false for a quick rollback of the intro modal experience.
  static const bool _enableIntroCoachOverlay = true;
  static const String _introInstructionScript =
      'Arahan: Cari dan pilih 6 kata berimbuhan meN- yang tersembunyi dalam kotak huruf.';
  static const String _introMascotAsset =
      'assets/Action Figures/AmiN pointing right.svg';

  static const List<List<String>> _grid = [
    ['m', 'e', 'n', 'g', 'e', 'm', 'a', 's'],
    ['e', 'u', 'a', 'n', 'l', 'e', 'm', 'i'],
    ['n', 't', 'd', 'u', 'c', 'a', 'p', 'g'],
    ['i', 'a', 'w', 'n', 'n', 'o', 'd', 'n'],
    ['u', 's', 'k', 'a', 'a', 'c', 'r', 'a'],
    ['p', 'o', 'n', 's', 'f', 'm', 'o', 'n'],
    ['a', 'e', 't', 'a', 'n', 's', 'e', 'e'],
    ['m', 'e', 'n', 'c', 'u', 'c', 'i', 'm'],
  ];

  static final Map<String, List<_Cell>> _targetsByPlacement = {
    'mencuci': List.generate(7, (i) => _Cell(7, i)),
    'menanam': List.generate(7, (i) => _Cell(7 - i, i)),
    'mengemas': List.generate(8, (i) => _Cell(0, i)),
    'memandu': List.generate(7, (i) => _Cell(7 - i, 7 - i)),
    'menangis': List.generate(8, (i) => _Cell(7 - i, 7)),
    'meniup': List.generate(6, (i) => _Cell(i, 0)),
  };

  static const List<Color> _foundWordPalette = [
    Color(0xFFEA7AC3),
    Color(0xFF62DFA8),
    Color(0xFFFFC768),
    Color(0xFF75C8FF),
    Color(0xFFB8A5FF),
    Color(0xFFFF9A73),
  ];

  final Set<String> _foundWords = <String>{};
  final Map<String, Color> _foundCellColors = <String, Color>{};
  final Map<String, Color> _foundWordColors = <String, Color>{};
  List<_Cell> _currentPath = <_Cell>[];
  _Cell? _startCell;
  String _feedback = 'Seret huruf untuk pilih perkataan.';
  bool _selectionLocked = false;
  Timer? _clearSelectionTimer;
  Timer? _introWordTimer;
  bool _showIntroOverlay = _enableIntroCoachOverlay;
  bool _introOverlayVisible = false;
  bool _introClosing = false;
  bool _introIsTyping = false;
  List<String> _introWords = const <String>[];
  int _visibleIntroWordCount = 0;
  int _introTypingSession = 0;

  @override
  void initState() {
    super.initState();
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
    _clearSelectionTimer?.cancel();
    _introWordTimer?.cancel();
    super.dispose();
  }

  void _onDragStart(Offset localPosition, Size boardSize) {
    if (_selectionLocked || _showIntroOverlay) {
      return;
    }
    final cell = _cellFromLocalPosition(localPosition, boardSize);
    if (cell == null) {
      return;
    }
    setState(() {
      _startCell = cell;
      _currentPath = <_Cell>[cell];
      _feedback = 'Teruskan seret untuk pilih sehingga huruf akhir.';
    });
  }

  void _onDragUpdate(Offset localPosition, Size boardSize) {
    if (_selectionLocked || _showIntroOverlay || _startCell == null) {
      return;
    }
    final cell = _cellFromLocalPosition(localPosition, boardSize);
    if (cell == null) {
      return;
    }
    final path = _buildLine(_startCell!, cell);
    setState(() => _currentPath = path);
  }

  void _onDragEnd() {
    if (_selectionLocked || _showIntroOverlay) {
      return;
    }
    if (_startCell == null || _currentPath.length < 2) {
      setState(() {
        _currentPath = <_Cell>[];
        _startCell = null;
        _feedback = 'Seret huruf untuk pilih perkataan.';
      });
      return;
    }
    _evaluatePath(_currentPath);
  }

  void _onDragCancel() {
    if (_selectionLocked) {
      return;
    }
    setState(() {
      _startCell = null;
      _currentPath = <_Cell>[];
      _feedback = 'Seret huruf untuk pilih perkataan.';
    });
  }

  _Cell? _cellFromLocalPosition(Offset localPosition, Size boardSize) {
    if (boardSize.width <= 0 || boardSize.height <= 0) {
      return null;
    }
    if (localPosition.dx < 0 ||
        localPosition.dy < 0 ||
        localPosition.dx >= boardSize.width ||
        localPosition.dy >= boardSize.height) {
      return null;
    }
    final rowCount = _grid.length;
    final colCount = _grid.first.length;
    final cellWidth = boardSize.width / colCount;
    final cellHeight = boardSize.height / rowCount;
    final row = ((localPosition.dy / cellHeight).floor()).clamp(
      0,
      rowCount - 1,
    );
    final col = ((localPosition.dx / cellWidth).floor()).clamp(0, colCount - 1);
    return _Cell(row, col);
  }

  int _step(int value) {
    if (value == 0) {
      return 0;
    }
    return value > 0 ? 1 : -1;
  }

  List<_Cell> _buildLine(_Cell start, _Cell end) {
    final dr = end.row - start.row;
    final dc = end.col - start.col;
    if (dr == 0 && dc == 0) {
      return <_Cell>[start];
    }
    final absDr = dr.abs();
    final absDc = dc.abs();

    int rowStep = 0;
    int colStep = 0;
    int steps = 0;

    if (absDr == 0) {
      rowStep = 0;
      colStep = _step(dc);
      steps = absDc;
    } else if (absDc == 0) {
      rowStep = _step(dr);
      colStep = 0;
      steps = absDr;
    } else {
      final ratio = absDr / absDc;
      if (ratio > 1.6) {
        rowStep = _step(dr);
        colStep = 0;
        steps = absDr;
      } else if (ratio < 0.625) {
        rowStep = 0;
        colStep = _step(dc);
        steps = absDc;
      } else {
        rowStep = _step(dr);
        colStep = _step(dc);
        steps = min(absDr, absDc);
      }
    }

    final cells = <_Cell>[];
    for (var i = 0; i <= steps; i++) {
      cells.add(_Cell(start.row + (rowStep * i), start.col + (colStep * i)));
    }
    return cells;
  }

  Color _colorForWord(String word) {
    return _foundWordColors.putIfAbsent(word, () {
      final index = _foundWordColors.length % _foundWordPalette.length;
      return _foundWordPalette[index];
    });
  }

  bool _samePath(List<_Cell> a, List<_Cell> b) {
    if (a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i++) {
      if (a[i].row != b[i].row || a[i].col != b[i].col) {
        return false;
      }
    }
    return true;
  }

  bool _samePathReversed(List<_Cell> a, List<_Cell> b) {
    if (a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i++) {
      final j = b.length - 1 - i;
      if (a[i].row != b[j].row || a[i].col != b[j].col) {
        return false;
      }
    }
    return true;
  }

  void _evaluatePath(List<_Cell> path) {
    String? matchedWord;
    List<_Cell>? matchedCells;

    for (final entry in _targetsByPlacement.entries) {
      if (_samePath(path, entry.value) ||
          _samePathReversed(path, entry.value)) {
        matchedWord = entry.key;
        matchedCells = entry.value;
        break;
      }
    }

    setState(() {
      _selectionLocked = true;
      _currentPath = path;
      if (matchedWord == null) {
        _feedback = 'Cuba lagi!';
      } else if (_foundWords.contains(matchedWord)) {
        _feedback = 'Perkataan itu sudah ditemui.';
      } else {
        final highlightColor = _colorForWord(matchedWord);
        _foundWords.add(matchedWord);
        for (final cell in matchedCells!) {
          _foundCellColors.putIfAbsent(cell.key, () => highlightColor);
        }
        _feedback = 'Betul! "$matchedWord"';
      }
    });

    if (_foundWords.length == _targetsByPlacement.length) {
      _completeRound();
      return;
    }

    _clearSelectionTimer?.cancel();
    _clearSelectionTimer = Timer(
      AppMotionSpec.chooseDuration(
        context,
        const Duration(milliseconds: 420),
        const Duration(milliseconds: 260),
      ),
      () {
        if (!mounted) {
          return;
        }
        setState(() {
          _currentPath = <_Cell>[];
          _startCell = null;
          _selectionLocked = false;
          if (!_feedback.startsWith('Betul')) {
            _feedback = 'Seret huruf untuk pilih perkataan.';
          }
        });
      },
    );
  }

  void _completeRound() {
    ProgressTracker.instance.recordGameSession(
      starsEarned: _foundWords.length,
      starsPossible: _targetsByPlacement.length,
      lessonId: 'M005_CariPilih',
    );
    final gamification = GamificationScope.of(context);
    gamification.awardXp((_foundWords.length * 4).clamp(10, 30));
    gamification.awardStars(1);

    _clearSelectionTimer?.cancel();
    _clearSelectionTimer = Timer(
      AppMotionSpec.chooseDuration(
        context,
        const Duration(milliseconds: 900),
        const Duration(milliseconds: 500),
      ),
      () {
        if (!mounted) {
          return;
        }
        pushReplacementAdaptive(
          context,
          CariBulatkanResultScreen(foundWords: _foundWords.length),
        );
      },
    );
  }

  Future<void> _startIntroCoachSequence() async {
    if (!mounted || !_showIntroOverlay) {
      return;
    }
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
    _introTypingSession += 1;
    _introWordTimer?.cancel();
    if (!mounted) {
      return;
    }
    setState(() {
      _introClosing = true;
      _introOverlayVisible = false;
    });
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
    final currentKeys = _currentPath.map((cell) => cell.key).toSet();
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FF),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                      const Expanded(
                        child: Text(
                          'Cari & Pilih',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1D3557),
                          ),
                        ),
                      ),
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
                          '${_foundWords.length} / ${_targetsByPlacement.length}',
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
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F7FB),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFD8E2EE)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1A000000),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final boardSize = Size(
                                  constraints.maxWidth,
                                  constraints.maxHeight,
                                );
                                return GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onPanStart: (details) => _onDragStart(
                                    details.localPosition,
                                    boardSize,
                                  ),
                                  onPanUpdate: (details) => _onDragUpdate(
                                    details.localPosition,
                                    boardSize,
                                  ),
                                  onPanEnd: (_) => _onDragEnd(),
                                  onPanCancel: _onDragCancel,
                                  child: Column(
                                    children: List.generate(_grid.length, (
                                      row,
                                    ) {
                                      return Expanded(
                                        child: Row(
                                          children: List.generate(
                                            _grid[row].length,
                                            (col) {
                                              final cell = _Cell(row, col);
                                              final key = cell.key;
                                              final isCurrent = currentKeys
                                                  .contains(key);
                                              final foundColor =
                                                  _foundCellColors[key];
                                              final isFound =
                                                  foundColor != null;
                                              return Expanded(
                                                child: Container(
                                                  margin: const EdgeInsets.all(
                                                    1.5,
                                                  ),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: isFound
                                                        ? foundColor
                                                        : isCurrent
                                                        ? const Color(
                                                            0xFFFFDA70,
                                                          )
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    border: Border.all(
                                                      color: isFound
                                                          ? foundColor
                                                          : isCurrent
                                                          ? const Color(
                                                              0xFFF0B93D,
                                                            )
                                                          : const Color(
                                                              0xFFE2E8F0,
                                                            ),
                                                      width:
                                                          isFound || isCurrent
                                                          ? 1.6
                                                          : 1,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    _grid[row][col]
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: Color(0xFF1F2937),
                                                      height: 1,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _targetsByPlacement.keys.map((word) {
                      final found = _foundWords.contains(word);
                      final chipColor =
                          _foundWordColors[word] ?? const Color(0xFFF5F7FA);
                      return AnimatedContainer(
                        duration: AppMotionSpec.chooseDuration(
                          context,
                          const Duration(milliseconds: 180),
                          const Duration(milliseconds: 120),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: found ? chipColor : const Color(0xFFF3F7FB),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: found ? chipColor : const Color(0xFFDBE7F1),
                          ),
                        ),
                        child: Text(
                          word.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: found
                                ? const Color(0xFF111827)
                                : const Color(0xFF1D3557),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 30,
                    child: Text(
                      _feedback,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: _feedback.startsWith('Betul')
                            ? const Color(0xFF0B6B58)
                            : _feedback.startsWith('Cuba')
                            ? const Color(0xFFE45832)
                            : const Color(0xFF1D3557),
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

class CariBulatkanResultScreen extends StatelessWidget {
  const CariBulatkanResultScreen({super.key, required this.foundWords});

  final int foundWords;

  @override
  Widget build(BuildContext context) {
    return GameCompletionTemplate(
      score: foundWords,
      total: 6,
      statusTitle: 'Hebat!',
      statusSubtitle: 'Anda berjaya!',
      confettiActive: true,
      completionText: 'Anda telah menamatkan permainan Cari & Pilih.',
      onPlayAgain: () {
        pushReplacementAdaptive(context, const CariBulatkanGameScreen());
      },
      onMainMenu: () {
        pushReplacementAdaptive(context, const GameMenuScreen());
      },
    );
  }
}

class _Cell {
  const _Cell(this.row, this.col);

  final int row;
  final int col;

  String get key => '${row}_$col';
}
