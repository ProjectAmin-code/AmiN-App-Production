import 'package:flutter/material.dart';

import '../../shared/design/app_design_tokens.dart';
import '../../shared/gamification/gamification.dart';
import '../../shared/motion/app_motion_navigation.dart';
import '../models/quiz_level.dart';
import 'quiz_shell_screen.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({
    super.key,
    required this.name,
    required this.level,
    required this.totalQuestions,
    required this.autoGradedQuestions,
    required this.correctAnswers,
    required this.manualCompleted,
  });

  final String name;
  final QuizLevel? level;
  final int totalQuestions;
  final int autoGradedQuestions;
  final int correctAnswers;
  final int manualCompleted;

  int get _autoPercent {
    if (autoGradedQuestions == 0) {
      return 0;
    }
    return ((correctAnswers / autoGradedQuestions) * 100).round();
  }

  QuizLevel? get _nextLevel {
    switch (level) {
      case QuizLevel.easy:
        return QuizLevel.medium;
      case QuizLevel.medium:
        return QuizLevel.hard;
      case QuizLevel.hard:
      case null:
        return null;
    }
  }

  String _nextLevelLabel(QuizLevel next) {
    switch (next) {
      case QuizLevel.easy:
        return 'Tahap Mudah';
      case QuizLevel.medium:
        return 'Tahap Sederhana';
      case QuizLevel.hard:
        return 'Tahap Tinggi';
    }
  }

  @override
  Widget build(BuildContext context) {
    final nextLevel = _nextLevel;
    final gamification = GamificationScope.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Keputusan Kuiz',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ConfettiCelebration(
              active: true,
              child: LessonCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const MascotWidget(
                          assetPath: 'assets/aminPage3.png',
                          width: 62,
                          height: 62,
                          state: MascotState.celebrate,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Tahniah, $name!',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text('Jumlah soalan: $totalQuestions'),
                    Text('Soalan auto-markah: $autoGradedQuestions'),
                    Text('Jawapan betul (auto): $correctAnswers'),
                    Text('Skor auto: $_autoPercent%'),
                    Text('Soalan manual ditanda siap: $manualCompleted'),
                    const SizedBox(height: 10),
                    StarProgressBar(value: _autoPercent / 100),
                    const SizedBox(height: 8),
                    const XPAnimation(amount: 20),
                  ],
                ),
              ),
            ),
            const Spacer(),
            if (nextLevel != null)
              AnimatedKidButton(
                label: _nextLevelLabel(nextLevel),
                icon: Icons.arrow_upward_rounded,
                onPressed: () {
                  gamification.unlockLevel(label: _nextLevelLabel(nextLevel));
                  pushReplacementAdaptive(
                    context,
                    QuizShellScreen(name: name, level: nextLevel),
                  );
                },
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.textPrimary,
              ),
            if (nextLevel != null) const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text('Menu Utama'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
