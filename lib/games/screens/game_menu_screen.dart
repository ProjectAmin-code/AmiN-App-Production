import 'package:flutter/material.dart';

import '../../shared/design/app_design_tokens.dart';
import '../../shared/gamification/gamification.dart';
import '../../shared/motion/app_motion_navigation.dart';
import '../../shared/motion/app_motion_widgets.dart';
import '../../shared/navigation/app_screen_wiring.dart';
import 'betul_atau_salah_game_screen.dart';
import 'cari_bulatkan_game_screen.dart';
import 'cari_kumpul_game_screen.dart';
import 'pilih_pantas_game_screen.dart';

class GameMenuScreen extends StatelessWidget {
  const GameMenuScreen({super.key});

  Widget _menuButton({
    required BuildContext context,
    required String label,
    required Color color,
    required Widget destination,
    required String heroTag,
    IconData icon = Icons.play_arrow_rounded,
  }) {
    return Hero(
      tag: heroTag,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: BounceTapCard(
          onTap: () => pushAdaptive(context, destination),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      height: 1.05,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gamification = GamificationScope.of(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8EC5FF), Color(0xFF68A7FF), Color(0xFF4A8FF3)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final contentWidth = constraints.maxWidth > 540
                      ? 540.0
                      : constraints.maxWidth;
                  return SizedBox.expand(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: contentWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  StreakWidget(
                                    streak: gamification.streak,
                                    compact: true,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const MascotWidget(
                                assetPath:
                                    'assets/Action Figures/AmiN Pointing.svg',
                                width: 118,
                                height: 118,
                                state: MascotState.encourage,
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Jom Main!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFFFFF176),
                                  fontSize: 56,
                                  fontWeight: FontWeight.w900,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Pilih permainan untuk menguji kefahaman anda.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 22,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 24),
                              _menuButton(
                                context: context,
                                label: 'Pilih Pantas',
                                color: const Color(0xFFFF8A34),
                                destination: const PilihPantasGameScreen(),
                                heroTag: 'hero-game-pilih-pantas',
                                icon: Icons.flash_on_rounded,
                              ),
                              _menuButton(
                                context: context,
                                label: 'Pilih & Kumpul',
                                color: const Color(0xFF2EAD63),
                                destination: const CariKumpulGameScreen(),
                                heroTag: 'hero-game-pilih-kumpul',
                                icon: Icons.touch_app_rounded,
                              ),
                              _menuButton(
                                context: context,
                                label: 'Cari & Pilih',
                                color: const Color(0xFF5A67D8),
                                destination: const CariBulatkanGameScreen(),
                                heroTag: 'hero-game-cari-pilih',
                                icon: Icons.grid_on_rounded,
                              ),
                              _menuButton(
                                context: context,
                                label: 'Betul atau Salah?',
                                color: const Color(0xFF8E44AD),
                                destination: const BetulAtauSalahGameScreen(),
                                heroTag: 'hero-game-betul-salah',
                                icon: Icons.check_circle_rounded,
                              ),
                              const SizedBox(height: 16),
                              OutlinedButton.icon(
                                onPressed: () => goToMainMenu(context),
                                icon: const Icon(Icons.home_rounded),
                                label: const Text('Kembali ke Menu Utama'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.background,
                                  side: const BorderSide(color: Colors.white70),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 12,
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
}
