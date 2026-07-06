import 'package:speech_to_text/speech_to_text.dart';

/// Thin wrapper around `speech_to_text`, ported from the prototype's
/// `useSpeechRecognition.ts` (single-shot recognition, `en-GB` locale).
class SpeechService {
  final SpeechToText _speech = SpeechToText();
  bool _initialized = false;

  Future<bool> initialize() async {
    if (_initialized) return true;
    _initialized = await _speech.initialize();
    return _initialized;
  }

  Future<void> listen({required void Function(String text) onResult}) async {
    await _speech.listen(
      onResult: (result) {
        if (result.finalResult && result.recognizedWords.trim().isNotEmpty) {
          onResult(result.recognizedWords.trim());
          _speech.stop();
        }
      },
      listenOptions: SpeechListenOptions(partialResults: false, localeId: 'en_GB'),
    );
  }

  Future<void> stop() => _speech.stop();
}
