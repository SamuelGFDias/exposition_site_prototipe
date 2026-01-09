import 'package:flutter/material.dart';
import '../../../core/models/app_config.dart';
import '../../../core/models/theme_config.dart';

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

  void _addFlowStep() {
    final newId = 'step_${DateTime.now().millisecondsSinceEpoch}';
    final newFlow = [
      ..._config.chatbot.flow,
      ChatbotFlowStep(
        id: newId,
        message: 'Nova mensagem...',
        options: [],
      ),
    ];
    _updateConfig(_config.copyWith(
      chatbot: _config.chatbot.copyWith(flow: newFlow),
    ));
  }

  void _removeFlowStep(int index) {
    final newFlow = List<ChatbotFlowStep>.from(_config.chatbot.flow);
    newFlow.removeAt(index);
    _updateConfig(_config.copyWith(
      chatbot: _config.chatbot.copyWith(flow: newFlow),
    ));
  }

  void _updateFlowStep(int index, ChatbotFlowStep step) {
    final newFlow = List<ChatbotFlowStep>.from(_config.chatbot.flow);
    newFlow[index] = step;
    _updateConfig(_config.copyWith(
      chatbot: _config.chatbot.copyWith(flow: newFlow),
    ));
  }

  void _addOptionToStep(int stepIndex) {
    final step = _config.chatbot.flow[stepIndex];
    final newOptions = [
      ...step.options,
      const ChatbotFlowOption(label: 'Nova Opção', nextId: 'start'),
    ];
    _updateFlowStep(stepIndex, step.copyWith(options: newOptions));
  }

  void _removeOption(int stepIndex, int optIndex) {
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

  void _moveStepUp(int index) {
    if (index <= 0) return;
    final newFlow = List<ChatbotFlowStep>.from(_config.chatbot.flow);
    final temp = newFlow[index];
    newFlow[index] = newFlow[index - 1];
    newFlow[index - 1] = temp;
    _updateConfig(_config.copyWith(
      chatbot: _config.chatbot.copyWith(flow: newFlow),
    ));
  }

  void _moveStepDown(int index) {
    if (index >= _config.chatbot.flow.length - 1) return;
    final newFlow = List<ChatbotFlowStep>.from(_config.chatbot.flow);
    final temp = newFlow[index];
    newFlow[index] = newFlow[index + 1];
    newFlow[index + 1] = temp;
    _updateConfig(_config.copyWith(
      chatbot: _config.chatbot.copyWith(flow: newFlow),
    ));
  }

  void _duplicateStep(int index) {
    final step = _config.chatbot.flow[index];
    final newId = 'step_${DateTime.now().millisecondsSinceEpoch}';
    final duplicatedStep = ChatbotFlowStep(
      id: newId,
      message: '${step.message} (cópia)',
      options: step.options.map((opt) => ChatbotFlowOption(
        label: opt.label,
        nextId: opt.nextId,
      )).toList(),
    );
    final newFlow = List<ChatbotFlowStep>.from(_config.chatbot.flow);
    newFlow.insert(index + 1, duplicatedStep);
    _updateConfig(_config.copyWith(
      chatbot: _config.chatbot.copyWith(flow: newFlow),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final themeConfig = ThemeConfig.getPreset(_config.theme);

    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Editor de Fluxo de Conversa',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: themeConfig.textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Crie passos e conecte opções para guiar o usuário.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: _addFlowStep,
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Novo Passo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeConfig.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const Divider(height: 32),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade50,
                  border: Border.all(color: Colors.yellow.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.yellow.shade700, size: 18),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dica Importante:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow.shade800,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'O fluxo sempre começa pelo passo com ID "start". Certifique-se de que ele exista. Para conectar os passos, use o ID de destino nas opções.',
                            style: TextStyle(
                              color: Colors.yellow.shade800,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                label: 'Nome do Robô',
                value: _config.chatbot.botName,
                onChanged: (value) => _updateConfig(
                  _config.copyWith(
                    chatbot: _config.chatbot.copyWith(botName: value),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ..._config.chatbot.flow.asMap().entries.map((entry) {
                final index = entry.key;
                final step = entry.value;
                final isStart = step.id == 'start';

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade100),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isStart
                                    ? Colors.green.shade100
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'ID: ${step.id}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                  color: isStart
                                      ? Colors.green.shade700
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ),
                            if (isStart) ...[
                              const SizedBox(width: 8),
                              Text(
                                '(Início)',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade600,
                                ),
                              ),
                            ],
                            const Spacer(),
                            // Controles de reordenação e ações
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Setas para mover
                                IconButton(
                                  icon: const Icon(Icons.arrow_upward, size: 16),
                                  onPressed: index == 0 ? null : () => _moveStepUp(index),
                                  color: themeConfig.textColor,
                                  disabledColor: Colors.grey.shade300,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                  tooltip: 'Mover para cima',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.arrow_downward, size: 16),
                                  onPressed: index == _config.chatbot.flow.length - 1 
                                      ? null 
                                      : () => _moveStepDown(index),
                                  color: themeConfig.textColor,
                                  disabledColor: Colors.grey.shade300,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                  tooltip: 'Mover para baixo',
                                ),
                                const SizedBox(width: 4),
                                Container(
                                  width: 1,
                                  height: 20,
                                  color: Colors.grey.shade200,
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                ),
                                // Duplicar
                                IconButton(
                                  icon: const Icon(Icons.content_copy, size: 16),
                                  onPressed: () => _duplicateStep(index),
                                  color: Colors.blue.shade600,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                  tooltip: 'Duplicar passo',
                                ),
                                // Deletar
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 18),
                                  onPressed: isStart ? null : () => _removeFlowStep(index),
                                  color: Colors.red.shade400,
                                  disabledColor: Colors.grey.shade300,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                  tooltip: isStart ? 'Não pode deletar o passo inicial' : 'Deletar passo',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: _buildTextField(
                                    label: 'ID do Passo',
                                    value: step.id,
                                    onChanged: (value) => _updateFlowStep(
                                      index,
                                      step.copyWith(id: value),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 2,
                                  child: _buildTextField(
                                    label: 'Mensagem do Bot',
                                    value: step.message,
                                    onChanged: (value) => _updateFlowStep(
                                      index,
                                      step.copyWith(message: value),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'OPÇÕES DE RESPOSTA (BOTÕES)',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () => _addOptionToStep(index),
                                        child: const Text(
                                          '+ Add Opção',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (step.options.isEmpty)
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8),
                                      child: Text(
                                        'Sem opções (Fim do fluxo ou aguardando config)',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                  else
                                    ...step.options
                                        .asMap()
                                        .entries
                                        .map((optEntry) {
                                      final optIndex = optEntry.key;
                                      final option = optEntry.value;

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Row(
                                          children: [
                                            Icon(Icons.subdirectory_arrow_right,
                                                size: 14,
                                                color: Colors.grey.shade300),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: TextField(
                                                controller:
                                                    TextEditingController(
                                                        text: option.label)
                                                      ..selection =
                                                          TextSelection.collapsed(
                                                              offset: option
                                                                  .label.length),
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'Texto do Botão',
                                                  border: OutlineInputBorder(),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 8),
                                                  isDense: true,
                                                ),
                                                style: const TextStyle(
                                                    fontSize: 12),
                                                onChanged: (value) =>
                                                    _updateOption(
                                                  index,
                                                  optIndex,
                                                  option.copyWith(
                                                      label: value),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Text(
                                              '→',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey),
                                            ),
                                            const SizedBox(width: 8),
                                            SizedBox(
                                              width: 120,
                                              child: TextField(
                                                controller:
                                                    TextEditingController(
                                                        text: option.nextId)
                                                      ..selection =
                                                          TextSelection.collapsed(
                                                              offset: option
                                                                  .nextId
                                                                  .length),
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'ID Destino',
                                                  border: OutlineInputBorder(),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 8),
                                                  isDense: true,
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'monospace',
                                                ),
                                                onChanged: (value) =>
                                                    _updateOption(
                                                  index,
                                                  optIndex,
                                                  option.copyWith(
                                                      nextId: value),
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.close,
                                                  size: 14),
                                              onPressed: () =>
                                                  _removeOption(index, optIndex),
                                              color: Colors.grey.shade400,
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
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

  Widget _buildTextField({
    required String label,
    required String value,
    required Function(String) onChanged,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: value)
            ..selection = TextSelection.collapsed(offset: value.length),
          onChanged: onChanged,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
