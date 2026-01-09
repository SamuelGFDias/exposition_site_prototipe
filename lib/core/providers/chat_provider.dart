import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_message.dart';
import '../models/app_config.dart';
import 'config_provider.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final config = ref.watch(appConfigProvider);
  return ChatNotifier(config);
});

class ChatState {
  final List<ChatMessage> messages;
  final bool isTyping;
  final bool isOpen;

  const ChatState({
    this.messages = const [],
    this.isTyping = false,
    this.isOpen = false,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
    bool? isOpen,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      isOpen: isOpen ?? this.isOpen,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  final AppConfig config;

  ChatNotifier(this.config) : super(const ChatState()) {
    _initializeChat();
  }

  void _initializeChat() {
    final welcomeMsg = ChatMessage(
      id: '1',
      text: config.chatbot.welcomeMessage,
      sender: MessageSender.bot,
    );
    state = state.copyWith(messages: [welcomeMsg]);
  }

  void toggleChat() {
    state = state.copyWith(isOpen: !state.isOpen);
  }

  void closeChat() {
    state = state.copyWith(isOpen: false);
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      sender: MessageSender.user,
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isTyping: true,
    );

    await Future.delayed(const Duration(milliseconds: 1200));

    final response = _getResponse(text);
    final botMsg = ChatMessage(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      text: response,
      sender: MessageSender.bot,
    );

    state = state.copyWith(
      messages: [...state.messages, botMsg],
      isTyping: false,
    );
  }

  String _getResponse(String input) {
    final lowerInput = input.toLowerCase();

    for (final faq in config.chatbot.faq) {
      for (final keyword in faq.keywords) {
        if (lowerInput.contains(keyword.toLowerCase())) {
          return faq.answer;
        }
      }
    }

    return 'Posso ajudar com mais alguma informação? Entre em contato pelo nosso telefone.';
  }
}
