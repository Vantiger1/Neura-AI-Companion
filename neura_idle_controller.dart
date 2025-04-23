import 'dart:math';
import 'package:flutter/material.dart';

class NeuraIdleController extends ChangeNotifier {
  String currentIdleActivity = "floating";
  final List<String> possibleActivities = [
    "floating",
    "playing melody",
    "drawing sparks",
    "stretching",
    "daydreaming",
    "spinning slowly",
    "deep breathing"
  ];

  void pickRandomIdle() {
    final rand = Random();
    final selected = possibleActivities[rand.nextInt(possibleActivities.length)];
    currentIdleActivity = selected;
    notifyListeners();
  }

  String getCurrentActionDescription() {
    switch (currentIdleActivity) {
      case "floating":
        return "Neura is gently floating by.";
      case "playing melody":
        return "Neura is composing a tiny tune.";
      case "drawing sparks":
        return "Neura is drawing light trails in the air.";
      case "stretching":
        return "Neura is doing a tiny stretch.";
      case "daydreaming":
        return "Neura is lost in deep thought.";
      case "spinning slowly":
        return "Neura is twirling in rhythm.";
      case "deep breathing":
        return "Neura is helping you breathe calmly.";
      default:
        return "Neura is resting.";
    }
  }
}