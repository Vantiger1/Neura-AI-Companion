import 'package:flutter/material.dart';
import 'openai_api_service.dart';
import 'package:flutter_tts/flutter_tts.dart';

class NeuraChatScreen extends StatefulWidget {
  @override
  _NeuraChatScreenState createState() => _NeuraChatScreenState();
}

class _NeuraChatScreenState extends State<NeuraChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final OpenAIService _aiService = OpenAIService();
  final FlutterTts _tts = FlutterTts();
  bool _loading = false;

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _loading = true;
    });
    _controller.clear();

    final response = await _aiService.getDreamInsight(text); // simple use of GPT
    await _tts.speak(response);

    setState(() {
      _messages.add({'role': 'neura', 'content': response});
      _loading = false;
    });
  }

  Widget _buildMessage(Map<String, String> message) {
    final isUser = message['role'] == 'user';
    return Container(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUser ? Colors.deepPurpleAccent : Colors.cyan.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message['content'] ?? '',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(title: Text("Chat with Neura")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildMessage(_messages[index]),
            ),
          ),
          if (_loading) Padding(
            padding: const EdgeInsets.all(10.0),
            child: CircularProgressIndicator(),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Ask me anything...",
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.cyanAccent),
                  onPressed: _sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}