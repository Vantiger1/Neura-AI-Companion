import 'package:shared_preferences/shared_preferences.dart';

class NeuraJokeHistoryManager {
  List<String> favorites = [];
  List<String> dislikes = [];

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    favorites = prefs.getStringList('neura_joke_favorites') ?? [];
    dislikes = prefs.getStringList('neura_joke_dislikes') ?? [];
  }

  Future<void> addFavorite(String joke) async {
    final prefs = await SharedPreferences.getInstance();
    if (!favorites.contains(joke)) {
      favorites.add(joke);
      await prefs.setStringList('neura_joke_favorites', favorites);
    }
  }

  Future<void> addDislike(String joke) async {
    final prefs = await SharedPreferences.getInstance();
    if (!dislikes.contains(joke)) {
      dislikes.add(joke);
      await prefs.setStringList('neura_joke_dislikes', dislikes);
    }
  }

  bool isFavorite(String joke) => favorites.contains(joke);
  bool isDisliked(String joke) => dislikes.contains(joke);

  List<String> getFavorites() => favorites;
}