import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/animations/animations.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/theme/app_design_tokens.dart';
import '../../../core/widgets/lesson_card.dart';
import '../../../shared/progress/progress_tracker.dart';

class S001IntroScreen extends StatefulWidget {
  const S001IntroScreen({super.key});

  @override
  State<S001IntroScreen> createState() => _S001IntroScreenState();
}

class _S001IntroScreenState extends State<S001IntroScreen>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
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
    _timer = Timer(const Duration(milliseconds: 2500), _goNext);
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
    _timer?.cancel();
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/classroom_background.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFBFE6FF), Color(0xFFEAF6FF)],
                    ),
                  ),
                );
              },
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AminCharacter(
                        width: 260,
                        height: 260,
                        pose: AminPose.schoolUniform,
                        motions: <AminMotion>{
                          AminMotion.idleBreathing,
                          AminMotion.blink,
                          AminMotion.handWave,
                          AminMotion.smile,
                        },
                        backend: AminCharacterBackend.auto,
                        placeholderAsset: 'assets/aminPage1.png',
                      ),
                      const SizedBox(height: 14),
                      FadeTransition(
                        opacity: _bubbleOpacity,
                        child: SlideTransition(
                          position: _bubbleOffset,
                          child: const LessonCard(
                            child: Text(
                              'Hai! Saya AmiN. Jom belajar bersama!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
