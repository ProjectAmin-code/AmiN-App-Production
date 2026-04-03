import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/animations/animations.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/theme/app_design_tokens.dart';
import '../../../core/widgets/lesson_card.dart';
import '../../../shared/progress/progress_tracker.dart';

class S003MainMenuScreen extends StatefulWidget {
  const S003MainMenuScreen({super.key});

  @override
  State<S003MainMenuScreen> createState() => _S003MainMenuScreenState();
}

class _S003MainMenuScreenState extends State<S003MainMenuScreen> {
  String _userName = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ProgressTracker.instance.updateOnboardingStep(
        reachedStep: 3,
        totalSteps: 3,
      );
      final persistedName = ProgressTracker.instance.userName.trim();
      if (mounted) {
        setState(() {
          _userName = persistedName.isEmpty ? 'Pelajar' : persistedName;
        });
      }
    });
  }

  String get _displayName => _userName.trim().isEmpty ? 'Pelajar' : _userName;

  void _openFlow(String route) {
    context.push(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () => context.push(AppRoutes.settings),
                      icon: const Icon(Icons.settings_rounded),
                      tooltip: 'Tetapan',
                    ),
                  ),
                  const AminCharacter(
                    width: 190,
                    height: 190,
                    pose: AminPose.redTshirt,
                    motions: <AminMotion>{
                      AminMotion.idleBreathing,
                      AminMotion.blink,
                      AminMotion.pointDown,
                    },
                    backend: AminCharacterBackend.auto,
                    placeholderAsset: 'assets/aminPage3.png',
                  ),
                  const SizedBox(height: 8),
                  LessonCard(
                    child: Text(
                      'Pilih aktiviti anda, $_displayName',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _menuButton(
                          title: 'Belajar',
                          subtitle: 'Asas imbuhan',
                          color: const Color(0xFF3B82F6),
                          icon: Icons.menu_book_rounded,
                          onTap: () => _openFlow(AppRoutes.belajar),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _menuButton(
                          title: 'Kuiz',
                          subtitle: 'Uji kefahaman',
                          color: AppColors.secondary,
                          icon: Icons.quiz_rounded,
                          onTap: () => _openFlow(AppRoutes.kuiz),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _menuButton(
                          title: 'Main',
                          subtitle: 'Permainan kata',
                          color: const Color(0xFFFF7F22),
                          icon: Icons.sports_esports_rounded,
                          onTap: () => _openFlow(AppRoutes.mainGame),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _menuButton(
                          title: 'Kemajuan',
                          subtitle: 'Lihat prestasi',
                          color: const Color(0xFF2EAD63),
                          icon: Icons.insights_rounded,
                          onTap: () => _openFlow(AppRoutes.kemajuan),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuButton({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return LessonCard(
      onTap: onTap,
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
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
            const SizedBox(height: 4),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
