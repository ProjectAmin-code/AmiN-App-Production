import 'package:flutter/material.dart';

import '../shared/design/app_design_tokens.dart';
import '../shared/gamification/gamification.dart';
import '../shared/motion/app_motion_navigation.dart';
import '../shared/progress/progress_tracker.dart';
import 'screen3.dart'; // Import Screen3

class Screen2 extends StatefulWidget {
  final String name;
  const Screen2({super.key, required this.name});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ProgressTracker.instance.updateOnboardingStep(
        reachedStep: 3,
        totalSteps: 3,
      );
    });
  }

  void _goNext() {
    final gamification = GamificationScope.of(context);
    gamification.awardXp(8, reason: 'Sedia untuk belajar');
    gamification.grantReward(
      title: 'Lencana Permulaan',
      message: 'Anda sudah bersedia memulakan latihan!',
    );
    pushAdaptive(context, Screen3(name: widget.name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
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
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Expanded(
                            child: StarProgressBar(
                              value: 1,
                              showLabel: false,
                              foregroundColor: AppColors.secondary,
                              backgroundColor: Color(0x55FFFFFF),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.volume_up,
                            color: AppColors.textPrimary,
                            size: 28,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const LessonCard(
                                child: Text(
                                  'Saya akan bantu awak belajar imbuhan awalan meN- dengan cara yang seronok dan mudah!',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const MascotWidget(
                                assetPath: 'assets/aminPage2.png',
                                width: 260,
                                height: 260,
                                state: MascotState.encourage,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: AnimatedKidButton(
                          label: 'Jom kita mula',
                          icon: Icons.play_arrow_rounded,
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
    );
  }
}
