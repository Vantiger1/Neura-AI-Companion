import 'package:flutter/material.dart';
import 'neura_humor_engine.dart';
import 'neura_joke_preferences_manager.dart';

class NeuraJokePanel extends StatefulWidget {
  final NeuraHumorEngine humorEngine;
  final NeuraJokePreferencesManager prefs;

  NeuraJokePanel({required this.humorEngine, required this.prefs});

  @override
  _NeuraJokePanelState createState() => _NeuraJokePanelState();
}

class _NeuraJokePanelState extends State<NeuraJokePanel> {
  String _lastJoke = "";

  @override
  void initState() {
    super.initState();
    widget.humorEngine.init();
  }

  Future<void> _getJoke() async {
    String joke = widget.humorEngine._jokeEngine.getJoke(cleanOnly: widget.prefs.cleanOnly);
    await widget.humorEngine._voiceEngine.speak(joke);
    setState(() {
      _lastJoke = joke;
    });
  }

  Future<void> _rate(bool liked) async {
    await widget.humorEngine.rateJoke(_lastJoke, like: liked);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(liked ? "Saved to favorites!" : "Got it, skipping this one.")),
    );
  }

  Future<void> _playFavorite() async {
    await widget.humorEngine.tellFavoriteJoke();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Need a laugh?", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _getJoke,
              icon: Icon(Icons.mood),
              label: Text("Tell Me a Joke"),
            ),
            if (_lastJoke.isNotEmpty) ...[
              SizedBox(height: 20),
              Text("Rate this joke:"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => _rate(true),
                    icon: Icon(Icons.favorite, color: Colors.pink),
                  ),
                  IconButton(
                    onPressed: () => _rate(false),
                    icon: Icon(Icons.thumb_down, color: Colors.grey),
                  ),
                ],
              ),
            ],
            SizedBox(height: 10),
            TextButton.icon(
              onPressed: _playFavorite,
              icon: Icon(Icons.star),
              label: Text("Play Favorite"),
            ),
          ],
        ),
      ),
    );
  }
}