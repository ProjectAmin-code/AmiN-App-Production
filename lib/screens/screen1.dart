import 'package:flutter/material.dart';

import '../shared/design/app_design_tokens.dart';
import '../shared/gamification/gamification.dart';
import '../shared/motion/app_motion_navigation.dart';
import '../shared/progress/progress_tracker.dart';
import '../shared/widgets/adaptive_asset_image.dart';
import '../shared/widgets/lesson_bottom_decoration_zone.dart';
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
            child: AdaptiveAssetImage(
              assetPath: 'assets/Belajar/AmiN di dalam kelas.svg',
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
                final scale = (constraints.maxHeight / 760)
                    .clamp(0.8, 1.0)
                    .toDouble();
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
                          SizedBox(height: 12 * scale),
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, bodyConstraints) {
                                return SingleChildScrollView(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: bodyConstraints.maxHeight,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        _speechBubble(
                                          'Hi semua! Saya AmiN.',
                                          fontSize: 22 * scale,
                                        ),
                                        SizedBox(height: 14 * scale),
                                        _speechBubble(
                                          'Selamat datang ke Kelas Imbuhan Awalan meN-.',
                                          fontSize: 22 * scale,
                                        ),
                                        SizedBox(height: 12 * scale),
                                        // Reserve a stable decoration zone so the
                                        // character never pushes into the CTA area.
                                        LessonBottomDecorationZone(
                                          viewportHeight: constraints.maxHeight,
                                          viewportWidth: constraints.maxWidth,
                                          preferredSize: 240 * scale,
                                          preferredReservedHeight: 170 * scale,
                                          decorationBuilder: (size) => MascotWidget(
                                            assetPath:
                                                'assets/Action Figures/AmiN First Screen.svg',
                                            width: size,
                                            height: size,
                                            state: MascotState.idle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 10 * scale),
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

  Widget _speechBubble(String text, {required double fontSize}) {
    return LessonCard(
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
      ),
    );
  }
}
