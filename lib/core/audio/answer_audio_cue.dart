import 'package:flutter/services.dart';

import '../../shared/settings/app_settings_service.dart';

class AnswerAudioCue {
  const AnswerAudioCue._();

  static Future<void> playCorrect() async {
    if (!AppSettingsService.instance.soundEffectsEnabled) {
      return;
    }
    await SystemSound.play(SystemSoundType.click);
    await HapticFeedback.lightImpact();
  }

  static Future<void> playWrong() async {
    if (!AppSettingsService.instance.soundEffectsEnabled) {
      return;
    }
    await HapticFeedback.mediumImpact();
    await Future<void>.delayed(const Duration(milliseconds: 45));
    await SystemSound.play(SystemSoundType.alert);
  }
}
