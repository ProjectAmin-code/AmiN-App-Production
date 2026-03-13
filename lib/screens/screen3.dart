import 'package:flutter/material.dart';

import '../games/screens/game_menu_screen.dart';
import '../learning/screens/belajar_flow_screen.dart';
import '../quiz/screens/quiz_level_gateway_screen.dart';
import '../shared/design/app_design_tokens.dart';
import '../shared/gamification/gamification.dart';
import '../shared/motion/app_motion_navigation.dart';
import '../shared/progress/progress_tracker.dart';
import 'progress_screen.dart';

class Screen3 extends StatefulWidget {
  const Screen3({super.key, required this.name});

  final String name;

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ProgressTracker.instance.setUserName(widget.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    final gamification = GamificationScope.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 560,
                    minHeight: constraints.maxHeight - 32,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Mod Latihan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          StreakWidget(streak: gamification.streak, compact: true),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const MascotWidget(
                        assetPath: 'assets/aminPage3.png',
                        width: 190,
                        height: 190,
                        state: MascotState.idle,
                      ),
                      const SizedBox(height: 12),
                      const LessonCard(
                        child: Text(
                          'Pilih satu untuk bermula!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _modeCard(
                              heroTag: 'hero-mode-belajar',
                              title: 'Belajar',
                              icon: Icons.book_rounded,
                              color: const Color(0xFF3B82F6),
                              onTap: () {
                                gamification.awardXp(10, reason: 'Mula Belajar');
                                pushAdaptive(
                                  context,
                                  BelajarFlowScreen(name: widget.name),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _modeCard(
                              heroTag: 'hero-mode-kuiz',
                              title: 'Kuiz',
                              icon: Icons.quiz_rounded,
                              color: AppColors.secondary,
                              onTap: () {
                                gamification.awardXp(10, reason: 'Mula Kuiz');
                                pushAdaptive(
                                  context,
                                  QuizLevelGatewayScreen(name: widget.name),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _modeCard(
                              heroTag: 'hero-mode-main',
                              title: 'Main',
                              icon: Icons.sports_esports_rounded,
                              color: const Color(0xFFFF7F22),
                              onTap: () {
                                gamification.awardXp(10, reason: 'Mula Main');
                                pushAdaptive(context, const GameMenuScreen());
                              },
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _modeCard(
                              heroTag: 'hero-mode-kemajuan',
                              title: 'Kemajuan',
                              icon: Icons.insights_rounded,
                              color: const Color(0xFF2EAD63),
                              onTap: () {
                                pushAdaptive(
                                  context,
                                  ProgressScreen(name: widget.name),
                                );
                              },
                            ),
                          ),
                        ],
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

  Widget _modeCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String heroTag,
  }) {
    return LessonCard(
      heroTag: heroTag,
      onTap: onTap,
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: SizedBox(
        height: 108,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 38),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
