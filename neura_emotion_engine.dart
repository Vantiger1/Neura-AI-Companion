import 'package:flutter/material.dart';

enum NeuraEmotion { happy, calm, focused, anxious, sad }

class NeuraEmotionEngine extends ChangeNotifier {
  NeuraEmotion _currentEmotion = NeuraEmotion.calm;

  NeuraEmotion get currentEmotion => _currentEmotion;

  void updateEmotion(NeuraEmotion emotion) {
    _currentEmotion = emotion;
    notifyListeners();
  }

  Color getGlowColor() {
    switch (_currentEmotion) {
      case NeuraEmotion.happy:
        return Colors.amberAccent;
      case NeuraEmotion.calm:
        return Colors.cyanAccent;
      case NeuraEmotion.focused:
        return Colors.greenAccent;
      case NeuraEmotion.anxious:
        return Colors.deepPurpleAccent;
      case NeuraEmotion.sad:
        return Colors.blueAccent;
    }
  }

  String getEmotionLabel() {
    switch (_currentEmotion) {
      case NeuraEmotion.happy:
        return "Happy";
      case NeuraEmotion.calm:
        return "Calm";
      case NeuraEmotion.focused:
        return "Focused";
      case NeuraEmotion.anxious:
        return "Anxious";
      case NeuraEmotion.sad:
        return "Sad";
    }
  }

  String getReactionPhrase() {
    switch (_currentEmotion) {
      case NeuraEmotion.happy:
        return "I'm glowing with joy!";
      case NeuraEmotion.calm:
        return "Peaceful as the breeze.";
      case NeuraEmotion.focused:
        return "Locked in and ready.";
      case NeuraEmotion.anxious:
        return "Taking a deep breath with you...";
      case NeuraEmotion.sad:
        return "It's okay to feel this way. I'm here.";
    }
  }
}