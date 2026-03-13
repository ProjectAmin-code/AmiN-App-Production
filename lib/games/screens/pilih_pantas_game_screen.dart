import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../shared/gamification/gamification.dart';
import '../../shared/motion/app_motion_navigation.dart';
import '../../shared/motion/app_motion_widgets.dart';
import '../../shared/progress/progress_tracker.dart';

class PilihPantasGameScreen extends StatefulWidget {
  const PilihPantasGameScreen({super.key});

  @override
  State<PilihPantasGameScreen> createState() => _PilihPantasGameScreenState();
}

class _PilihPantasGameScreenState extends State<PilihPantasGameScreen> {
  static const List<String> _listWithMen = [
    'membaca',
    'menulis',
    'melukis',
    'menyapu',
    'memotong',
    'mengangkat',
  ];

  static const List<String> _listWithoutMen = [
    'buku',
    'pensel',
    'bola',
    'minum',
    'makan',
    'tidur',
  ];

  late Timer _ticker;
  final Random _random = Random();
  late DateTime _endTime;
  int _stars = 0;
  int _queueIndex = 0;
  int _starBurstTick = 0;
  int _attempts = 0;
  List<String> _queue = <String>[];

  String get _currentWord => _queue[_queueIndex];

  @override
  void initState() {
    super.initState();
    _queue = _buildRoundQueue();
    _endTime = DateTime.now().add(const Duration(seconds: 25));
    _ticker = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (!mounted) {
        return;
      }
      if (DateTime.now().isAfter(_endTime)) {
        _ticker.cancel();
        ProgressTracker.instance.recordGameSession(
          starsEarned: _stars,
          starsPossible: _attempts <= 0 ? 1 : _attempts,
        );
        final gamification = GamificationScope.of(context);
        gamification.awardXp((_stars * 2).clamp(4, 40));
        gamification.awardStars(_stars > 0 ? 1 : 0);
        if (_stars >= 5) {
          gamification.grantReward(
            title: 'Ganjaran Pilih Pantas',
            message: 'Prestasi hebat dalam masa pantas!',
            coins: 5,
          );
        }
        pushReplacementAdaptive(
          context,
          PilihPantasResultScreen(stars: _stars),
        );
      } else {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }

  List<String> _buildRoundQueue() {
    final all = [..._listWithMen, ..._listWithoutMen];
    all.shuffle(_random);
    return all;
  }

  void _advanceWord() {
    if (_queueIndex < _queue.length - 1) {
      setState(() => _queueIndex += 1);
      return;
    }
    final previous = _queue.last;
    final nextQueue = _buildRoundQueue();
    if (nextQueue.first == previous && nextQueue.length > 1) {
      final first = nextQueue.removeAt(0);
      nextQueue.add(first);
    }
    setState(() {
      _queue = nextQueue;
      _queueIndex = 0;
    });
  }

  void _answer(bool chooseMen) {
    final hasMen = _listWithMen.contains(_currentWord);
    _attempts += 1;
    if (chooseMen == hasMen) {
      setState(() {
        _stars += 1;
        _starBurstTick += 1;
      });
      final gamification = GamificationScope.of(context);
      gamification.awardXp(3, reason: 'Padanan tepat');
    }
    _advanceWord();
  }

  @override
  Widget build(BuildContext context) {
    final totalMs = 25000;
    final remainingMs = _endTime
        .difference(DateTime.now())
        .inMilliseconds
        .clamp(0, totalMs);
    final progress = remainingMs / totalMs;

    return Scaffold(
      backgroundColor: const Color(0xFFDFF3FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                      'Pilih Pantas',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1D3557),
                      ),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 3,
                          color: const Color(0xFF2A9D8F),
                        ),
                      ),
                      const Icon(Icons.timer_rounded, size: 16),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Expanded(
                child: StarBurstOverlay(
                  burstKey: _starBurstTick,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: Text(
                        _currentWord,
                        key: ValueKey(_currentWord),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 46,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1D3557),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AnimatedKidButton(
                      label: 'Ada meN-',
                      onPressed: () => _answer(true),
                      backgroundColor: const Color(0xFF2A9D8F),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AnimatedKidButton(
                      label: 'Tiada meN-',
                      onPressed: () => _answer(false),
                      backgroundColor: const Color(0xFF8D99AE),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PilihPantasResultScreen extends StatelessWidget {
  const PilihPantasResultScreen({super.key, required this.stars});

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
                  width: 82,
                  height: 82,
                  state: MascotState.celebrate,
                ),
                const Text(
                  'Pilih Pantas Tamat',
                  style: TextStyle(
                    fontSize: 30,
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
                      const PilihPantasGameScreen(),
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
