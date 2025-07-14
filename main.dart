import 'package:flutter/material.dart';
import 'neura/neura_manager.dart';
import 'neura/neura_avatar.dart';
import 'neura/neura_joke_panel_animated.dart';
import 'neura/neura_humor_engine.dart';
import 'neura/neura_joke_preferences_manager.dart';

void main() {
  runApp(NeuraCompanionTestApp());
}

class NeuraCompanionTestApp extends StatefulWidget {
  @override
  _NeuraCompanionTestAppState createState() => _NeuraCompanionTestAppState();
}

class _NeuraCompanionTestAppState extends State<NeuraCompanionTestApp> {
  final NeuraManager manager = NeuraManager();
  final NeuraHumorEngine humorEngine = NeuraHumorEngine();
  final NeuraJokePreferencesManager prefs = NeuraJokePreferencesManager();

  @override
  void initState() {
    super.initState();
    manager.init();
    prefs.loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neura Companion Test',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(title: Text("Neura Companion")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NeuraAvatar(glowColor: Colors.purpleAccent),
            SizedBox(height: 20),
            NeuraJokePanelAnimated(humorEngine: humorEngine, prefs: prefs),
          ],
        ),
      ),
    );
  }
}