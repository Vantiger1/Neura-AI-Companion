library on_the_go_logging;

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class OnTheGoLogging {
  static final _speech = stt.SpeechToText();
  static final _tts = FlutterTts();

  /// Start voice logging
  static Future<String> recordAndTranscribe() async {
    if (!await _speech.initialize()) return '';
    await _speech.listen();
    await Future.delayed(Duration(seconds: 5));
    _speech.stop();
    return _speech.lastRecognizedWords;
  }

  /// Play back text
  static Future<void> speak(String text) => _tts.speak(text);
}