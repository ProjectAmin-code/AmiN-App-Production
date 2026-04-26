import 'package:flutter/material.dart';

enum BelajarCharacterPosition { left, center, right }

class BelajarCharacterConfig {
  const BelajarCharacterConfig({
    required this.assetPath,
    this.visible = true,
    this.position = BelajarCharacterPosition.center,
    this.fit = BoxFit.contain,
    this.height,
  });

  const BelajarCharacterConfig.hidden()
    : assetPath = '',
      visible = false,
      position = BelajarCharacterPosition.center,
      fit = BoxFit.contain,
      height = null;

  final String assetPath;
  final bool visible;
  final BelajarCharacterPosition position;
  final BoxFit fit;
  final double? height;
}
