import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../motion/app_motion_spec.dart';
import '../../motion/app_motion_widgets.dart';

enum MascotState {
  idle,
  blink,
  celebrate,
  encourage,
  errorReact,
}

class MascotWidget extends StatefulWidget {
  const MascotWidget({
    super.key,
    required this.assetPath,
    this.width = 96,
    this.height = 96,
    this.state = MascotState.idle,
    this.speech,
  });

  final String assetPath;
  final double width;
  final double height;
  final MascotState state;
  final String? speech;

  @override
  State<MascotWidget> createState() => _MascotWidgetState();
}

class _MascotWidgetState extends State<MascotWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotionSpec.reduceMotion(context)) {
      _controller.stop();
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
    final image = Image.asset(
      widget.assetPath,
      width: widget.width,
      height: widget.height,
      fit: BoxFit.contain,
    );

    final mascot = AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final reduceMotion = AppMotionSpec.reduceMotion(context);
        if (reduceMotion) {
          return image;
        }

        double angle = 0;
        double scale = 1;
        double dy = 0;
        switch (widget.state) {
          case MascotState.idle:
            dy = math.sin(_controller.value * math.pi) * -2;
            break;
          case MascotState.blink:
            scale = 1 - (math.sin(_controller.value * math.pi) * 0.03);
            break;
          case MascotState.celebrate:
            scale = 1 + (math.sin(_controller.value * math.pi) * 0.11);
            angle = math.sin(_controller.value * math.pi) * 0.12;
            break;
          case MascotState.encourage:
            dy = math.sin(_controller.value * math.pi) * -5;
            break;
          case MascotState.errorReact:
            angle = math.sin(_controller.value * math.pi * 3) * 0.04;
            break;
        }
        return Transform.translate(
          offset: Offset(0, dy),
          child: Transform.rotate(
            angle: angle,
            child: Transform.scale(scale: scale, child: image),
          ),
        );
      },
    );

    final decorated = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.state == MascotState.idle
            ? BreathingCharacter(child: mascot)
            : mascot,
        if (widget.speech != null && widget.speech!.trim().isNotEmpty) ...[
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.speech!,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D3557),
              ),
            ),
          ),
        ],
      ],
    );

    return RepaintBoundary(child: decorated);
  }
}
