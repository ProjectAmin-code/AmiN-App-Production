import 'dart:math';

import 'package:flutter/material.dart';

import '../../shared/gamification/gamification.dart';
import '../../shared/motion/app_motion_navigation.dart';
import '../../shared/motion/app_motion_widgets.dart';
import '../../shared/navigation/app_screen_wiring.dart';
import '../../shared/progress/progress_tracker.dart';

class CariKumpulGameScreen extends StatefulWidget {
  const CariKumpulGameScreen({super.key});

  @override
  State<CariKumpulGameScreen> createState() => _CariKumpulGameScreenState();
}

class _CariKumpulGameScreenState extends State<CariKumpulGameScreen> {
  static const Set<String> _targets = {
    'menyiram',
    'menjahit',
    'menconteng',
    'menjaga',
    'menyusun',
  };

  static const List<String> _allWords = [
    'menyiram',
    'menjahit',
    'menconteng',
    'menjaga',
    'menyusun',
    'belajar',
    'terambil',
    'berlari',
    'meja',
    'air',
    'baju',
    'kerusi',
  ];

  static const List<Alignment> _positions = [
    Alignment(-0.58, -0.80),
    Alignment(0.08, -0.84),
    Alignment(0.56, -0.58),
    Alignment(-0.28, -0.44),
    Alignment(0.48, -0.18),
    Alignment(-0.54, -0.08),
    Alignment(-0.04, 0.04),
    Alignment(0.56, 0.12),
    Alignment(-0.48, 0.30),
    Alignment(0.18, 0.38),
    Alignment(-0.12, 0.62),
    Alignment(0.46, 0.68),
  ];

  final Set<String> _found = <String>{};
  final Map<String, int> _wordBurstKeys = <String, int>{};
  late final List<String> _displayWords;
  bool _showCelebration = false;
  bool _gameRecorded = false;

  @override
  void initState() {
    super.initState();
    _displayWords = List<String>.from(_allWords)..shuffle(Random());
  }

  void _onTapWord(String word) {
    if (!_targets.contains(word) || _found.contains(word)) {
      return;
    }
    setState(() {
      _found.add(word);
      _wordBurstKeys[word] = (_wordBurstKeys[word] ?? 0) + 1;
    });
    if (_found.length == _targets.length && !_showCelebration) {
      setState(() => _showCelebration = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9FAFF),
      body: SafeArea(
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
                      'Cari & Kumpul',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1D3557),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${_found.length}/5',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: Color(0xFFF4B400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Cari 5 kata berimbuhan men-',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2F4858),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 10,
                                runSpacing: 12,
                                children: _displayWords.asMap().entries.map((
                                  entry,
                                ) {
                                  final index = entry.key;
                                  final word = entry.value;
                                  final found = _found.contains(word);
                                  return Transform.translate(
                                    offset: Offset(0, _positions[index].y * 4),
                                    child: GestureDetector(
                                      onTap: () => _onTapWord(word),
                                      child: StarBurstOverlay(
                                        burstKey: _wordBurstKeys[word] ?? 0,
                                        size: 26,
                                        alignment: Alignment.topRight,
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 220,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 9,
                                          ),
                                          decoration: BoxDecoration(
                                            color: found
                                                ? const Color(0xFFD7FFE2)
                                                : const Color(0xFFF5F8FB),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              color: found
                                                  ? const Color(0xFF2A9D8F)
                                                  : const Color(0xFFDCE6F0),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                word,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w800,
                                                  color: found
                                                      ? const Color(0xFF0B6B58)
                                                      : const Color(0xFF1D3557),
                                                ),
                                              ),
                                              if (found) ...[
                                                const SizedBox(width: 6),
                                                const Icon(
                                                  Icons.star_rounded,
                                                  color: Color(0xFFF4B400),
                                                  size: 18,
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    CelebrationBurst(
                      active: _showCelebration,
                      onCompleted: () {
                        if (!_gameRecorded) {
                          _gameRecorded = true;
                          ProgressTracker.instance.recordGameSession(
                            starsEarned: _found.length,
                            starsPossible: _targets.length,
                            lessonId: 'M004_CariKumpul',
                          );
                          final gamification = GamificationScope.of(context);
                          gamification.awardXp(
                            (_found.length * 4).clamp(8, 40),
                          );
                          gamification.awardStars(2);
                          if (_found.length == _targets.length) {
                            gamification.grantReward(
                              title: 'Cari & Kumpul Lengkap',
                              message: 'Semua perkataan berjaya dikumpul!',
                              coins: 8,
                            );
                          }
                        }
                        if (!mounted) {
                          return;
                        }
                        pushReplacementAdaptive(
                          context,
                          CariKumpulResultScreen(stars: _found.length),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CariKumpulResultScreen extends StatelessWidget {
  const CariKumpulResultScreen({super.key, required this.stars});

  final int stars;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF26C4D9),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ConfettiCelebration(
              active: true,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        stars.clamp(0, 5),
                        (_) => const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3),
                          child: Icon(
                            Icons.star_rounded,
                            color: Color(0xFFF4D03F),
                            size: 34,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Icon(
                      Icons.sentiment_satisfied_alt_rounded,
                      size: 120,
                      color: Color(0xFFF8D24B),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Hebat!',
                      style: TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Anda jumpa semua\nkata men-',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 34,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 230,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1D3557),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        onPressed: () {
                          pushReplacementAdaptive(
                            context,
                            const CariKumpulGameScreen(),
                          );
                        },
                        child: const Text(
                          'Main Lagi',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 230,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1D3557),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        onPressed: () => goToMainMenu(context),
                        child: const Text(
                          'Kembali ke Main',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
