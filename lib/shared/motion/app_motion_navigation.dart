import 'package:flutter/material.dart';

import 'app_motion_spec.dart';

Route<T> buildAdaptivePageRoute<T>(
  BuildContext context,
  Widget page, {
  RouteSettings? settings,
  bool fullscreenDialog = false,
}) {
  final reduceMotion = AppMotionSpec.reduceMotion(context);
  final duration = AppMotionSpec.chooseDuration(
    context,
    AppMotionSpec.route,
    AppMotionSpec.routeReduced,
  );

  return PageRouteBuilder<T>(
    settings: settings,
    fullscreenDialog: fullscreenDialog,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    pageBuilder: (context, animation, secondaryAnimation) => page,
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
            begin: const Offset(0.02, 0.04),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

Future<T?> pushAdaptive<T>(BuildContext context, Widget page) {
  return Navigator.of(context).push<T>(buildAdaptivePageRoute(context, page));
}

Future<T?> pushReplacementAdaptive<T, TO>(BuildContext context, Widget page) {
  return Navigator.of(
    context,
  ).pushReplacement<T, TO>(buildAdaptivePageRoute(context, page));
}
