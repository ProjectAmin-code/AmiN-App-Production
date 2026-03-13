import 'package:flutter/material.dart';

import '../../shared/gamification/gamification.dart';
import '../../shared/motion/app_motion_navigation.dart';
import '../../shared/motion/app_motion_widgets.dart';
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
    Alignment(-0.80, -0.78),
    Alignment(0.10, -0.82),
    Alignment(0.75, -0.55),
    Alignment(-0.35, -0.45),
    Alignment(0.60, -0.20),
    Alignment(-0.75, -0.10),
    Alignment(-0.05, 0.02),
    Alignment(0.72, 0.10),
    Alignment(-0.62, 0.30),
    Alignment(0.18, 0.34),
    Alignment(-0.12, 0.62),
    Alignment(0.72, 0.66),
  ];

  final Set<String> _found = <String>{};
  final Map<String, int> _wordBurstKeys = <String, int>{};
  bool _showCelebration = false;
  bool _gameRecorded = false;

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
                          return Stack(
                            children: _allWords.asMap().entries.map((entry) {
                              final index = entry.key;
                              final word = entry.value;
                              final found = _found.contains(word);
                              final alignment = _positions[index];
                              return Align(
                                alignment: alignment,
                                child: GestureDetector(
                                  onTap: () => _onTapWord(word),
                                  child: StarBurstOverlay(
                                    burstKey: _wordBurstKeys[word] ?? 0,
                                    size: 30,
                                    alignment: Alignment.topRight,
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 220,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: found
                                            ? const Color(0xFFD7FFE2)
                                            : const Color(0xFFF5F8FB),
                                        borderRadius: BorderRadius.circular(12),
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
                                              fontSize: 18,
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
                          );
                          final gamification = GamificationScope.of(context);
                          gamification.awardXp((_found.length * 4).clamp(8, 40));
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
                  'Tahniah!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1D3557),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFF4B400),
                      size: 34,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$stars',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
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
                      const CariKumpulGameScreen(),
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
