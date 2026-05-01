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
    required bool compact,
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
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 14 : 18,
              vertical: compact ? 14 : 18,
            ),
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
                Icon(icon, color: Colors.white, size: compact ? 24 : 28),
                SizedBox(width: compact ? 10 : 12),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: compact ? 22 : 28,
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
                  final compact =
                      constraints.maxWidth < 380 || constraints.maxHeight < 700;
                  final contentWidth = constraints.maxWidth > 540
                      ? 540.0
                      : constraints.maxWidth;
                  final mascotSize = (constraints.maxHeight * 0.26)
                      .clamp(140.0, compact ? 184.0 : 230.0)
                      .toDouble();
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: 16 + MediaQuery.paddingOf(context).bottom,
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: contentWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: compact ? 8 : 18),
                            MascotWidget(
                              assetPath:
                                  'assets/Action Figures/AmiN Pointing.svg',
                              width: mascotSize,
                              height: mascotSize,
                              state: MascotState.encourage,
                            ),
                            const SizedBox(height: 0),
                            Text(
                              'Jom Main!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFFFF176),
                                fontSize: compact ? 42 : 56,
                                fontWeight: FontWeight.w900,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Pilih permainan untuk menguji kefahaman anda.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: compact ? 17 : 22,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: compact ? 16 : 24),
                            _menuButton(
                              context: context,
                              label: 'Pilih Pantas',
                              color: const Color(0xFFFF8A34),
                              destination: const PilihPantasGameScreen(),
                              heroTag: 'hero-game-pilih-pantas',
                              icon: Icons.flash_on_rounded,
                              compact: compact,
                            ),
                            _menuButton(
                              context: context,
                              label: 'Pilih & Kumpul',
                              color: const Color(0xFF2EAD63),
                              destination: const CariKumpulGameScreen(),
                              heroTag: 'hero-game-pilih-kumpul',
                              icon: Icons.touch_app_rounded,
                              compact: compact,
                            ),
                            _menuButton(
                              context: context,
                              label: 'Cari & Pilih',
                              color: const Color(0xFF5A67D8),
                              destination: const CariBulatkanGameScreen(),
                              heroTag: 'hero-game-cari-pilih',
                              icon: Icons.grid_on_rounded,
                              compact: compact,
                            ),
                            _menuButton(
                              context: context,
                              label: 'Betul atau Salah?',
                              color: const Color(0xFF8E44AD),
                              destination: const BetulAtauSalahGameScreen(),
                              heroTag: 'hero-game-betul-salah',
                              icon: Icons.check_circle_rounded,
                              compact: compact,
                            ),
                            SizedBox(height: compact ? 8 : 16),
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
