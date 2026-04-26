import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../shared/motion/app_motion_spec.dart';
import '../constants/belajar_tokens.dart';
import '../models/lesson_theme_variant.dart';

class BelajarPrimaryButton extends StatefulWidget {
  const BelajarPrimaryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.palette,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final BelajarThemePalette palette;

  @override
  State<BelajarPrimaryButton> createState() => _BelajarPrimaryButtonState();
}

class _BelajarPrimaryButtonState extends State<BelajarPrimaryButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: BelajarTokens.mascotIdleDuration,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotionSpec.reduceMotion(context)) {
      _controller.stop();
      _controller.value = 0;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: BelajarTokens.buttonMaxWidth,
          ),
          child: SizedBox(
            width: double.infinity,
            height: BelajarTokens.buttonHeight,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final reduceMotion = AppMotionSpec.reduceMotion(context);
                if (reduceMotion) {
                  return child!;
                }
                final angle = math.sin(_controller.value * math.pi) * 0.01;
                return Transform.rotate(angle: angle, child: child);
              },
              child: ElevatedButton(
                onPressed: widget.onPressed,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: widget.palette.buttonBackground,
                  foregroundColor: widget.palette.buttonForeground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(BelajarTokens.radiusSm),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontFamily: BelajarTokens.fontFamily,
                        fontFamilyFallback: BelajarTokens.fontFallback,
                        fontWeight: BelajarTokens.buttonWeight,
                        fontSize: BelajarTokens.buttonFontSize,
                      ),
                    ),
                    const SizedBox(width: BelajarTokens.gapXs),
                    Icon(widget.icon, size: 22),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
