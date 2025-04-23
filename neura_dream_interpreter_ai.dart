import 'openai_api_service.dart';

class NeuraDreamInterpreter {
  final OpenAIService _aiService = OpenAIService();

  Future<String> interpretDream(String rawTranscript) async {
    try {
      if (rawTranscript.trim().isEmpty) {
        return "I couldn't interpret an empty dream. Try recording again.";
      }

      final aiResponse = await _aiService.getDreamInsight(rawTranscript);
      return "You said: '$rawTranscript'\n\nAI Insight: $aiResponse";
    } catch (e) {
      return "I had trouble connecting to the dream interpreter. Try again later.";
    }
  }
}