import 'package:flutter/material.dart';
import 'neura_voice_engine.dart';
import 'neura_memory_model.dart';
import 'neura_settings_manager.dart';

class NeuraManager with ChangeNotifier {
  final NeuraVoiceEngine voiceEngine = NeuraVoiceEngine();
  final NeuraMemoryModel memory = NeuraMemoryModel();
  final NeuraSettingsManager settings = NeuraSettingsManager();

  bool initialized = false;

  Future<void> init() async {
    await memory.loadMemory();
    await settings.loadSettings();
    initialized = true;
    notifyListeners();
  }

  Future<void> logMood(NeuraMood mood) async {
    await memory.incrementMoodLogs();
    if (settings.isVoiceEnabled && !settings.quietMode) {
      await voiceEngine.speak(
        "Thanks for checking in. I'm proud of you.",
        mood: mood,
        voiceStyle: settings.voice,
      );
    }
    notifyListeners();
  }

  Future<void> completeGoal(String goalName) async {
    await memory.incrementGoalCompletions();
    if (settings.isVoiceEnabled && !settings.quietMode) {
      await voiceEngine.speak(
        "Goal complete! Great job with $goalName!",
        mood: NeuraMood.happy,
        voiceStyle: settings.voice,
      );
    }
    notifyListeners();
  }

  Future<void> streakIncrease() async {
    await memory.incrementStreakDays();
    if (settings.isVoiceEnabled && !settings.quietMode) {
      await voiceEngine.speak(
        "You're on a roll! That's another streak day.",
        mood: NeuraMood.focused,
        voiceStyle: settings.voice,
      );
    }
    notifyListeners();
  }

  Future<void> logInstrument(String instrument) async {
    await memory.addInstrument(instrument);
    if (settings.isVoiceEnabled && !settings.quietMode) {
      await voiceEngine.speak(
        "You practiced $instrument again today! I'm learning it with you!",
        mood: NeuraMood.calm,
        voiceStyle: settings.voice,
      );
    }
    notifyListeners();
  }

  String getGrowthSummary() {
    return memory.summary();
  }
}