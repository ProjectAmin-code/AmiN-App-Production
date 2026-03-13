import 'package:flutter/material.dart';

class AppMotionSpec {
  const AppMotionSpec._();

  static const Duration pulse = Duration(milliseconds: 1500);
  static const Duration breathing = Duration(milliseconds: 1800);
  static const Duration tapBounce = Duration(milliseconds: 320);
  static const Duration starBurst = Duration(milliseconds: 260);
  static const Duration celebration = Duration(milliseconds: 900);

  static const Duration route = Duration(milliseconds: 260);
  static const Duration routeReduced = Duration(milliseconds: 180);
  static const Duration switcher = Duration(milliseconds: 260);
  static const Duration switcherReduced = Duration(milliseconds: 180);
  static const Duration feedbackEnter = Duration(milliseconds: 240);
  static const Duration feedbackEnterReduced = Duration(milliseconds: 160);

  static bool reduceMotion(BuildContext context) {
    final mediaQuery = MediaQuery.maybeOf(context);
    if (mediaQuery != null) {
      return mediaQuery.disableAnimations;
    }
    return WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
  }

  static Duration chooseDuration(
    BuildContext context,
    Duration normal,
    Duration reduced,
  ) {
    return reduceMotion(context) ? reduced : normal;
  }
}
