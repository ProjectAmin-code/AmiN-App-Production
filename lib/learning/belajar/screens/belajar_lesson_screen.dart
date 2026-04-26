import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../shared/gamification/gamification.dart';
import '../../../shared/progress/progress_tracker.dart';
import '../controllers/belajar_lesson_controller.dart';
import '../models/lesson_theme_variant.dart';
import 'belajar_base_screen.dart';

class BelajarLessonScreen extends ConsumerStatefulWidget {
  const BelajarLessonScreen({
    super.key,
    required this.name,
    required this.lessonId,
  });

  final String name;
  final String lessonId;

  @override
  ConsumerState<BelajarLessonScreen> createState() =>
      _BelajarLessonScreenState();
}

class _BelajarLessonScreenState extends ConsumerState<BelajarLessonScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncProgress();
    });
  }

  @override
  void didUpdateWidget(covariant BelajarLessonScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lessonId != widget.lessonId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _syncProgress();
      });
    }
  }

  void _syncProgress() {
    final controller = ref.read(
      belajarLessonControllerProvider(widget.lessonId),
    );
    ProgressTracker.instance.updateBelajarStep(
      reachedStep: controller.currentStep,
      totalSteps: controller.totalLessons,
    );
  }

  void _handleBack() {
    final controller = ref.read(
      belajarLessonControllerProvider(widget.lessonId),
    );
    final previousLesson = controller.previousLesson;
    if (previousLesson == null) {
      context.go(AppRoutes.s003MainMenu);
      return;
    }
    context.go(AppRoutes.belajarLessonPath(previousLesson.id));
  }

  void _handleContinue() {
    final controller = ref.read(
      belajarLessonControllerProvider(widget.lessonId),
    );
    final lesson = controller.lesson;
    final isLastLesson = controller.currentStep >= controller.totalLessons;
    final defaultNextRoute = controller.nextLesson != null
        ? AppRoutes.belajarLessonPath(controller.nextLesson!.id)
        : AppRoutes.kuiz;
    final nextRoute = isLastLesson
        ? AppRoutes.kuiz
        : (lesson.nextRoute ?? defaultNextRoute);
    final gamification = GamificationScope.of(context);

    final willStayInBelajar = nextRoute.startsWith('/belajar');
    final nextReachedStep = willStayInBelajar
        ? math.min(controller.currentStep + 1, controller.totalLessons)
        : controller.totalLessons;
    ProgressTracker.instance.updateBelajarStep(
      reachedStep: nextReachedStep,
      totalSteps: controller.totalLessons,
    );
    gamification.awardXp(8, reason: 'Belajar ${lesson.id}');
    gamification.updateStreak(success: true);

    context.go(nextRoute);
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(
      belajarLessonControllerProvider(widget.lessonId),
    );
    final lesson = controller.lesson;
    final palette = BelajarThemeVariants.of(lesson.themeVariant);

    return BelajarBaseScreen(
      lesson: lesson,
      palette: palette,
      currentStep: controller.currentStep,
      totalSteps: controller.totalLessons,
      progressValue: controller.progress,
      onBack: _handleBack,
      onContinue: _handleContinue,
    );
  }
}
