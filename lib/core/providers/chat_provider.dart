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
  final String? currentStepId;

  const ChatState({
    this.messages = const [],
    this.isTyping = false,
    this.isOpen = false,
    this.currentStepId,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
    bool? isOpen,
    String? currentStepId,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      isOpen: isOpen ?? this.isOpen,
      currentStepId: currentStepId ?? this.currentStepId,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  final AppConfig config;

  ChatNotifier(this.config) : super(const ChatState()) {
    _initializeChat();
  }

  void _initializeChat() {
    final startStep = config.chatbot.flow.firstWhere(
      (step) => step.id == 'start',
      orElse: () => config.chatbot.flow.first,
    );

    final welcomeMsg = ChatMessage(
      id: '1',
      text: startStep.message,
      sender: MessageSender.bot,
    );

    state = state.copyWith(messages: [welcomeMsg], currentStepId: startStep.id);
  }

  void toggleChat() {
    state = state.copyWith(isOpen: !state.isOpen);
  }

  void closeChat() {
    state = state.copyWith(isOpen: false);
  }

  Future<void> selectOption(ChatbotFlowOption option) async {
    // Adiciona a mensagem do usuário com a opção selecionada
    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: option.label,
      sender: MessageSender.user,
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isTyping: true,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    // Busca o próximo passo
    final nextStep = config.chatbot.flow.firstWhere(
      (step) => step.id == option.nextId,
      orElse: () => config.chatbot.flow.first,
    );

    final botMsg = ChatMessage(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      text: nextStep.message,
      sender: MessageSender.bot,
    );

    state = state.copyWith(
      messages: [...state.messages, botMsg],
      isTyping: false,
      currentStepId: nextStep.id,
    );
  }

  ChatbotFlowStep? getCurrentStep() {
    if (state.currentStepId == null) return null;

    try {
      return config.chatbot.flow.firstWhere(
        (step) => step.id == state.currentStepId,
      );
    } catch (e) {
      return null;
    }
  }
}
