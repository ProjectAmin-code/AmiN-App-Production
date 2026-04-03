import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/intro/screens/s001_intro_screen.dart';
import '../../features/intro/screens/s002_welcome_screen.dart';
import '../../features/intro/screens/s003_main_menu_screen.dart';
import '../../features/intro/screens/settings_screen.dart';
import '../../games/screens/game_menu_screen.dart';
import '../../learning/screens/belajar_flow_screen.dart';
import '../../quiz/screens/quiz_level_gateway_screen.dart';
import '../../screens/progress_screen.dart';
import '../../shared/motion/app_motion_spec.dart';
import '../../shared/progress/progress_tracker.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.s001Intro,
    routes: [
      GoRoute(
        path: AppRoutes.s001Intro,
        builder: (context, state) => const S001IntroScreen(),
      ),
      GoRoute(
        path: AppRoutes.s002Welcome,
        builder: (context, state) => const S002WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.s003MainMenu,
        builder: (context, state) => const S003MainMenuScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        pageBuilder: (context, state) {
          return _animatedPage(
            context: context,
            state: state,
            child: const SettingsScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.belajar,
        pageBuilder: (context, state) {
          return _animatedPage(
            context: context,
            state: state,
            child: BelajarFlowScreen(name: _resolvedUserName),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.kuiz,
        pageBuilder: (context, state) {
          return _animatedPage(
            context: context,
            state: state,
            child: QuizLevelGatewayScreen(name: _resolvedUserName),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.mainGame,
        pageBuilder: (context, state) {
          return _animatedPage(
            context: context,
            state: state,
            child: const GameMenuScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.kemajuan,
        pageBuilder: (context, state) {
          return _animatedPage(
            context: context,
            state: state,
            child: ProgressScreen(name: _resolvedUserName),
          );
        },
      ),
    ],
  );
});

CustomTransitionPage<void> _animatedPage({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  final reduceMotion = AppMotionSpec.reduceMotion(context);
  final duration = AppMotionSpec.chooseDuration(
    context,
    const Duration(milliseconds: 260),
    const Duration(milliseconds: 180),
  );

  return CustomTransitionPage<void>(
    key: state.pageKey,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (reduceMotion) {
        return FadeTransition(opacity: animation, child: child);
      }
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.02, 0.02),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

String get _resolvedUserName {
  final persisted = ProgressTracker.instance.userName.trim();
  if (persisted.isNotEmpty) {
    return persisted;
  }
  return 'Pelajar';
}
