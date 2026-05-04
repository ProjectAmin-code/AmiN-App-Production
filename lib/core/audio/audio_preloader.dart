import 'package:flutter/services.dart';

/// Lightweight preloader for voice-over and pronunciation assets.
///
/// It is safe to call this even when files are missing because failures are
/// collected and ignored to keep startup resilient.
class AudioPreloader {
  const AudioPreloader._();

  static final List<String> _defaultVoiceOverAssets = <String>[
    'assets/audio/voice_over/s001_intro.mp3',
    'assets/audio/voice_over/s002_welcome.mp3',
    'assets/audio/voice_over/s003_menu.mp3',
  ];

  static final List<String> _defaultPronunciationAssets = <String>[
    'assets/audio/words/baca.mp3',
    'assets/audio/words/membaca.mp3',
  ];

  static final List<String> _defaultGameAssets = <String>[
    'assets/audio/games_audio/Game 1.mp3',
    'assets/audio/games_audio/Game 2.mp3',
    'assets/audio/games_audio/Game 3.mp3',
    'assets/audio/games_audio/Game 4.mp3',
    'assets/audio/answer_audio/right answer.mp3',
    'assets/audio/answer_audio/wrong answer.mp3',
  ];

  static Future<void> preloadDefaults() async {
    final all = <String>[
      ..._defaultVoiceOverAssets,
      ..._defaultPronunciationAssets,
      ..._defaultGameAssets,
    ];
    for (final asset in all) {
      try {
        await rootBundle.load(asset);
      } catch (_) {
        // Missing audio files are expected in placeholder mode.
      }
    }
  }
}
