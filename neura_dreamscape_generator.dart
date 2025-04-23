import 'package:flutter/material.dart';

class DreamscapeTheme {
  final List<Color> colors;
  final String emotion;
  final String description;

  DreamscapeTheme(this.emotion, this.colors, this.description);
}

class NeuraDreamscapeGenerator {
  DreamscapeTheme getVisualTheme(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
        return DreamscapeTheme('happy', [Colors.yellowAccent, Colors.orangeAccent],
            "A glowing sunrise with floating stars.");
      case 'anxious':
        return DreamscapeTheme('anxious', [Colors.deepPurple, Colors.indigo],
            "A swirling fog with gentle calming ripples.");
      case 'sad':
        return DreamscapeTheme('sad', [Colors.blueGrey, Colors.lightBlueAccent],
            "A drifting sea of stars and reflections.");
      case 'focused':
        return DreamscapeTheme('focused', [Colors.teal, Colors.greenAccent],
            "Structured patterns with rhythmic motion.");
      default:
        return DreamscapeTheme('calm', [Colors.cyan, Colors.blueAccent],
            "Peaceful waves in a dreamlike space.");
    }
  }
}