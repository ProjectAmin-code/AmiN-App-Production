import 'package:flutter/animation.dart';

import '../constants/belajar_tokens.dart';
import '../models/belajar_animation_type.dart';

class BelajarAnimationPreset {
  const BelajarAnimationPreset({
    required this.duration,
    required this.curve,
    this.offset = Offset.zero,
    this.startScale = 0.92,
  });

  final Duration duration;
  final Curve curve;
  final Offset offset;
  final double startScale;
}

class BelajarAnimationPresets {
  const BelajarAnimationPresets._();

  static const BelajarAnimationPreset none = BelajarAnimationPreset(
    duration: Duration.zero,
    curve: Curves.linear,
    startScale: 1,
  );

  static const BelajarAnimationPreset fade = BelajarAnimationPreset(
    duration: BelajarTokens.fadeDuration,
    curve: Curves.easeOutCubic,
  );

  static const BelajarAnimationPreset slide = BelajarAnimationPreset(
    duration: BelajarTokens.slideDuration,
    curve: Curves.easeOutCubic,
    offset: Offset(0, 16),
  );

  static const BelajarAnimationPreset scale = BelajarAnimationPreset(
    duration: BelajarTokens.scaleDuration,
    curve: Curves.easeOutBack,
    startScale: 0.92,
  );

  static BelajarAnimationPreset of(BelajarAnimationType type) {
    switch (type) {
      case BelajarAnimationType.none:
        return none;
      case BelajarAnimationType.fadeIn:
      case BelajarAnimationType.mascotIdle:
        return fade;
      case BelajarAnimationType.slideUp:
        return slide;
      case BelajarAnimationType.scaleIn:
        return scale;
    }
  }
}
