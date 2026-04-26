import 'dart:ui';

import 'package:flutter/material.dart';

import '../shared/design/app_design_tokens.dart';
import '../shared/gamification/gamification.dart';
import '../shared/motion/app_motion_navigation.dart';
import '../shared/progress/progress_tracker.dart';
import 'screen1.dart'; // Import Screen1

class Screen0 extends StatefulWidget {
  const Screen0({super.key});

  @override
  State<Screen0> createState() => _Screen0State();
}

class _Screen0State extends State<Screen0> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ProgressTracker.instance.updateOnboardingStep(
        reachedStep: 1,
        totalSteps: 3,
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _goToScreen1() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      ProgressTracker.instance.setUserName(name);
      ProgressTracker.instance.updateOnboardingStep(
        reachedStep: 1,
        totalSteps: 3,
      );
      final gamification = GamificationScope.of(context);
      gamification.awardXp(5, reason: 'Langkah pertama');
      gamification.updateStreak(success: true);
      pushAdaptive(context, Screen1(name: name));
      return;
    }
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Please enter your name')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scale = (constraints.maxHeight / 780)
                .clamp(0.78, 1.0)
                .toDouble();
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 560,
                    maxHeight: constraints.maxHeight - 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const StarProgressBar(
                        value: 1 / 3,
                        starCount: 3,
                        showLabel: false,
                      ),
                      SizedBox(height: 14 * scale),
                      SizedBox(
                        height: 280 * scale,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: 0,
                              top: 18 * scale,
                              child: MascotWidget(
                                assetPath:
                                    'assets/Action Figures/AmiN First Screen.svg',
                                width: 220 * scale,
                                height: 220 * scale,
                                state: MascotState.encourage,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 82 * scale,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 260 * scale,
                                ),
                                child: LessonCard(
                                  child: Text(
                                    'Hai! Siapa nama awak?',
                                    style: TextStyle(
                                      fontSize: 18 * scale,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12 * scale),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    spreadRadius: 3,
                                    blurRadius: 7,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      20,
                                      20 * scale,
                                      20,
                                      12 * scale,
                                    ),
                                    child: TextField(
                                      controller: _nameController,
                                      textInputAction: TextInputAction.done,
                                      onSubmitted: (_) => _goToScreen1(),
                                      decoration: InputDecoration(
                                        hintText: 'Taip nama awak di sini',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      style: TextStyle(fontSize: 18 * scale),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: AnimatedKidButton(
                                      label: 'Mula',
                                      onPressed: _goToScreen1,
                                      backgroundColor: AppColors.secondary,
                                      foregroundColor: AppColors.textPrimary,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10 * scale,
                                    ),
                                    child: Text(
                                      'Guna nama panggilan sahaja',
                                      style: TextStyle(fontSize: 14 * scale),
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
