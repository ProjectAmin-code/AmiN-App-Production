import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../shared/settings/app_settings_service.dart';

class AnswerAudioCue {
  const AnswerAudioCue._();

  static const String _correctAsset = 'audio/answer_audio/right answer.mp3';
  static const String _wrongAsset = 'audio/answer_audio/wrong answer.mp3';

  static AudioPlayer? _player;
  static bool _pluginUnavailable = false;
  static int _operation = 0;

  static AudioPlayer get _safePlayer {
    return _player ??= AudioPlayer();
  }

  static Future<void> playCorrect() async {
    if (!AppSettingsService.instance.soundEffectsEnabled) {
      return;
    }
    await HapticFeedback.lightImpact();
    await _playAsset(_correctAsset, fallback: SystemSoundType.click);
  }

  static Future<void> playWrong() async {
    if (!AppSettingsService.instance.soundEffectsEnabled) {
      return;
    }
    await HapticFeedback.mediumImpact();
    await _playAsset(_wrongAsset, fallback: SystemSoundType.alert);
  }

  static Future<void> _playAsset(
    String asset, {
    required SystemSoundType fallback,
  }) async {
    if (_pluginUnavailable) {
      await SystemSound.play(fallback);
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
      await player.setVolume(1);
      if (token != _operation) {
        return;
      }
      await player.play(AssetSource(asset));
    } catch (error, stackTrace) {
      if (error is MissingPluginException) {
        _pluginUnavailable = true;
        debugPrint('Answer audio disabled until full app restart: $error');
      } else {
        debugPrint('Answer audio failed: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
      await SystemSound.play(fallback);
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
        debugPrint('Answer audio disabled until full app restart: $error');
        return;
      }
      debugPrint('Answer audio stop failed: $error');
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
