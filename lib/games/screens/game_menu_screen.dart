import 'package:flutter/material.dart';

import '../../shared/design/app_design_tokens.dart';
import '../../shared/gamification/gamification.dart';
import '../../shared/motion/app_motion_navigation.dart';
import '../../shared/motion/app_motion_widgets.dart';
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
  }) {
    return Hero(
      tag: heroTag,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: SizedBox(
          width: 280,
          height: 58,
          child: BounceTapCard(
            onTap: () => pushAdaptive(context, destination),
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: color,
                disabledForegroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 24,
                  height: 1,
                  fontWeight: FontWeight.w900,
                ),
              ),
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
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [Color(0xFF2F90F5), Color(0xFF0C54C9)],
          ),
        ),
        child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StreakWidget(streak: gamification.streak, compact: true),
                      const SizedBox(width: 8),
                      Text(
                        'XP ${gamification.totalXp}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const MascotWidget(
                    assetPath: 'assets/aminPage3.png',
                    width: 110,
                    height: 110,
                    state: MascotState.encourage,
                  ),
                  const Text(
                    'Main',
                    style: TextStyle(
                    color: Color(0xFFFFE04A),
                    fontSize: 52,
                    height: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 24),
                _menuButton(
                  context: context,
                  label: 'Pilih Pantas',
                  color: const Color(0xFFFF7F22),
                  destination: const PilihPantasGameScreen(),
                  heroTag: 'hero-game-pilih-pantas',
                ),
                _menuButton(
                  context: context,
                  label: 'Cari & Kumpul',
                  color: const Color(0xFFFFC233),
                  destination: const CariKumpulGameScreen(),
                  heroTag: 'hero-game-cari-kumpul',
                ),
                _menuButton(
                  context: context,
                  label: 'Cari & Bulatkan',
                  color: const Color(0xFF66C637),
                  destination: const CariBulatkanGameScreen(),
                  heroTag: 'hero-game-cari-bulatkan',
                ),
                const SizedBox(height: 18),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Kembali'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.background,
                    side: const BorderSide(color: Colors.white70),
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
