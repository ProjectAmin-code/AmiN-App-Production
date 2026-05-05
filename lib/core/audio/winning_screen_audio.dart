import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../shared/settings/app_settings_service.dart';

class WinningScreenAudio {
  WinningScreenAudio._();

  static const String _asset = 'audio/winning_screens/winning_screen.mp3';
  static const double _volume = 0.9;

  static AudioPlayer? _player;
  static bool _pluginUnavailable = false;
  static int _operation = 0;

  static AudioPlayer get _safePlayer {
    return _player ??= AudioPlayer();
  }

  static Future<void> play() async {
    if (!AppSettingsService.instance.soundEffectsEnabled) {
      return;
    }
    if (_pluginUnavailable) {
      await SystemSound.play(SystemSoundType.click);
      return;
    }

    final token = ++_operation;
    try {
      final player = _safePlayer;
      await player.stop();
      if (token != _operation) {
        return;
      }
      await player.setReleaseMode(ReleaseMode.stop);
      if (token != _operation) {
        return;
      }
      await player.setVolume(_volume);
      if (token != _operation) {
        return;
      }
      await player.play(AssetSource(_asset));
    } catch (error, stackTrace) {
      if (error is MissingPluginException) {
        _pluginUnavailable = true;
        debugPrint('Winning screen audio disabled until full app restart: $error');
      } else {
        debugPrint('Winning screen audio failed: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
      await SystemSound.play(SystemSoundType.click);
    }
  }

  static Future<void> stop() async {
    if (_pluginUnavailable) {
      return;
    }

    _operation += 1;
    try {
      await _player?.stop();
    } catch (error, stackTrace) {
      if (error is MissingPluginException) {
        _pluginUnavailable = true;
        debugPrint('Winning screen audio disabled until full app restart: $error');
        return;
      }
      debugPrint('Winning screen audio stop failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  static Future<void> dispose() async {
    _operation += 1;
    final player = _player;
    _player = null;
    await player?.dispose();
  }
}

class WinningScreenAudioCue extends StatefulWidget {
  const WinningScreenAudioCue({super.key});

  @override
  State<WinningScreenAudioCue> createState() => _WinningScreenAudioCueState();
}

class _WinningScreenAudioCueState extends State<WinningScreenAudioCue> {
  @override
  void initState() {
    super.initState();
    unawaited(WinningScreenAudio.play());
  }

  @override
  void dispose() {
    unawaited(WinningScreenAudio.stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
