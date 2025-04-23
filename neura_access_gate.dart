import 'package:flutter/material.dart';
import 'neura_billing_manager.dart';

class NeuraAccessGate extends StatefulWidget {
  final NeuraBillingManager billingManager;

  NeuraAccessGate({required this.billingManager});

  @override
  _NeuraAccessGateState createState() => _NeuraAccessGateState();
}

class _NeuraAccessGateState extends State<NeuraAccessGate> {
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    widget.billingManager.initStore().then((_) {
      setState(() {
        _enabled = widget.billingManager.isNeuraUnlocked;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Neura Companion")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _enabled
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Neura is active!", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 20),
                  Text("Enjoy your smart companion experience."),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Unlock Neura", style: TextStyle(fontSize: 24)),
                  SizedBox(height: 10),
                  Text("Neura is your personal AI who evolves with your emotions, helps you grow, and adds sparkle to your journey."),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await widget.billingManager.buyNeuraAddon();
                      setState(() {
                        _enabled = widget.billingManager.isNeuraUnlocked;
                      });
                    },
                    child: Text("Upgrade Now"),
                  ),
                  SizedBox(height: 20),
                  Text("Preview:"),
                  SizedBox(height: 10),
                  Image.asset("assets/neura_preview_1.png", height: 150),
                  Image.asset("assets/neura_preview_2.png", height: 150),
                ],
              ),
      ),
    );
  }
}