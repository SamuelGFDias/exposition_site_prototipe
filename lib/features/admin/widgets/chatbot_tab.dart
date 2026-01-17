import 'package:flutter/material.dart';
import '../../../core/models/app_config.dart';
import '../../../core/models/theme_config.dart';
import 'chatbot/chatbot_header.dart';
import 'chatbot/chatbot_info_banner.dart';
import 'chatbot/chatbot_settings.dart';
import 'chatbot/flow_step_card.dart';
import 'flow_visualizer_modal.dart';

/// Tab para configuração do Chatbot
/// 
/// Gerencia o fluxo de conversação do chatbot, permitindo criar e editar passos,
/// opções e mensagens. Inclui visualização em diagrama fullscreen.
class ChatbotTab extends StatefulWidget {
  final AppConfig initialConfig;
  final Function(AppConfig) onSave;

  const ChatbotTab({
    super.key,
    required this.initialConfig,
    required this.onSave,
  });

  @override
  State<ChatbotTab> createState() => _ChatbotTabState();
}

class _ChatbotTabState extends State<ChatbotTab> {
  late AppConfig _config;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _config = widget.initialConfig;
  }

  void _updateConfig(AppConfig newConfig) {
    setState(() {
      _config = newConfig;
      _hasChanges = true;
    });
  }

  void _handleSave() {
    widget.onSave(_config);
    setState(() {
      _hasChanges = false;
    });
  }

  // ===== FLOW STEP OPERATIONS =====

  void _addFlowStep() {
    final newId = 'step_${DateTime.now().millisecondsSinceEpoch}';
    final newFlow = [
      ..._config.chatbot.flow,
      ChatbotFlowStep(id: newId, message: 'Nova mensagem...', options: []),
    ];
    _updateConfig(
      _config.copyWith(chatbot: _config.chatbot.copyWith(flow: newFlow)),
    );
  }

  void _deleteFlowStep(int index) {
    final newFlow = List<ChatbotFlowStep>.from(_config.chatbot.flow);
    newFlow.removeAt(index);
    _updateConfig(
      _config.copyWith(chatbot: _config.chatbot.copyWith(flow: newFlow)),
    );
  }

  void _updateFlowStep(int index, ChatbotFlowStep step) {
    final newFlow = List<ChatbotFlowStep>.from(_config.chatbot.flow);
    newFlow[index] = step;
    _updateConfig(
      _config.copyWith(chatbot: _config.chatbot.copyWith(flow: newFlow)),
    );
  }

  void _moveStepUp(int index) {
    if (index <= 0) return;
    final newFlow = List<ChatbotFlowStep>.from(_config.chatbot.flow);
    final temp = newFlow[index];
    newFlow[index] = newFlow[index - 1];
    newFlow[index - 1] = temp;
    _updateConfig(
      _config.copyWith(chatbot: _config.chatbot.copyWith(flow: newFlow)),
    );
  }

  void _moveStepDown(int index) {
    if (index >= _config.chatbot.flow.length - 1) return;
    final newFlow = List<ChatbotFlowStep>.from(_config.chatbot.flow);
    final temp = newFlow[index];
    newFlow[index] = newFlow[index + 1];
    newFlow[index + 1] = temp;
    _updateConfig(
      _config.copyWith(chatbot: _config.chatbot.copyWith(flow: newFlow)),
    );
  }

  void _duplicateStep(int index) {
    final step = _config.chatbot.flow[index];
    final newId = 'step_${DateTime.now().millisecondsSinceEpoch}';
    final duplicatedStep = ChatbotFlowStep(
      id: newId,
      message: '${step.message} (cópia)',
      options: step.options
          .map((opt) => ChatbotFlowOption(label: opt.label, nextId: opt.nextId))
          .toList(),
    );
    final newFlow = List<ChatbotFlowStep>.from(_config.chatbot.flow);
    newFlow.insert(index + 1, duplicatedStep);
    _updateConfig(
      _config.copyWith(chatbot: _config.chatbot.copyWith(flow: newFlow)),
    );
  }

  // ===== OPTION OPERATIONS =====

  void _addOptionToStep(int stepIndex) {
    final step = _config.chatbot.flow[stepIndex];
    final newOptions = [
      ...step.options,
      const ChatbotFlowOption(label: 'Nova Opção', nextId: 'start'),
    ];
    _updateFlowStep(stepIndex, step.copyWith(options: newOptions));
  }

  void _deleteOption(int stepIndex, int optIndex) {
    final step = _config.chatbot.flow[stepIndex];
    final newOptions = List<ChatbotFlowOption>.from(step.options);
    newOptions.removeAt(optIndex);
    _updateFlowStep(stepIndex, step.copyWith(options: newOptions));
  }

  void _updateOption(int stepIndex, int optIndex, ChatbotFlowOption option) {
    final step = _config.chatbot.flow[stepIndex];
    final newOptions = List<ChatbotFlowOption>.from(step.options);
    newOptions[optIndex] = option;
    _updateFlowStep(stepIndex, step.copyWith(options: newOptions));
  }

  @override
  Widget build(BuildContext context) {
    final themeConfig = ThemeConfig.getPreset(_config.theme);
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Column(
      children: [
        // ==== LISTA PRINCIPAL ====
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Cabeçalho
              ChatbotHeader(
                themeConfig: themeConfig,
                isMobile: isMobile,
                onAddStep: _addFlowStep,
                onViewDiagram: () => FlowVisualizerModal.show(
                  context,
                  flow: _config.chatbot.flow,
                  themeConfig: themeConfig,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Banner informativo
              const ChatbotInfoBanner(),
              
              const SizedBox(height: 24),
              
              // Configurações do bot
              ChatbotSettings(
                config: _config,
                onBotNameChanged: (value) => _updateConfig(
                  _config.copyWith(
                    chatbot: _config.chatbot.copyWith(botName: value),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Lista de passos do fluxo
              ..._config.chatbot.flow.asMap().entries.map((entry) {
                final index = entry.key;
                final step = entry.value;
                final isStart = step.id == 'start';

                return FlowStepCard(
                  step: step,
                  stepIndex: index,
                  isStart: isStart,
                  allSteps: _config.chatbot.flow,
                  themeConfig: themeConfig,
                  isMobile: isMobile,
                  canMoveUp: index > 0,
                  canMoveDown: index < _config.chatbot.flow.length - 1,
                  onMessageChanged: (value) => _updateFlowStep(
                    index,
                    step.copyWith(message: value),
                  ),
                  onIdChanged: (value) => _updateFlowStep(
                    index,
                    step.copyWith(id: value),
                  ),
                  onAddOption: () => _addOptionToStep(index),
                  onDeleteOption: (optIndex) => _deleteOption(index, optIndex),
                  onOptionLabelChanged: (optIndex, value) {
                    final option = step.options[optIndex];
                    _updateOption(
                      index,
                      optIndex,
                      ChatbotFlowOption(label: value, nextId: option.nextId),
                    );
                  },
                  onOptionNextIdChanged: (optIndex, value) {
                    final option = step.options[optIndex];
                    _updateOption(
                      index,
                      optIndex,
                      ChatbotFlowOption(label: option.label, nextId: value),
                    );
                  },
                  onDelete: () => _deleteFlowStep(index),
                  onDuplicate: () => _duplicateStep(index),
                  onMoveUp: () => _moveStepUp(index),
                  onMoveDown: () => _moveStepDown(index),
                );
              }),
            ],
          ),
        ),
        
        // ==== BOTÃO SALVAR ====
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _hasChanges ? _handleSave : null,
              icon: const Icon(Icons.save, size: 18),
              label: const Text('Salvar Alterações'),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeConfig.primaryColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                disabledForegroundColor: Colors.grey.shade500,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
