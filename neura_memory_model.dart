import 'package:shared_preferences/shared_preferences.dart';

class NeuraMemoryModel {
  int moodLogs = 0;
  int goalCompletions = 0;
  int streakDays = 0;
  List<String> instrumentsLearned = [];

  Future<void> loadMemory() async {
    final prefs = await SharedPreferences.getInstance();
    moodLogs = prefs.getInt('neura_mood_logs') ?? 0;
    goalCompletions = prefs.getInt('neura_goal_completions') ?? 0;
    streakDays = prefs.getInt('neura_streak_days') ?? 0;
    instrumentsLearned = prefs.getStringList('neura_instruments') ?? [];
  }

  Future<void> incrementMoodLogs() async {
    final prefs = await SharedPreferences.getInstance();
    moodLogs += 1;
    await prefs.setInt('neura_mood_logs', moodLogs);
  }

  Future<void> incrementGoalCompletions() async {
    final prefs = await SharedPreferences.getInstance();
    goalCompletions += 1;
    await prefs.setInt('neura_goal_completions', goalCompletions);
  }

  Future<void> incrementStreakDays() async {
    final prefs = await SharedPreferences.getInstance();
    streakDays += 1;
    await prefs.setInt('neura_streak_days', streakDays);
  }

  Future<void> addInstrument(String instrument) async {
    final prefs = await SharedPreferences.getInstance();
    if (!instrumentsLearned.contains(instrument)) {
      instrumentsLearned.add(instrument);
      await prefs.setStringList('neura_instruments', instrumentsLearned);
    }
  }

  String summary() {
    return "You've logged $moodLogs moods, completed $goalCompletions goals, held a $streakDays-day streak, and learned: ${instrumentsLearned.join(', ')}.";
  }
}