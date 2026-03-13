import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../design/app_design_tokens.dart';
import '../../motion/app_motion_spec.dart';

class StarProgressBar extends StatefulWidget {
  const StarProgressBar({
    super.key,
    required this.value,
    this.starCount = 3,
    this.height = 12,
    this.showLabel = true,
    this.backgroundColor = const Color(0xFFE6EEF8),
    this.foregroundColor = AppColors.primary,
  });

  final double value;
  final int starCount;
  final double height;
  final bool showLabel;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  State<StarProgressBar> createState() => _StarProgressBarState();
}

class _StarProgressBarState extends State<StarProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotionSpec.reduceMotion(context)) {
      _glowController.stop();
    } else if (!_glowController.isAnimating) {
      _glowController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clamped = widget.value.clamp(0.0, 1.0);
    final percent = (clamped * 100).round();
    final earnedStars = (clamped * widget.starCount).floor();

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: clamped),
      duration: AppMotionSpec.chooseDuration(
        context,
        const Duration(milliseconds: 450),
        const Duration(milliseconds: 220),
      ),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.pill),
              child: LinearProgressIndicator(
                value: animatedValue,
                minHeight: widget.height,
                backgroundColor: widget.backgroundColor,
                valueColor: AlwaysStoppedAnimation<Color>(widget.foregroundColor),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                ...List.generate(widget.starCount, (index) {
                  final active = index < earnedStars;
                  return AnimatedBuilder(
                    animation: _glowController,
                    builder: (context, _) {
                      final reduceMotion = AppMotionSpec.reduceMotion(context);
                      final glow = reduceMotion
                          ? 1.0
                          : 1 + (math.sin(_glowController.value * math.pi) * 0.12);
                      return Transform.scale(
                        scale: active ? glow : 1.0,
                        child: Icon(
                          active ? Icons.star_rounded : Icons.star_border_rounded,
                          size: 20,
                          color: active
                              ? AppColors.secondary
                              : AppColors.textSecondary.withValues(alpha: 0.5),
                        ),
                      );
                    },
                  );
                }),
                const SizedBox(width: 8),
                if (widget.showLabel)
                  Text(
                    '$percent%',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
