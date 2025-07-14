import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dream_journal_entry.dart';

Future<List<DreamJournalEntry>> loadDreamTestEntries() async {
  final String jsonData = await rootBundle.loadString('assets/neura_dream_test_entries.json');
  final List<dynamic> data = json.decode(jsonData);
  return data.map((e) => DreamJournalEntry.fromJson(e)).toList();
}