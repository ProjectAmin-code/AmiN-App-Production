import 'package:flutter_tts/flutter_tts.dart';

class AminTtsService {
  AminTtsService._();

  static final AminTtsService instance = AminTtsService._();

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;
  int _session = 0;

  Future<void> init() async {
    if (_initialized) {
      return;
    }
    await _tts.setLanguage('ms-MY');
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    await _tts.awaitSpeakCompletion(true);
    _initialized = true;
  }

  Future<void> speak(String text) async {
    if (text.trim().isEmpty) {
      return;
    }
    final token = ++_session;
    await init();
    if (token != _session) {
      return;
    }
    await _safeStop();
    if (token != _session) {
      return;
    }
    await _speakWithRetry(text, token);
  }

  Future<void> speakPair(String first, String second) async {
    if (first.trim().isEmpty || second.trim().isEmpty) {
      return;
    }
    final token = ++_session;
    await init();
    if (token != _session) {
      return;
    }
    await _safeStop();
    if (token != _session) {
      return;
    }
    await _speakWithRetry(first, token);
    if (token != _session) {
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 320));
    if (token != _session) {
      return;
    }
    await _speakWithRetry(second, token);
  }

  Future<void> speakWords(
    List<String> words, {
    bool Function()? shouldContinue,
    void Function(int index)? onWordStart,
  }) async {
    final sanitized = words
        .map((word) => word.trim())
        .where((word) => word.isNotEmpty)
        .toList(growable: false);
    if (sanitized.isEmpty) {
      return;
    }

    final token = ++_session;
    await init();
    if (token != _session || !(shouldContinue?.call() ?? true)) {
      return;
    }
    await _safeStop();
    if (token != _session || !(shouldContinue?.call() ?? true)) {
      return;
    }

    for (var index = 0; index < sanitized.length; index += 1) {
      if (token != _session || !(shouldContinue?.call() ?? true)) {
        return;
      }
      onWordStart?.call(index);
      await _speakWithRetry(sanitized[index], token);
    }
  }

  Future<void> stop() async {
    _session += 1;
    await _safeStop();
  }

  Future<void> _safeStop() async {
    if (!_initialized) {
      return;
    }
    try {
      await _tts.stop();
    } catch (_) {
      // Ignore stop race/errors (e.g. engine not bound yet on Android).
    }
  }

  Future<void> _speakWithRetry(String text, int token) async {
    final speechText = _normalizeSpeechText(text);
    final first = await _tts.speak(speechText);
    if (token != _session) {
      await _safeStop();
      return;
    }
    if (_isSuccess(first)) {
      return;
    }
    await _safeStop();
    await Future<void>.delayed(const Duration(milliseconds: 120));
    if (token != _session) {
      return;
    }
    await _tts.speak(speechText);
  }

  String _normalizeSpeechText(String text) {
    return text
        .replaceAll('menge-', 'meng-geh')
        .replaceAll('meN-', 'meh-en')
        .replaceAll('me-', 'meh');
  }

  bool _isSuccess(dynamic result) {
    if (result == null) {
      return true;
    }
    if (result is int) {
      return result == 1;
    }
    if (result is bool) {
      return result;
    }
    return true;
  }
}
