import 'dart:async';

import 'package:flutter/material.dart';

import 'gamification_controller.dart';
import 'gamification_event.dart';
import 'widgets/gamification_widgets.dart';

class GamificationOverlayHost extends StatefulWidget {
  const GamificationOverlayHost({
    super.key,
    required this.controller,
    required this.child,
  });

  final GamificationController controller;
  final Widget child;

  @override
  State<GamificationOverlayHost> createState() => _GamificationOverlayHostState();
}

class _GamificationOverlayHostState extends State<GamificationOverlayHost> {
  GamificationEvent? _active;
  Timer? _clearTimer;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant GamificationOverlayHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    _clearTimer?.cancel();
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (_active != null) {
      return;
    }
    _showNext();
  }

  void _showNext() {
    final next = widget.controller.popNextEvent();
    if (next == null) {
      return;
    }
    setState(() => _active = next);
    _clearTimer?.cancel();
    _clearTimer = Timer(const Duration(milliseconds: 1300), () {
      if (!mounted) {
        return;
      }
      setState(() => _active = null);
      _showNext();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_active != null) _buildOverlay(_active!),
      ],
    );
  }

  Widget _buildOverlay(GamificationEvent event) {
    switch (event.type) {
      case GamificationEventType.xp:
        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 90),
            child: XPAnimation(amount: event.amount),
          ),
        );
      case GamificationEventType.streak:
        return Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 88, right: 14),
            child: StreakWidget(streak: event.amount),
          ),
        );
      case GamificationEventType.stars:
        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 90),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, color: Color(0xFFFFB020)),
                const SizedBox(width: 4),
                Text(
                  '+${event.amount} Bintang',
                  style: const TextStyle(
                    color: Color(0xFF1D3557),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        );
      case GamificationEventType.levelUnlock:
        return RewardPopup(
          title: event.title.isEmpty ? 'Naik Level!' : event.title,
          message: event.label,
          onClose: () => setState(() => _active = null),
        );
      case GamificationEventType.reward:
        return RewardPopup(
          title: event.title,
          message: event.message,
          coins: event.amount,
          onClose: () => setState(() => _active = null),
        );
    }
  }
}
