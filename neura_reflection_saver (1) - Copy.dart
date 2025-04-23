import 'package:intl/intl.dart';
import 'dream_journal_entry.dart';

class NeuraReflectionSaver {
  Future<DreamJournalEntry> createReflectionEntry(String summary, String emotion) async {
    final now = DateTime.now();
    return DreamJournalEntry(
      timestamp: now,
      transcript: "Reflection from chat",
      emotion: emotion,
      interpretation: summary,
      dreamscapeTheme: "glowing reflection mode",
    );
  }

  String getFormattedDate(DateTime timestamp) {
    return DateFormat('yyyy-MM-dd – kk:mm').format(timestamp);
  }
}