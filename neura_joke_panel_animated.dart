import 'package:flutter/material.dart';
import 'neura_humor_engine.dart';
import 'neura_joke_preferences_manager.dart';
import 'neura_face_animator.dart';

class NeuraJokePanelAnimated extends StatefulWidget {
  final NeuraHumorEngine humorEngine;
  final NeuraJokePreferencesManager prefs;

  NeuraJokePanelAnimated({required this.humorEngine, required this.prefs});

  @override
  _NeuraJokePanelAnimatedState createState() => _NeuraJokePanelAnimatedState();
}

class _NeuraJokePanelAnimatedState extends State<NeuraJokePanelAnimated> {
  String _lastJoke = "";
  bool _reacting = false;
  bool _happy = true;

  @override
  void initState() {
    super.initState();
    widget.humorEngine.init();
  }

  Future<void> _getJoke() async {
    setState(() {
      _reacting = true;
      _happy = true;
    });

    final joke = widget.humorEngine._jokeEngine.getJoke(cleanOnly: widget.prefs.cleanOnly);
    await widget.humorEngine._voiceEngine.speak(joke);

    setState(() {
      _lastJoke = joke;
      _reacting = false;
    });
  }

  Future<void> _rate(bool liked) async {
    await widget.humorEngine.rateJoke(_lastJoke, like: liked);
    setState(() {
      _happy = liked;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(liked ? "Saved to favorites!" : "Got it, skipping this one.")),
    );
  }

  Future<void> _playFavorite() async {
    await widget.humorEngine.tellFavoriteJoke();
    setState(() {
      _reacting = true;
      _happy = true;
    });
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _reacting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NeuraFaceAnimator(reacting: _reacting, happy: _happy),
            SizedBox(height: 20),
            Text("Need a laugh?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _getJoke,
              icon: Icon(Icons.mood),
              label: Text("Tell Me a Joke"),
            ),
            if (_lastJoke.isNotEmpty) ...[
              SizedBox(height: 10),
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