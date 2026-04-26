import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/adaptive_asset_image.dart';
import 'app_motion_spec.dart';

abstract class AnimatedCharacterAdapter {
  const AnimatedCharacterAdapter();

  Widget buildCharacter({
    required BuildContext context,
    required String assetPath,
    required double width,
    required double height,
    BoxFit fit,
  });
}

class NativeAnimatedCharacterAdapter extends AnimatedCharacterAdapter {
  const NativeAnimatedCharacterAdapter();

  @override
  Widget buildCharacter({
    required BuildContext context,
    required String assetPath,
    required double width,
    required double height,
    BoxFit fit = BoxFit.contain,
  }) {
    return BreathingCharacter(
      child: AdaptiveAssetImage(
        assetPath: assetPath,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}

class BreathingCharacter extends StatefulWidget {
  const BreathingCharacter({
    super.key,
    required this.child,
    this.duration = AppMotionSpec.breathing,
    this.begin = 0.985,
    this.end = 1.02,
  });

  final Widget child;
  final Duration duration;
  final double begin;
  final double end;

  @override
  State<BreathingCharacter> createState() => _BreathingCharacterState();
}

class _BreathingCharacterState extends State<BreathingCharacter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scale = Tween<double>(
      begin: widget.begin,
      end: widget.end,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
    if (AppMotionSpec.reduceMotion(context)) {
      return RepaintBoundary(child: widget.child);
    }

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(scale: _scale.value, child: child);
        },
        child: widget.child,
      ),
    );
  }
}

class PulsingStars extends StatefulWidget {
  const PulsingStars({
    super.key,
    required this.count,
    this.size = 24,
    this.color = const Color(0xFFFFE066),
    this.spacing = 2,
    this.duration = AppMotionSpec.pulse,
  });

  final int count;
  final double size;
  final Color color;
  final double spacing;
  final Duration duration;

  @override
  State<PulsingStars> createState() => _PulsingStarsState();
}

class _PulsingStarsState extends State<PulsingStars>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
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
    final stars = List.generate(
      widget.count,
      (index) => Padding(
        padding: EdgeInsets.only(
          right: index == widget.count - 1 ? 0 : widget.spacing,
        ),
        child: Icon(Icons.star_rounded, color: widget.color, size: widget.size),
      ),
    );

    if (AppMotionSpec.reduceMotion(context)) {
      return Row(key: const Key('pulsing-stars-static'), children: stars);
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = 1 + (_controller.value * 0.08);
        return Transform.scale(scale: scale, child: child);
      },
      child: Row(children: stars),
    );
  }
}

class BounceTapCard extends StatefulWidget {
  const BounceTapCard({
    super.key,
    required this.child,
    required this.onTap,
    this.duration = AppMotionSpec.tapBounce,
  });

  final Widget child;
  final VoidCallback onTap;
  final Duration duration;

  @override
  State<BounceTapCard> createState() => _BounceTapCardState();
}

class _BounceTapCardState extends State<BounceTapCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scale = TweenSequence<double>(
      [
        TweenSequenceItem(tween: Tween(begin: 1, end: 0.96), weight: 45),
        TweenSequenceItem(tween: Tween(begin: 0.96, end: 1.02), weight: 35),
        TweenSequenceItem(tween: Tween(begin: 1.02, end: 1.0), weight: 20),
      ],
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (AppMotionSpec.reduceMotion(context)) {
      widget.onTap();
      return;
    }
    if (_controller.isAnimating) {
      return;
    }
    await _controller.forward(from: 0);
    if (mounted) {
      widget.onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final scale = AppMotionSpec.reduceMotion(context)
                ? 1.0
                : _scale.value;
            return Transform.scale(scale: scale, child: child);
          },
          child: widget.child,
        ),
      ),
    );
  }
}

class StarBurstOverlay extends StatefulWidget {
  const StarBurstOverlay({
    super.key,
    required this.child,
    required this.burstKey,
    this.alignment = Alignment.center,
    this.size = 64,
    this.color = const Color(0xFFF4B400),
    this.duration = AppMotionSpec.starBurst,
  });

  final Widget child;
  final int burstKey;
  final Alignment alignment;
  final double size;
  final Color color;
  final Duration duration;

  @override
  State<StarBurstOverlay> createState() => _StarBurstOverlayState();
}

class _StarBurstOverlayState extends State<StarBurstOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
  }

  @override
  void didUpdateWidget(covariant StarBurstOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.burstKey != oldWidget.burstKey) {
      if (AppMotionSpec.reduceMotion(context)) {
        return;
      }
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        IgnorePointer(
          child: Align(
            alignment: widget.alignment,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                if (AppMotionSpec.reduceMotion(context) ||
                    _controller.value <= 0 ||
                    _controller.value >= 1) {
                  return const SizedBox.shrink();
                }
                final curve = Curves.easeOut.transform(_controller.value);
                final scale = 0.4 + (curve * 1.0);
                final opacity = 1 - _controller.value;
                return Opacity(
                  opacity: opacity,
                  child: Transform.scale(scale: scale, child: child),
                );
              },
              child: Icon(
                Icons.star_rounded,
                key: const Key('star-burst-icon'),
                size: widget.size,
                color: widget.color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CelebrationBurst extends StatefulWidget {
  const CelebrationBurst({
    super.key,
    required this.active,
    this.onCompleted,
    this.duration = AppMotionSpec.celebration,
  });

  final bool active;
  final VoidCallback? onCompleted;
  final Duration duration;

  @override
  State<CelebrationBurst> createState() => _CelebrationBurstState();
}

class _CelebrationBurstState extends State<CelebrationBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _reducedTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onCompleted?.call();
      }
    });
  }

  @override
  void didUpdateWidget(covariant CelebrationBurst oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) {
      if (AppMotionSpec.reduceMotion(context)) {
        _reducedTimer?.cancel();
        _reducedTimer = Timer(const Duration(milliseconds: 120), () {
          if (mounted) {
            widget.onCompleted?.call();
          }
        });
      } else {
        _controller.forward(from: 0);
      }
    }
  }

  @override
  void dispose() {
    _reducedTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            if (AppMotionSpec.reduceMotion(context)) {
              return child ?? const SizedBox.shrink();
            }
            final curve = Curves.easeOutBack.transform(_controller.value);
            final scale = 0.7 + (curve * 0.6);
            final opacity = 1 - (_controller.value * 0.5);
            return Opacity(
              opacity: opacity,
              child: Transform.scale(scale: scale, child: child),
            );
          },
          child: const Icon(
            Icons.celebration_rounded,
            key: Key('celebration-icon'),
            size: 72,
            color: Color(0xFFF4B400),
          ),
        ),
      ),
    );
  }
}

Widget buildAdaptiveSwitcherTransition({
  required BuildContext context,
  required Animation<double> animation,
  required Widget child,
  Offset beginOffset = const Offset(0.04, 0),
}) {
  if (AppMotionSpec.reduceMotion(context)) {
    return FadeTransition(opacity: animation, child: child);
  }

  return FadeTransition(
    opacity: animation,
    child: SlideTransition(
      position: Tween<Offset>(
        begin: beginOffset,
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
      child: child,
    ),
  );
}
