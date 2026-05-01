import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../design/app_design_tokens.dart';
import '../../motion/app_motion_spec.dart';

class AnimatedKidButton extends StatefulWidget {
  const AnimatedKidButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor = AppColors.primary,
    this.foregroundColor = Colors.white,
    this.height = 54,
    this.labelFontSize = 18,
    this.heroTag,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final double height;
  final double labelFontSize;
  final String? heroTag;

  @override
  State<AnimatedKidButton> createState() => _AnimatedKidButtonState();
}

class _AnimatedKidButtonState extends State<AnimatedKidButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotionSpec.tapBounce,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (widget.onPressed == null) {
      return;
    }
    HapticFeedback.lightImpact();
    if (AppMotionSpec.reduceMotion(context)) {
      widget.onPressed?.call();
      return;
    }
    if (_controller.isAnimating) {
      return;
    }
    await _controller.forward(from: 0);
    if (!mounted) {
      return;
    }
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final child = SizedBox(
      width: double.infinity,
      height: widget.height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.onPressed == null
              ? widget.backgroundColor.withValues(alpha: 0.45)
              : widget.backgroundColor,
          borderRadius: BorderRadius.circular(AppRadii.sm),
          boxShadow: _hovered ? AppShadows.floaty : AppShadows.soft,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadii.sm),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadii.sm),
            onTap: _handleTap,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          color: widget.foregroundColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: widget.foregroundColor,
                          fontWeight: FontWeight.w900,
                          fontSize: widget.labelFontSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final wrapped = MouseRegion(
      onEnter: (_) {
        if (mounted) {
          setState(() => _hovered = true);
        }
      },
      onExit: (_) {
        if (mounted) {
          setState(() => _hovered = false);
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, widgetChild) {
          final reduceMotion = AppMotionSpec.reduceMotion(context);
          final bounceScale = reduceMotion
              ? 1.0
              : 1 - (math.sin(_controller.value * math.pi) * 0.06);
          final hoverScale = _hovered && !reduceMotion ? 1.02 : 1.0;
          return Transform.scale(
            scale: bounceScale * hoverScale,
            child: widgetChild,
          );
        },
        child: child,
      ),
    );

    if (widget.heroTag == null) {
      return wrapped;
    }
    return Hero(tag: widget.heroTag!, child: wrapped);
  }
}
