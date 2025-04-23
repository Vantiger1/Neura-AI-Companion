import 'openai_api_service.dart';

class NeuraAIJokeEngine {
  final OpenAIService _openAIService = OpenAIService();

  Future<String> getJokeFromAI(String mood) async {
    try {
      return await _openAIService.getAIJoke(mood: mood);
    } catch (e) {
      return "I'm out of jokes for now. Try again later!";
    }
  }
}