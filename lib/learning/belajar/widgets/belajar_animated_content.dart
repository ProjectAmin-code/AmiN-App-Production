import 'package:flutter/material.dart';

import '../animations/belajar_animation_presets.dart';
import '../models/belajar_animation_type.dart';

class BelajarAnimatedContent extends StatefulWidget {
  const BelajarAnimatedContent({
    super.key,
    required this.child,
    required this.animationType,
    this.delay = Duration.zero,
  });

  final Widget child;
  final BelajarAnimationType animationType;
  final Duration delay;

  @override
  State<BelajarAnimatedContent> createState() => _BelajarAnimatedContentState();
}

class _BelajarAnimatedContentState extends State<BelajarAnimatedContent> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _scheduleAnimation();
  }

  @override
  void didUpdateWidget(covariant BelajarAnimatedContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationType != widget.animationType ||
        oldWidget.delay != widget.delay) {
      _scheduleAnimation();
    }
  }

  void _scheduleAnimation() {
    _visible = false;
    if (widget.animationType == BelajarAnimationType.none) {
      _visible = true;
      return;
    }
    Future<void>.delayed(widget.delay, () {
      if (!mounted) {
        return;
      }
      setState(() {
        _visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animationType == BelajarAnimationType.none) {
      return widget.child;
    }

    final preset = BelajarAnimationPresets.of(widget.animationType);
    return TweenAnimationBuilder<double>(
      key: ValueKey(
        '${widget.animationType.name}_${widget.delay.inMilliseconds}',
      ),
      tween: Tween<double>(begin: 0, end: _visible ? 1 : 0),
      duration: preset.duration,
      curve: preset.curve,
      builder: (context, value, child) {
        final slideOffset = Offset(
          preset.offset.dx * (1 - value),
          preset.offset.dy * (1 - value),
        );
        final startScale = preset.startScale;
        final scale = startScale + ((1 - startScale) * value);

        return Opacity(
          opacity: value.clamp(0, 1),
          child: Transform.translate(
            offset: slideOffset,
            child: Transform.scale(scale: scale, child: child),
          ),
        );
      },
      child: widget.child,
    );
  }
}
