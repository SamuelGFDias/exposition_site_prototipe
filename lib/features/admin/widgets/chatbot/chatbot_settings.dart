import 'package:flutter/material.dart';
import '../../../../core/models/app_config.dart';

class ChatbotSettings extends StatelessWidget {
  final AppConfig config;
  final Function(String) onBotNameChanged;

  const ChatbotSettings({
    super.key,
    required this.config,
    required this.onBotNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nome do Robô',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: config.chatbot.botName)
            ..selection = TextSelection.fromPosition(
              TextPosition(offset: config.chatbot.botName.length),
            ),
          onChanged: onBotNameChanged,
          maxLines: 1,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
