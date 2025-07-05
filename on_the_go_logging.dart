library on_the_go_logging;

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class OnTheGoLogging {
  static final _speech = stt.SpeechToText();
  static final _tts = FlutterTts();

  /// Start voice logging
  static Future<String> recordAndTranscribe() async {
    if (!await _speech.initialize()) return '';
    String recognizedWords = '';
    await _speech.listen(
      onResult: (stt.SpeechRecognitionResult result) {
        recognizedWords = result.recognizedWords;
      },
      listenFor: Duration(seconds: 5),
      partialResults: true,
    );
    await Future.delayed(Duration(seconds: 5));
    _speech.stop();
    return recognizedWords;
  }

  /// Play back text
  static Future<void> speak(String text) => _tts.speak(text);
}