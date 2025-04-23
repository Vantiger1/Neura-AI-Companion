import 'dart:math';

class NeuraJokeEngine {
  final List<String> cleanJokes = [
    "Why don’t skeletons fight each other? They don’t have the guts.",
    "Why did the scarecrow win an award? Because he was outstanding in his field!",
    "Why can't your nose be 12 inches long? Because then it would be a foot!",
    "What did one wall say to the other? I'll meet you at the corner!",
    "Why did the math book look sad? It had too many problems."
  ];

  final List<String> spicyJokes = [
    "Why don’t oysters donate to charity? Because they’re shellfish.",
    "I asked the librarian if they had any books on paranoia… she whispered, 'They're right behind you.'",
    "They say money talks, but mine just waves goodbye.",
    "I told my wife she should embrace her mistakes… she hugged me.",
    "Why do cows wear bells? Because their horns don’t work!"
  ];

  String getJoke({bool cleanOnly = true}) {
    final rand = Random();
    final jokes = cleanOnly ? cleanJokes : cleanJokes + spicyJokes;
    return jokes[rand.nextInt(jokes.length)];
  }
}