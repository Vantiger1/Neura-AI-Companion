import 'package:flutter/material.dart';
import 'dream_journal_entry.dart';
import 'neura_dream_show_player.dart';

class DreamReplayLauncherWidget extends StatelessWidget {
  final List<DreamJournalEntry> entries;

  DreamReplayLauncherWidget({required this.entries});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(Icons.auto_awesome_motion_rounded),
      label: Text("Play Dream Replay"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NeuraDreamShowPlayer(entries: entries),
          ),
        );
      },
    );
  }
}