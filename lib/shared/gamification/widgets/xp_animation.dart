import 'package:flutter/material.dart';

import '../../design/app_design_tokens.dart';
import '../../motion/app_motion_spec.dart';

class XPAnimation extends StatelessWidget {
  const XPAnimation({
    super.key,
    required this.amount,
    this.label = 'Mata',
  });

  final int amount;
  final String label;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = AppMotionSpec.reduceMotion(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppMotionSpec.chooseDuration(
        context,
        const Duration(milliseconds: 900),
        const Duration(milliseconds: 220),
      ),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final dy = reduceMotion ? 0.0 : -18 * value;
        final opacity = reduceMotion ? 1.0 : (1 - (value * 0.2));
        return Opacity(
          opacity: opacity,
          child: Transform.translate(offset: Offset(0, dy), child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppRadii.pill),
          boxShadow: AppShadows.soft,
        ),
        child: Text(
          '+$amount${label.trim().isEmpty ? '' : ' $label'}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
