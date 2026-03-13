import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../../motion/app_motion_spec.dart';

class ConfettiCelebration extends StatefulWidget {
  const ConfettiCelebration({
    super.key,
    required this.active,
    this.duration = const Duration(milliseconds: 950),
    this.child,
  });

  final bool active;
  final Duration duration;
  final Widget? child;

  @override
  State<ConfettiCelebration> createState() => _ConfettiCelebrationState();
}

class _ConfettiCelebrationState extends State<ConfettiCelebration> {
  late final ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: widget.duration);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.active && mounted && !AppMotionSpec.reduceMotion(context)) {
        _controller.play();
      }
    });
  }

  @override
  void didUpdateWidget(covariant ConfettiCelebration oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active && !AppMotionSpec.reduceMotion(context)) {
      _controller.play();
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
      alignment: Alignment.center,
      children: [
        if (widget.child != null) widget.child!,
        IgnorePointer(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controller,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 22,
              emissionFrequency: 0.03,
              gravity: 0.22,
              maxBlastForce: 16,
              minBlastForce: 8,
            ),
          ),
        ),
      ],
    );
  }
}
