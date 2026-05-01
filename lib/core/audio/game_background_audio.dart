import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../shared/settings/app_settings_service.dart';

class GameBackgroundAudio {
  GameBackgroundAudio._();

  static AudioPlayer? _player;
  static String? _currentAsset;
  static bool _pluginUnavailable = false;
  static int _operation = 0;

  static AudioPlayer get _safePlayer {
    return _player ??= AudioPlayer();
  }

  static Future<void> playGameTrack(int gameNumber) async {
    if (_pluginUnavailable) {
      return;
    }

    final token = ++_operation;
    try {
      if (!AppSettingsService.instance.musicEnabled) {
        await stop();
        return;
      }

      final player = _safePlayer;
      final asset = 'audio/games_audio/Game $gameNumber.mp3';
      if (_currentAsset == asset) {
        final state = player.state;
        if (state == PlayerState.playing) {
          return;
        }
      }

      _currentAsset = asset;
      await player.stop();
      if (token != _operation) {
        return;
      }
      await player.setReleaseMode(ReleaseMode.loop);
      if (token != _operation) {
        return;
      }
      await player.setVolume(0.45);
      if (token != _operation) {
        return;
      }
      await player.play(AssetSource(asset));
    } catch (error, stackTrace) {
      _currentAsset = null;
      if (error is MissingPluginException) {
        _pluginUnavailable = true;
        debugPrint(
          'Game background audio disabled until full app restart: $error',
        );
        return;
      }
      debugPrint('Game background audio failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  static Future<void> stop() async {
    if (_pluginUnavailable) {
      return;
    }

    _operation += 1;
    try {
      _currentAsset = null;
      await _player?.stop();
    } catch (error, stackTrace) {
      if (error is MissingPluginException) {
        _pluginUnavailable = true;
        debugPrint(
          'Game background audio disabled until full app restart: $error',
        );
        return;
      }
      debugPrint('Game background audio stop failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  static Future<void> dispose() async {
    _operation += 1;
    _currentAsset = null;
    final player = _player;
    _player = null;
    await player?.dispose();
  }
}
