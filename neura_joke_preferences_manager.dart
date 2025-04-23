import 'package:shared_preferences/shared_preferences.dart';

class NeuraJokePreferencesManager {
  bool cleanOnly = true;
  int userAge = 0;

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    cleanOnly = prefs.getBool('neura_joke_clean_only') ?? true;
    userAge = prefs.getInt('neura_user_age') ?? 0;
  }

  Future<void> setAge(int age) async {
    final prefs = await SharedPreferences.getInstance();
    userAge = age;
    await prefs.setInt('neura_user_age', age);
    // auto-enforce cleanOnly for underage
    if (age < 18) {
      await setCleanOnly(true);
    }
  }

  Future<void> setCleanOnly(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    cleanOnly = value;
    await prefs.setBool('neura_joke_clean_only', value);
  }

  bool get canUseDirtyJokes => userAge >= 18 && cleanOnly == false;
}