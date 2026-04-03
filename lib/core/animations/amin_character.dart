import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart' as rive;

import '../../shared/design/app_design_tokens.dart';
import '../../shared/motion/app_motion_spec.dart';

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
        return 'assets/aminPage1.png';
      case AminPose.redTshirt:
        return 'assets/aminPage3.png';
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
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final animationValue = reduceMotion ? 0.0 : _controller.value;
          final motion = _resolveMotion(animationValue);
          return Transform.translate(
            offset: motion.offset,
            child: Transform.rotate(
              angle: motion.rotation,
              child: Transform.scale(
                scale: motion.scale,
                child: SizedBox(
                  width: widget.width,
                  height: widget.height,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildCharacterBody(reduceMotion: reduceMotion),
                      _FaceOverlay(
                        enableBlink: widget.motions.contains(AminMotion.blink),
                        showSmile: widget.motions.contains(AminMotion.smile),
                        animationValue: animationValue,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _ResolvedMotion _resolveMotion(double value) {
    final theta = value * math.pi * 2;
    var scale = 1.0;
    var offset = Offset.zero;
    var rotation = 0.0;

    if (widget.motions.contains(AminMotion.idleBreathing)) {
      scale += math.sin(theta) * 0.018;
    }
    if (widget.motions.contains(AminMotion.lightBounce)) {
      offset += Offset(0, -math.sin(theta).abs() * 5.0);
    }
    if (widget.motions.contains(AminMotion.handWave)) {
      rotation += math.sin(theta * 1.6) * 0.07;
    }
    if (widget.motions.contains(AminMotion.pointDown)) {
      rotation += 0.03;
      offset += Offset(0, math.sin(theta * 1.2).abs() * 1.5);
    }
    if (widget.motions.contains(AminMotion.raiseHand)) {
      rotation -= 0.04;
      offset += Offset(0, -math.sin(theta * 1.1).abs() * 3.0);
    }
    return _ResolvedMotion(scale: scale, offset: offset, rotation: rotation);
  }

  Widget _buildCharacterBody({required bool reduceMotion}) {
    final placeholderAsset =
        widget.placeholderAsset ??
        AminCharacter.defaultAssetForPose(widget.pose);
    final backend = widget.backend;

    if (backend == AminCharacterBackend.rive ||
        (backend == AminCharacterBackend.auto && widget.riveAsset != null)) {
      final riveAsset = widget.riveAsset;
      if (riveAsset != null && riveAsset.isNotEmpty) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          child: rive.RiveAnimation.asset(
            riveAsset,
            fit: widget.fit,
            useArtboardSize: false,
            placeHolder: _placeholderImage(placeholderAsset),
          ),
        );
      }
    }

    if (backend == AminCharacterBackend.lottie ||
        (backend == AminCharacterBackend.auto && widget.lottieAsset != null)) {
      final lottieAsset = widget.lottieAsset;
      if (lottieAsset != null && lottieAsset.isNotEmpty) {
        return Lottie.asset(
          lottieAsset,
          fit: widget.fit,
          repeat: true,
          animate: !reduceMotion,
          errorBuilder: (context, error, stackTrace) =>
              _placeholderImage(placeholderAsset),
        );
      }
    }

    return _placeholderImage(placeholderAsset);
  }

  Widget _placeholderImage(String assetPath) {
    return Image.asset(
      assetPath,
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

class _ResolvedMotion {
  const _ResolvedMotion({
    required this.scale,
    required this.offset,
    required this.rotation,
  });

  final double scale;
  final Offset offset;
  final double rotation;
}

class _FaceOverlay extends StatelessWidget {
  const _FaceOverlay({
    required this.enableBlink,
    required this.showSmile,
    required this.animationValue,
  });

  final bool enableBlink;
  final bool showSmile;
  final double animationValue;

  @override
  Widget build(BuildContext context) {
    if (!enableBlink && !showSmile) {
      return const SizedBox.shrink();
    }

    final theta = animationValue * math.pi * 2;
    final blinkScale = !enableBlink || math.sin(theta * 2.4).abs() > 0.25
        ? 1.0
        : 0.25;

    return IgnorePointer(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _eye(blinkScale),
                const SizedBox(width: 18),
                _eye(blinkScale),
              ],
            ),
            if (showSmile) ...[
              const SizedBox(height: 22),
              Container(
                width: 28,
                height: 12,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.textPrimary,
                      width: 2.2,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _eye(double blinkScale) {
    return Transform.scale(
      scaleY: blinkScale,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: AppColors.textPrimary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
