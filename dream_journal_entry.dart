class DreamJournalEntry {
  final DateTime timestamp;
  final String transcript;
  final String emotion;
  final String interpretation;
  final String dreamscapeTheme;

  DreamJournalEntry({
    required this.timestamp,
    required this.transcript,
    required this.emotion,
    required this.interpretation,
    required this.dreamscapeTheme,
  });

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'transcript': transcript,
        'emotion': emotion,
        'interpretation': interpretation,
        'dreamscapeTheme': dreamscapeTheme,
      };

  static DreamJournalEntry fromJson(Map<String, dynamic> json) {
    return DreamJournalEntry(
      timestamp: DateTime.parse(json['timestamp']),
      transcript: json['transcript'],
      emotion: json['emotion'],
      interpretation: json['interpretation'],
      dreamscapeTheme: json['dreamscapeTheme'],
    );
  }

  String summary() {
    return "Dream on ${timestamp.toLocal().toString().split(' ')[0]}:\n"
        "- Mood: $emotion\n"
        "- Summary: $interpretation\n"
        "- Visual Theme: $dreamscapeTheme";
  }
}