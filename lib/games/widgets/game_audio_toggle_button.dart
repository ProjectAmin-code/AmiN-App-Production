import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/audio/game_background_audio.dart';
import '../../shared/settings/app_settings_service.dart';

class GameAudioToggleButton extends StatelessWidget {
  const GameAudioToggleButton({
    super.key,
    required this.gameNumber,
    required this.canPlay,
  });

  final int gameNumber;
  final bool canPlay;

  Future<void> _toggle() async {
    final settings = AppSettingsService.instance;
    final enabled = !settings.musicEnabled;
    await settings.setMusicEnabled(enabled);
    if (!enabled) {
      await GameBackgroundAudio.stop();
      return;
    }
    if (canPlay) {
      unawaited(GameBackgroundAudio.playGameTrack(gameNumber));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppSettingsService.instance,
      builder: (context, _) {
        final enabled = AppSettingsService.instance.musicEnabled;
        return IconButton.filledTonal(
          onPressed: _toggle,
          tooltip: enabled ? 'Matikan muzik' : 'Hidupkan muzik',
          icon: Icon(
            enabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
          ),
        );
      },
    );
  }
}
