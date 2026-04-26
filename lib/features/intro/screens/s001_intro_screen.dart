import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/animations/animations.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/theme/app_design_tokens.dart';
import '../../../core/widgets/animated_kid_button.dart';
import '../../../core/widgets/lesson_card.dart';
import '../../../shared/progress/progress_tracker.dart';
import '../../../shared/widgets/adaptive_asset_image.dart';

class S001IntroScreen extends StatefulWidget {
  const S001IntroScreen({super.key});

  @override
  State<S001IntroScreen> createState() => _S001IntroScreenState();
}

class _S001IntroScreenState extends State<S001IntroScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bubbleController;
  late final Animation<double> _bubbleOpacity;
  late final Animation<Offset> _bubbleOffset;

  @override
  void initState() {
    super.initState();
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    )..forward();
    _bubbleOpacity = CurvedAnimation(
      parent: _bubbleController,
      curve: Curves.easeOut,
    );
    _bubbleOffset =
        Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(
          CurvedAnimation(parent: _bubbleController, curve: Curves.easeOut),
        );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ProgressTracker.instance.updateOnboardingStep(
        reachedStep: 1,
        totalSteps: 3,
      );
    });
  }

  void _goNext() {
    if (!mounted) {
      return;
    }
    final tracker = ProgressTracker.instance;
    final hasSession =
        tracker.userName.trim().isNotEmpty && tracker.userId.trim().isNotEmpty;
    context.go(hasSession ? AppRoutes.s003MainMenu : AppRoutes.s002Welcome);
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AdaptiveAssetImage(
              assetPath: 'assets/Belajar/AmiN di dalam kelas.svg',
              fit: BoxFit.cover,
            ),
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x22000000), Color(0x44000000)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final compactHeight = constraints.maxHeight < 620;
                      final characterSize = compactHeight
                          ? (constraints.maxHeight * 0.42).clamp(240.0, 320.0)
                          : 360.0;
                      final titleSize = compactHeight ? 22.0 : 26.0;
                      final subtitleSize = compactHeight ? 18.0 : 21.0;

                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AminCharacter(
                                width: characterSize,
                                height: characterSize,
                                pose: AminPose.schoolUniform,
                                motions: const <AminMotion>{
                                  AminMotion.idleBreathing,
                                  AminMotion.blink,
                                  AminMotion.handWave,
                                  AminMotion.smile,
                                },
                                backend: AminCharacterBackend.auto,
                                placeholderAsset:
                                    'assets/Action Figures/AmiN First Screen.svg',
                              ),
                              SizedBox(height: compactHeight ? 10 : 14),
                              FadeTransition(
                                opacity: _bubbleOpacity,
                                child: SlideTransition(
                                  position: _bubbleOffset,
                                  child: LessonCard(
                                    child: Column(
                                      children: [
                                        Text(
                                          'Hai, saya AmiN! 😊',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: titleSize,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Jom belajar imbuhan bersama-sama!',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: subtitleSize,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: compactHeight ? 12 : 16),
                              AnimatedKidButton(
                                label: 'Jom Mula',
                                icon: Icons.play_arrow_rounded,
                                onPressed: _goNext,
                                backgroundColor: const Color(0xFFFFC300),
                                foregroundColor: const Color(0xFF1D3557),
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
        ],
      ),
    );
  }
}
