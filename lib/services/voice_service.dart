import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;

  bool get isListening => _speech.isListening;
  bool get isAvailable => _isInitialized;

  Future<bool> initialize() async {
    if (!_isInitialized) {
      _isInitialized = await _speech.initialize(
        onStatus: (status) => debugPrint('Speech Status: $status'),
        onError: (errorNotification) =>
            debugPrint('Speech Error: ${errorNotification.errorMsg}'),
      );
    }
    return _isInitialized;
  }

  Future<void> startListening({
    required String languageCode, // 'en' or 'mr'
    required Function(String recognizedWords) onResult,
    required VoidCallback onSoundLevelChange,
  }) async {
    final hasInit = await initialize();
    if (!hasInit) return;

    // Pick Marathi (India) or English (India/US)
    final localeId = languageCode == 'mr' ? 'mr_IN' : 'en_IN';

    await _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords);
      },
      localeId: localeId,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      partialResults: true,
      cancelOnError: true,
      listenMode: stt.ListenMode.dictation,
    );
  }

  Future<void> stopListening() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
  }

  Future<void> cancelListening() async {
    if (_speech.isListening) {
      await _speech.cancel();
    }
  }
}