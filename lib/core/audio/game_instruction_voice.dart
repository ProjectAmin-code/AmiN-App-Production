import '../../learning/services/amin_tts_service.dart';
import '../../shared/settings/app_settings_service.dart';

class GameInstructionVoice {
  GameInstructionVoice._();

  static Future<void> speak(String text) async {
    if (!AppSettingsService.instance.voiceOverEnabled) {
      return;
    }
    await AminTtsService.instance.speak(text);
  }

  static Future<void> stop() {
    return AminTtsService.instance.stop();
  }
}
