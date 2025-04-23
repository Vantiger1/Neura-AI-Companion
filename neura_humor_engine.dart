import 'neura_joke_engine.dart';
import 'neura_joke_history_manager.dart';
import 'neura_voice_engine.dart';

class NeuraHumorEngine {
  final NeuraJokeEngine _jokeEngine = NeuraJokeEngine();
  final NeuraJokeHistoryManager _historyManager = NeuraJokeHistoryManager();
  final NeuraVoiceEngine _voiceEngine = NeuraVoiceEngine();

  Future<void> init() async {
    await _historyManager.loadHistory();
  }

  Future<void> tellJoke({bool cleanOnly = true}) async {
    String joke = _jokeEngine.getJoke(cleanOnly: cleanOnly);

    // Avoid disliked jokes
    int safety = 0;
    while (_historyManager.isDisliked(joke) && safety < 10) {
      joke = _jokeEngine.getJoke(cleanOnly: cleanOnly);
      safety++;
    }

    // Speak the joke
    await _voiceEngine.speak(joke);
  }

  Future<void> tellFavoriteJoke() async {
    final favs = _historyManager.getFavorites();
    if (favs.isNotEmpty) {
      final joke = favs[DateTime.now().millisecondsSinceEpoch % favs.length];
      await _voiceEngine.speak(joke);
    } else {
      await _voiceEngine.speak("You haven’t saved any favorites yet.");
    }
  }

  Future<void> rateJoke(String joke, {bool like = true}) async {
    if (like) {
      await _historyManager.addFavorite(joke);
    } else {
      await _historyManager.addDislike(joke);
    }
  }
}