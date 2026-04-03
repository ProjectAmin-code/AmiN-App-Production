import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsService extends ChangeNotifier {
  AppSettingsService._();

  static final AppSettingsService instance = AppSettingsService._();

  static const String _voiceOverKey = 'amin_settings_voice_over_v1';
  static const String _soundEffectsKey = 'amin_settings_sound_effects_v1';
  static const String _musicKey = 'amin_settings_music_v1';
  static const String _gamificationOverlaysKey =
      'amin_settings_gamification_overlays_v1';

  SharedPreferences? _prefs;
  bool _initialized = false;

  bool _voiceOverEnabled = true;
  bool _soundEffectsEnabled = true;
  bool _musicEnabled = false;
  bool _gamificationOverlaysEnabled = false;

  bool get voiceOverEnabled => _voiceOverEnabled;
  bool get soundEffectsEnabled => _soundEffectsEnabled;
  bool get musicEnabled => _musicEnabled;
  bool get gamificationOverlaysEnabled => _gamificationOverlaysEnabled;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    _initialized = true;
    try {
      _prefs = await SharedPreferences.getInstance();
      _voiceOverEnabled = _prefs?.getBool(_voiceOverKey) ?? true;
      _soundEffectsEnabled = _prefs?.getBool(_soundEffectsKey) ?? true;
      _musicEnabled = _prefs?.getBool(_musicKey) ?? false;
      _gamificationOverlaysEnabled =
          _prefs?.getBool(_gamificationOverlaysKey) ?? false;
    } catch (_) {
      // Keep defaults if preferences are unavailable.
    }
    notifyListeners();
  }

  Future<void> setVoiceOverEnabled(bool value) async {
    if (_voiceOverEnabled == value) {
      return;
    }
    _voiceOverEnabled = value;
    notifyListeners();
    await _persist(_voiceOverKey, value);
  }

  Future<void> setSoundEffectsEnabled(bool value) async {
    if (_soundEffectsEnabled == value) {
      return;
    }
    _soundEffectsEnabled = value;
    notifyListeners();
    await _persist(_soundEffectsKey, value);
  }

  Future<void> setMusicEnabled(bool value) async {
    if (_musicEnabled == value) {
      return;
    }
    _musicEnabled = value;
    notifyListeners();
    await _persist(_musicKey, value);
  }

  Future<void> setGamificationOverlaysEnabled(bool value) async {
    if (_gamificationOverlaysEnabled == value) {
      return;
    }
    _gamificationOverlaysEnabled = value;
    notifyListeners();
    await _persist(_gamificationOverlaysKey, value);
  }

  Future<void> _persist(String key, bool value) async {
    try {
      await _prefs?.setBool(key, value);
    } catch (_) {
      // Ignore persistence errors and keep app responsive.
    }
  }
}
