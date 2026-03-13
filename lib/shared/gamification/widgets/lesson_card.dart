import 'package:flutter/material.dart';

import '../../design/app_design_tokens.dart';
import '../../motion/app_motion_spec.dart';

class LessonCard extends StatefulWidget {
  const LessonCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(14),
    this.backgroundColor = Colors.white,
    this.slideOffset = const Offset(0, 16),
    this.heroTag,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Offset slideOffset;
  final String? heroTag;

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = AppMotionSpec.reduceMotion(context);
    final card = TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppMotionSpec.chooseDuration(
        context,
        const Duration(milliseconds: 340),
        const Duration(milliseconds: 180),
      ),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final dx = reduceMotion ? 0.0 : widget.slideOffset.dx * (1 - value);
        final dy = reduceMotion ? 0.0 : widget.slideOffset.dy * (1 - value);
        final scale = _hovered && !reduceMotion ? 1.01 : 1.0;
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(dx, dy),
            child: Transform.scale(scale: scale, child: child),
          ),
        );
      },
      child: AnimatedContainer(
        duration: AppMotionSpec.chooseDuration(
          context,
          const Duration(milliseconds: 180),
          const Duration(milliseconds: 100),
        ),
        curve: Curves.easeOut,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(AppRadii.md),
          boxShadow: _hovered ? AppShadows.floaty : AppShadows.soft,
        ),
        child: widget.child,
      ),
    );

    final tappable = MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: card,
      ),
    );

    if (widget.heroTag == null) {
      return tappable;
    }
    return Hero(tag: widget.heroTag!, child: tappable);
  }
}
