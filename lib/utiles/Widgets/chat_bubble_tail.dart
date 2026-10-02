import 'package:flutter/material.dart';

import 'chat_bubble_clipper.dart';

class ChatBubbleWithTail extends StatelessWidget {
  final String text;
  final VoidCallback onSpeak;

  const ChatBubbleWithTail({
    super.key,
    required this.text,
    required this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
        clipper: ChatBubbleClipper(),
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.greenAccent.withOpacity(0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 1,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 10),
              IconButton(
                icon: const Icon(Icons.volume_up, size: 30, color: Colors.green),
                onPressed: onSpeak,
              ),
            ],
          ),
        ),

    );
  }
}
