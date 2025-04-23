import 'package:flutter/material.dart';
import 'neura_monthly_dream_replay.dart';
import 'dream_journal_entry.dart';

class NeuraDreamShowPlayer extends StatefulWidget {
  final List<DreamJournalEntry> entries;

  NeuraDreamShowPlayer({required this.entries});

  @override
  _NeuraDreamShowPlayerState createState() => _NeuraDreamShowPlayerState();
}

class _NeuraDreamShowPlayerState extends State<NeuraDreamShowPlayer>
    with TickerProviderStateMixin {
  late final NeuraDreamReplayBuilder builder;
  late String mood;
  late String visualCue;
  late AnimationController _controller;
  late Animation<Color?> _bgColor;

  @override
  void initState() {
    super.initState();
    builder = NeuraDreamReplayBuilder();
    mood = builder.buildMonthlyNarrative(widget.entries).contains("happy")
        ? "happy"
        : builder.buildMonthlyNarrative(widget.entries).contains("anxious")
            ? "anxious"
            : builder.buildMonthlyNarrative(widget.entries).contains("sad")
                ? "sad"
                : builder.buildMonthlyNarrative(widget.entries).contains("focused")
                    ? "focused"
                    : "calm";
    visualCue = builder.pickMoodBasedVisualCue(mood);

    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _bgColor = ColorTween(
      begin: Colors.deepPurple.shade700,
      end: Colors.cyanAccent.shade100,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _animatedScene(String cue) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.nights_stay_rounded, size: 80, color: Colors.white),
          SizedBox(height: 20),
          Text(
            cue,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bgColor,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _bgColor.value,
          body: SafeArea(
            child: Stack(
              children: [
                _animatedScene(visualCue),
                Positioned(
                  top: 40,
                  right: 20,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.close),
                    label: Text("Exit"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}