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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: constraints.maxWidth,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                            width: 300,
                            height: 300,
                            pose: AminPose.redTshirt,
                            motions: <AminMotion>{
                              AminMotion.idleBreathing,
                              AminMotion.blink,
                              AminMotion.pointDown,
                            },
                            backend: AminCharacterBackend.auto,
                            placeholderAsset:
                                'assets/Action Figures/AmiN pointing both fingers down.svg',
                          ),
                          const SizedBox(height: 8),
                          LessonCard(
                            child: const Text(
                              'Pilih aktiviti anda',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          LessonCard(
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.badge_rounded,
                                  color: Color(0xFF1D3557),
                                  size: 26,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Profil Murid',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _displayName,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _menuButton(
                                  title: 'Kenali imbuhan',
                                  subtitle: 'Belajar',
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
                                  title: 'Permainan perkataan',
                                  subtitle: 'Main',
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
                  );
                },
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
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 122),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 34),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 17,
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
