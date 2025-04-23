import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';

enum NeuraMood { happy, calm, focused, anxious, sad }

class NeuraVoiceEngine {
  final FlutterTts _tts = FlutterTts();

  Future<void> speak(String message, {NeuraMood mood = NeuraMood.calm, String voiceStyle = 'gentle'}) async {
    await _setMoodVoice(mood, voiceStyle);
    await _tts.speak(message);
  }

  Future<void> _setMoodVoice(NeuraMood mood, String style) async {
    switch (mood) {
      case NeuraMood.happy:
        await _tts.setPitch(1.3);
        await _tts.setSpeechRate(0.9);
        break;
      case NeuraMood.calm:
        await _tts.setPitch(1.0);
        await _tts.setSpeechRate(0.8);
        break;
      case NeuraMood.focused:
        await _tts.setPitch(1.1);
        await _tts.setSpeechRate(1.0);
        break;
      case NeuraMood.anxious:
        await _tts.setPitch(0.9);
        await _tts.setSpeechRate(0.7);
        break;
      case NeuraMood.sad:
        await _tts.setPitch(0.85);
        await _tts.setSpeechRate(0.7);
        break;
    }

    if (style == 'wise') {
      await _tts.setPitch(0.95);
    } else if (style == 'fun') {
      await _tts.setPitch(1.4);
    }
  }
}