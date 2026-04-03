import 'dart:async';

import 'package:flutter/material.dart';

import 'gamification_controller.dart';
import 'gamification_event.dart';
import '../settings/app_settings_service.dart';
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
  State<GamificationOverlayHost> createState() =>
      _GamificationOverlayHostState();
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
      children: [widget.child, if (_active != null) _buildOverlay(_active!)],
    );
  }

  Widget _buildOverlay(GamificationEvent event) {
    if (!AppSettingsService.instance.gamificationOverlaysEnabled) {
      return const SizedBox.shrink();
    }
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
        return const SizedBox.shrink();
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
