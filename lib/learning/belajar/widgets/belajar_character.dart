import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../shared/motion/app_motion_widgets.dart';
import '../../../shared/widgets/adaptive_asset_image.dart';
import '../constants/belajar_tokens.dart';
import '../models/belajar_animation_type.dart';
import '../models/belajar_character_config.dart';

class BelajarCharacter extends StatelessWidget {
  const BelajarCharacter({
    super.key,
    required this.character,
    required this.animationType,
  });

  final BelajarCharacterConfig character;
  final BelajarAnimationType animationType;

  @override
  Widget build(BuildContext context) {
    if (!character.visible || character.assetPath.isEmpty) {
      return const SizedBox.shrink();
    }

    final screenSize = MediaQuery.sizeOf(context);
    final isCompactDevice =
        screenSize.width < BelajarTokens.compactWidthBreakpoint ||
        screenSize.height < BelajarTokens.compactHeightBreakpoint;
    final screenHeight = screenSize.height;
    final responsiveHeight = clampDouble(
      screenHeight * BelajarTokens.characterHeightFactor,
      BelajarTokens.characterMinHeight,
      BelajarTokens.characterMaxHeight,
    );
    final height = (character.height ?? responsiveHeight) *
        (isCompactDevice ? BelajarTokens.characterCompactScale : 1.0);

    Widget image = AdaptiveAssetImage(
      assetPath: character.assetPath,
      height: height,
      fit: character.fit,
    );

    if (animationType == BelajarAnimationType.mascotIdle) {
      image = const BreathingCharacter(child: SizedBox.shrink());
      image = BreathingCharacter(
        duration: BelajarTokens.mascotIdleDuration,
        child: AdaptiveAssetImage(
          assetPath: character.assetPath,
          height: height,
          fit: character.fit,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        top: isCompactDevice ? BelajarTokens.gapXs : BelajarTokens.gapSm,
      ),
      child: Align(alignment: _alignmentFor(character.position), child: image),
    );
  }

  Alignment _alignmentFor(BelajarCharacterPosition position) {
    switch (position) {
      case BelajarCharacterPosition.left:
        return Alignment.centerLeft;
      case BelajarCharacterPosition.center:
        return Alignment.center;
      case BelajarCharacterPosition.right:
        return Alignment.centerRight;
    }
  }
}
