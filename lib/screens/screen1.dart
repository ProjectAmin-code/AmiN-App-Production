import 'package:flutter/material.dart';

import '../shared/design/app_design_tokens.dart';
import '../shared/gamification/gamification.dart';
import '../shared/motion/app_motion_navigation.dart';
import '../shared/progress/progress_tracker.dart';
import 'screen2.dart'; // Import Screen2

class Screen1 extends StatefulWidget {
  final String name;
  const Screen1({super.key, required this.name});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ProgressTracker.instance.updateOnboardingStep(
        reachedStep: 2,
        totalSteps: 3,
      );
    });
  }

  void _goNext() {
    final gamification = GamificationScope.of(context);
    gamification.awardXp(5, reason: 'Skrin pengenalan');
    pushAdaptive(context, Screen2(name: widget.name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/classroom_background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox.expand(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x55000000), Color(0x77000000)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.white,
                                ),
                              ),
                              const Expanded(
                                child: StarProgressBar(
                                  value: 2 / 3,
                                  showLabel: false,
                                  foregroundColor: AppColors.secondary,
                                  backgroundColor: Color(0x55FFFFFF),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  _speechBubble('Hi semua! Saya AmiN.'),
                                  const SizedBox(height: 14),
                                  _speechBubble(
                                    'Selamat datang ke Kelas Imbuhan Awalan meN-.',
                                  ),
                                  const SizedBox(height: 18),
                                  const MascotWidget(
                                    assetPath: 'assets/aminPage1.png',
                                    width: 240,
                                    height: 240,
                                    state: MascotState.idle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: AnimatedKidButton(
                              heroTag: 'hero-onboarding-next',
                              icon: Icons.arrow_forward_rounded,
                              label: 'Teruskan',
                              onPressed: _goNext,
                              backgroundColor: AppColors.secondary,
                              foregroundColor: AppColors.textPrimary,
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
        ],
      ),
    );
  }

  Widget _speechBubble(String text) {
    return LessonCard(
      child: Text(
        text,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}
