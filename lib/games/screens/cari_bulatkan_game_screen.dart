import 'package:flutter/material.dart';

import '../../shared/gamification/gamification.dart';
import '../../shared/motion/app_motion_navigation.dart';
import '../../shared/progress/progress_tracker.dart';

class CariBulatkanGameScreen extends StatefulWidget {
  const CariBulatkanGameScreen({super.key});

  @override
  State<CariBulatkanGameScreen> createState() => _CariBulatkanGameScreenState();
}

class _CariBulatkanGameScreenState extends State<CariBulatkanGameScreen> {
  static const List<List<String>> _grid = [
    ['M', 'E', 'N', 'C', 'U', 'C', 'I'],
    ['A', 'R', 'T', 'Y', 'L', 'O', 'R'],
    ['D', 'E', 'M', 'E', 'M', 'A', 'D'],
    ['A', 'S', 'N', 'A', 'N', 'A', 'M'],
    ['M', 'I', 'R', 'Y', 'S', 'A', 'T'],
    ['E', 'G', 'N', 'E', 'M', 'E', 'G'],
    ['M', 'A', 'S', 'E', 'M', 'G', 'S'],
  ];

  static final Map<String, List<_Cell>> _targetsByPlacement = {
    'MENCUCI': List.generate(7, (i) => _Cell(0, i)),
    'MEMADAM': List.generate(7, (i) => _Cell(2, i)),
    'MENANAM': List.generate(7, (i) => _Cell(3, i)),
    'MENYIRAM': List.generate(7, (i) => _Cell(i, 2)),
    'MENGEMAS': List.generate(5, (i) => _Cell(6, i + 2)),
  };

  final GlobalKey _gridKey = GlobalKey();
  final Set<String> _foundWords = <String>{};
  final Set<String> _foundCells = <String>{};
  bool _gameRecorded = false;

  List<_Cell> _currentPath = <_Cell>[];
  _Cell? _startCell;

  _Cell? _positionToCell(Offset globalPosition) {
    final box = _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) {
      return null;
    }
    final local = box.globalToLocal(globalPosition);
    final width = box.size.width / 7;
    final height = box.size.height / 7;
    final row = (local.dy / height).floor();
    final col = (local.dx / width).floor();
    if (row < 0 || row > 6 || col < 0 || col > 6) {
      return null;
    }
    return _Cell(row, col);
  }

  List<_Cell> _buildLine(_Cell start, _Cell end) {
    final cells = <_Cell>[];
    if (start.row == end.row) {
      final step = end.col >= start.col ? 1 : -1;
      for (var col = start.col; col != end.col + step; col += step) {
        cells.add(_Cell(start.row, col));
      }
      return cells;
    }
    if (start.col == end.col) {
      final step = end.row >= start.row ? 1 : -1;
      for (var row = start.row; row != end.row + step; row += step) {
        cells.add(_Cell(row, start.col));
      }
      return cells;
    }
    return <_Cell>[start];
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

  void _finishSelection() {
    String? matchedWord;
    List<_Cell>? matchedPath;

    for (final entry in _targetsByPlacement.entries) {
      final targetWord = entry.key;
      final targetPath = entry.value;
      if (_samePath(_currentPath, targetPath) ||
          _samePathReversed(_currentPath, targetPath)) {
        matchedWord = targetWord;
        matchedPath = targetPath;
        break;
      }
    }

    if (matchedWord != null && !_foundWords.contains(matchedWord)) {
      setState(() {
        _foundWords.add(matchedWord!);
        for (final cell in matchedPath!) {
          _foundCells.add(cell.key);
        }
      });

      if (_foundWords.length == _targetsByPlacement.length) {
        if (!_gameRecorded) {
          _gameRecorded = true;
          ProgressTracker.instance.recordGameSession(
            starsEarned: _foundWords.length,
            starsPossible: _targetsByPlacement.length,
          );
          final gamification = GamificationScope.of(context);
          gamification.awardXp((_foundWords.length * 5).clamp(10, 40));
          gamification.awardStars(2);
          gamification.grantReward(
            title: 'Cari & Bulatkan Selesai',
            message: 'Anda berjaya melengkapkan pencarian perkataan.',
            coins: 8,
          );
        }
        Future<void>.delayed(const Duration(milliseconds: 300), () {
          if (!mounted) {
            return;
          }
          pushReplacementAdaptive(
            context,
            CariBulatkanResultScreen(foundWords: _foundWords.length),
          );
        });
      }
    }

    setState(() {
      _currentPath = <_Cell>[];
      _startCell = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentKeys = _currentPath.map((e) => e.key).toSet();
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FF),
      body: SafeArea(
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
                      'Cari & Bulatkan',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1D3557),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'MENCUCI, MENYIRAM, MENANAM, MENGEMAS, MEMADAM',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onPanStart: (details) {
                  final start = _positionToCell(details.globalPosition);
                  if (start == null) {
                    return;
                  }
                  setState(() {
                    _startCell = start;
                    _currentPath = <_Cell>[start];
                  });
                },
                onPanUpdate: (details) {
                  final start = _startCell;
                  final end = _positionToCell(details.globalPosition);
                  if (start == null || end == null) {
                    return;
                  }
                  setState(() => _currentPath = _buildLine(start, end));
                },
                onPanEnd: (_) => _finishSelection(),
                child: Container(
                  key: _gridKey,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFD2E7F8)),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Column(
                      children: List.generate(7, (row) {
                        return Expanded(
                          child: Row(
                            children: List.generate(7, (col) {
                              final key = '${row}_$col';
                              final isCurrent = currentKeys.contains(key);
                              final isFound = _foundCells.contains(key);
                              return Expanded(
                                child: Container(
                                  margin: const EdgeInsets.all(2),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isFound
                                        ? const Color(0xFFC4FFD8)
                                        : isCurrent
                                        ? const Color(0xFFFFE59F)
                                        : const Color(0xFFF7FBFF),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isFound
                                          ? const Color(0xFF2A9D8F)
                                          : const Color(0xFFD6E4F1),
                                    ),
                                  ),
                                  child: Text(
                                    _grid[row][col],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF1D3557),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      }),
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
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: found
                          ? const Color(0xFFD7FFE2)
                          : const Color(0xFFF3F7FB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: found
                            ? const Color(0xFF2A9D8F)
                            : const Color(0xFFDBE7F1),
                      ),
                    ),
                    child: Text(
                      word,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: found
                            ? const Color(0xFF0B6B58)
                            : const Color(0xFF1D3557),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CariBulatkanResultScreen extends StatelessWidget {
  const CariBulatkanResultScreen({super.key, required this.foundWords});

  final int foundWords;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6D9),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ConfettiCelebration(
            active: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const MascotWidget(
                  assetPath: 'assets/aminPage3.png',
                  width: 84,
                  height: 84,
                  state: MascotState.celebrate,
                ),
                const Text(
                  'Hebat!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1D3557),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Anda berjaya jumpa $foundWords/5 perkataan.',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Icon(
                  Icons.sentiment_satisfied_rounded,
                  size: 44,
                  color: Color(0xFFF4B400),
                ),
                const SizedBox(height: 24),
                AnimatedKidButton(
                  label: 'Main Lagi',
                  icon: Icons.refresh_rounded,
                  onPressed: () {
                    pushReplacementAdaptive(
                      context,
                      const CariBulatkanGameScreen(),
                    );
                  },
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Kembali ke Main'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Cell {
  const _Cell(this.row, this.col);

  final int row;
  final int col;

  String get key => '${row}_$col';
}
