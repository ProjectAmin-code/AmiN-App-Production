import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../shared/design/app_design_tokens.dart';
import '../../shared/motion/app_motion_spec.dart';
import '../../shared/widgets/adaptive_asset_image.dart';

enum AminMotion {
  idleBreathing,
  handWave,
  pointDown,
  raiseHand,
  lightBounce,
  blink,
  smile,
}

enum AminPose { schoolUniform, redTshirt }

enum AminCharacterBackend { auto, nativePlaceholder, lottie, rive }

class AminCharacter extends StatefulWidget {
  const AminCharacter({
    super.key,
    this.width = 220,
    this.height = 220,
    this.motions = const <AminMotion>{
      AminMotion.idleBreathing,
      AminMotion.blink,
    },
    this.pose = AminPose.schoolUniform,
    this.backend = AminCharacterBackend.auto,
    this.lottieAsset,
    this.riveAsset,
    this.placeholderAsset,
    this.fit = BoxFit.contain,
  });

  final double width;
  final double height;
  final Set<AminMotion> motions;
  final AminPose pose;
  final AminCharacterBackend backend;
  final String? lottieAsset;
  final String? riveAsset;
  final String? placeholderAsset;
  final BoxFit fit;

  static String defaultAssetForPose(AminPose pose) {
    switch (pose) {
      case AminPose.schoolUniform:
        return 'assets/Action Figures/AmiN Pointing.svg';
      case AminPose.redTshirt:
        return 'assets/Icon/AmiN for APP Pic.min.svg';
    }
  }

  @override
  State<AminCharacter> createState() => _AminCharacterState();
}

class _AminCharacterState extends State<AminCharacter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotionSpec.reduceMotion(context)) {
      _controller.stop();
      _controller.value = 0;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = AppMotionSpec.reduceMotion(context);
    final assetPath =
        widget.placeholderAsset ??
        AminCharacter.defaultAssetForPose(widget.pose);
    final useSeparatedParts = assetPath.endsWith(
      'anim_char_without_eyehands.png',
    );

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final animationValue = reduceMotion ? 0.0 : _controller.value;
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _assetImage(assetPath),
                if (useSeparatedParts)
                  _AminStaticPartsOverlay(
                    enableBlink: widget.motions.contains(AminMotion.blink),
                    enableHandWave: widget.motions.contains(
                      AminMotion.handWave,
                    ),
                    animationValue: animationValue,
                    reduceMotion: reduceMotion,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _assetImage(String assetPath) {
    return AdaptiveAssetImage(
      assetPath: assetPath,
      fit: widget.fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(AppRadii.lg),
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.face_6_rounded,
            size: 72,
            color: AppColors.textPrimary,
          ),
        );
      },
    );
  }
}

class _AminStaticPartsOverlay extends StatelessWidget {
  const _AminStaticPartsOverlay({
    required this.enableBlink,
    required this.enableHandWave,
    required this.animationValue,
    required this.reduceMotion,
  });

  static const _sourceSize = Size(720, 1280);
  static const _openEyesAsset =
      'assets/Action Figures/amin_parts/amin_eyes_open_pair.png';
  static const _handWaveAsset =
      'assets/Action Figures/amin_parts/amin_hand_wave.png';
  static const _eyesRect = Rect.fromLTWH(300, 185, 130, 60);
  static const _handRect = Rect.fromLTWH(58, 250, 200, 250);

  final bool enableBlink;
  final bool enableHandWave;
  final double animationValue;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    if (!enableBlink && !enableHandWave) {
      return const SizedBox.shrink();
    }

    final theta = animationValue * math.pi * 2;
    final blinkPhase = (animationValue * 3.4) % 1.0;
    final isBlinking = enableBlink && blinkPhase > 0.90;
    final eyeScaleY = isBlinking ? 0.08 : 1.0;
    final handRotation = enableHandWave && !reduceMotion
        ? math.sin(theta * 1.85) * 0.16
        : 0.0;

    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final contentRect = _containRect(
            Size(constraints.maxWidth, constraints.maxHeight),
          );

          return Stack(
            clipBehavior: Clip.none,
            children: [
              if (enableBlink)
                _positionedInSource(
                  contentRect: contentRect,
                  sourceRect: _eyesRect,
                  child: Transform.scale(
                    scaleY: eyeScaleY,
                    child: Image.asset(_openEyesAsset, fit: BoxFit.contain),
                  ),
                ),
              if (enableHandWave)
                _positionedInSource(
                  contentRect: contentRect,
                  sourceRect: _handRect,
                  child: Transform.rotate(
                    angle: handRotation,
                    alignment: const Alignment(0.55, 0.78),
                    child: Image.asset(_handWaveAsset, fit: BoxFit.contain),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Rect _containRect(Size boxSize) {
    final sourceAspect = _sourceSize.width / _sourceSize.height;
    final boxAspect = boxSize.width / boxSize.height;

    if (boxAspect > sourceAspect) {
      final height = boxSize.height;
      final width = height * sourceAspect;
      return Rect.fromLTWH((boxSize.width - width) / 2, 0, width, height);
    }

    final width = boxSize.width;
    final height = width / sourceAspect;
    return Rect.fromLTWH(0, (boxSize.height - height) / 2, width, height);
  }

  Widget _positionedInSource({
    required Rect contentRect,
    required Rect sourceRect,
    required Widget child,
  }) {
    final scaleX = contentRect.width / _sourceSize.width;
    final scaleY = contentRect.height / _sourceSize.height;

    return Positioned(
      left: contentRect.left + sourceRect.left * scaleX,
      top: contentRect.top + sourceRect.top * scaleY,
      width: sourceRect.width * scaleX,
      height: sourceRect.height * scaleY,
      child: child,
    );
  }
}
