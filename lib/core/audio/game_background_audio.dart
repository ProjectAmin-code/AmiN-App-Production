import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../shared/settings/app_settings_service.dart';

class GameBackgroundAudio {
  GameBackgroundAudio._();

  static const String _correctSfxAsset = 'audio/answer_audio/right answer.mp3';
  static const String _wrongSfxAsset = 'audio/answer_audio/wrong answer.mp3';
  static const double _bgmVolume = 0.25;
  static const double _sfxVolume = 0.85;
  static final AudioContext _mixingContext = AudioContextConfig(
    focus: AudioContextConfigFocus.mixWithOthers,
  ).build();

  static AudioPlayer? _bgmPlayer;
  static AudioPlayer? _sfxPlayer;
  static String? _currentAsset;
  static bool _pluginUnavailable = false;
  static int _bgmOperation = 0;
  static int _sfxOperation = 0;

  static AudioPlayer get _safeBgmPlayer {
    return _bgmPlayer ??= AudioPlayer();
  }

  static AudioPlayer get _safeSfxPlayer {
    return _sfxPlayer ??= AudioPlayer();
  }

  static Future<void> playGameTrack(int gameNumber) async {
    if (_pluginUnavailable) {
      return;
    }

    final token = ++_bgmOperation;
    try {
      if (!AppSettingsService.instance.musicEnabled) {
        await stop();
        return;
      }

      final player = _safeBgmPlayer;
      final asset = 'audio/games_audio/Game $gameNumber.mp3';
      if (_currentAsset == asset) {
        final state = player.state;
        if (state == PlayerState.playing) {
          return;
        }
      }

      _currentAsset = asset;
      await player.stop();
      if (token != _bgmOperation) {
        return;
      }
      await player.setAudioContext(_mixingContext);
      if (token != _bgmOperation) {
        return;
      }
      await player.setReleaseMode(ReleaseMode.loop);
      if (token != _bgmOperation) {
        return;
      }
      await player.setVolume(_bgmVolume);
      if (token != _bgmOperation) {
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

  static Future<void> playCorrectSfx() async {
    if (!AppSettingsService.instance.soundEffectsEnabled) {
      return;
    }
    await HapticFeedback.lightImpact();
    await _playSfx(_correctSfxAsset, fallback: SystemSoundType.click);
  }

  static Future<void> playWrongSfx() async {
    if (!AppSettingsService.instance.soundEffectsEnabled) {
      return;
    }
    await HapticFeedback.mediumImpact();
    await _playSfx(_wrongSfxAsset, fallback: SystemSoundType.alert);
  }

  static Future<void> _playSfx(
    String asset, {
    required SystemSoundType fallback,
  }) async {
    if (!AppSettingsService.instance.soundEffectsEnabled) {
      return;
    }
    if (_pluginUnavailable) {
      await SystemSound.play(fallback);
      return;
    }

    final token = ++_sfxOperation;
    try {
      final player = _safeSfxPlayer;
      await player.stop();
      if (token != _sfxOperation) {
        return;
      }
      await player.setAudioContext(_mixingContext);
      if (token != _sfxOperation) {
        return;
      }
      await player.setReleaseMode(ReleaseMode.stop);
      if (token != _sfxOperation) {
        return;
      }
      await player.setVolume(_sfxVolume);
      if (token != _sfxOperation) {
        return;
      }
      await player.play(AssetSource(asset));
    } catch (error, stackTrace) {
      if (error is MissingPluginException) {
        _pluginUnavailable = true;
        debugPrint('Game SFX disabled until full app restart: $error');
      } else {
        debugPrint('Game SFX failed: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
      await SystemSound.play(fallback);
    }
  }

  static Future<void> stop() async {
    if (_pluginUnavailable) {
      return;
    }

    _bgmOperation += 1;
    try {
      _currentAsset = null;
      await _bgmPlayer?.stop();
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

  static Future<void> stopSfx() async {
    if (_pluginUnavailable) {
      return;
    }

    _sfxOperation += 1;
    try {
      await _sfxPlayer?.stop();
    } catch (error, stackTrace) {
      if (error is MissingPluginException) {
        _pluginUnavailable = true;
        debugPrint('Game SFX disabled until full app restart: $error');
        return;
      }
      debugPrint('Game SFX stop failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  static Future<void> stopAll() async {
    await stop();
    await stopSfx();
  }

  static Future<void> dispose() async {
    _bgmOperation += 1;
    _sfxOperation += 1;
    _currentAsset = null;
    final bgmPlayer = _bgmPlayer;
    final sfxPlayer = _sfxPlayer;
    _bgmPlayer = null;
    _sfxPlayer = null;
    await bgmPlayer?.dispose();
    await sfxPlayer?.dispose();
  }
}
