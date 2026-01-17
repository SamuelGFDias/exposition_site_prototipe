import 'package:flutter/material.dart';
import '../../../../core/models/app_config.dart';
import '../../../../core/models/theme_config.dart';
import 'flow_step_option.dart';

class FlowStepCard extends StatelessWidget {
  final ChatbotFlowStep step;
  final int stepIndex;
  final bool isStart;
  final List<ChatbotFlowStep> allSteps;
  final ThemeConfig themeConfig;
  final bool isMobile;
  
  final Function(String) onMessageChanged;
  final Function(String) onIdChanged;
  final VoidCallback onAddOption;
  final Function(int) onDeleteOption;
  final Function(int, String) onOptionLabelChanged;
  final Function(int, String) onOptionNextIdChanged;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final bool canMoveUp;
  final bool canMoveDown;

  const FlowStepCard({
    super.key,
    required this.step,
    required this.stepIndex,
    required this.isStart,
    required this.allSteps,
    required this.themeConfig,
    required this.isMobile,
    required this.onMessageChanged,
    required this.onIdChanged,
    required this.onAddOption,
    required this.onDeleteOption,
    required this.onOptionLabelChanged,
    required this.onOptionNextIdChanged,
    required this.onDelete,
    required this.onDuplicate,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.canMoveUp,
    required this.canMoveDown,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isStart ? themeConfig.primaryColor : Colors.grey.shade200,
          width: isStart ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          const Divider(height: 1),
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100),
        ),
      ),
      child: Row(
        children: [
          if (isStart)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: themeConfig.primaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'INÍCIO',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          if (!isStart)
            Text(
              'Passo ${stepIndex + 1}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeConfig.textColor,
                fontSize: 14,
              ),
            ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'ID: ${step.id}',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const Spacer(),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    if (isMobile) {
      return PopupMenuButton(
        icon: const Icon(Icons.more_vert, size: 20),
        itemBuilder: (context) => [
          if (canMoveUp)
            const PopupMenuItem(
              value: 'up',
              child: Row(
                children: [
                  Icon(Icons.arrow_upward, size: 16),
                  SizedBox(width: 8),
                  Text('Mover para cima', style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
          if (canMoveDown)
            const PopupMenuItem(
              value: 'down',
              child: Row(
                children: [
                  Icon(Icons.arrow_downward, size: 16),
                  SizedBox(width: 8),
                  Text('Mover para baixo', style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
          const PopupMenuItem(
            value: 'duplicate',
            child: Row(
              children: [
                Icon(Icons.content_copy, size: 16),
                SizedBox(width: 8),
                Text('Duplicar', style: TextStyle(fontSize: 13)),
              ],
            ),
          ),
          if (!isStart)
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 16, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Excluir', style: TextStyle(fontSize: 13, color: Colors.red)),
                ],
              ),
            ),
        ],
        onSelected: (value) {
          switch (value) {
            case 'up':
              onMoveUp();
              break;
            case 'down':
              onMoveDown();
              break;
            case 'duplicate':
              onDuplicate();
              break;
            case 'delete':
              onDelete();
              break;
          }
        },
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (canMoveUp)
          IconButton(
            icon: const Icon(Icons.arrow_upward, size: 16),
            onPressed: onMoveUp,
            tooltip: 'Mover para cima',
          ),
        if (canMoveDown)
          IconButton(
            icon: const Icon(Icons.arrow_downward, size: 16),
            onPressed: onMoveDown,
            tooltip: 'Mover para baixo',
          ),
        IconButton(
          icon: const Icon(Icons.content_copy, size: 16),
          onPressed: onDuplicate,
          tooltip: 'Duplicar passo',
        ),
        if (!isStart)
          IconButton(
            icon: const Icon(Icons.delete, size: 16),
            onPressed: onDelete,
            tooltip: 'Excluir passo',
            color: Colors.red,
          ),
      ],
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isStart) ...[
            const Text(
              'ID do Passo',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: TextEditingController(text: step.id)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: step.id.length),
                ),
              onChanged: onIdChanged,
              decoration: InputDecoration(
                hintText: 'Ex: step_confirmacao',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
            ),
            const SizedBox(height: 16),
          ],
          const Text(
            'Mensagem',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: TextEditingController(text: step.message)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: step.message.length),
              ),
            onChanged: onMessageChanged,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Digite a mensagem que o bot enviará...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Opções de Resposta',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              TextButton.icon(
                onPressed: onAddOption,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Adicionar Opção', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          if (step.options.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Nenhuma opção adicionada ainda',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            )
          else
            ...step.options.asMap().entries.map((entry) {
              final optIndex = entry.key;
              final option = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FlowStepOption(
                  option: option,
                  optionIndex: optIndex,
                  allSteps: allSteps,
                  themeConfig: themeConfig,
                  isMobile: isMobile,
                  onLabelChanged: (value) => onOptionLabelChanged(optIndex, value),
                  onNextIdChanged: (value) => onOptionNextIdChanged(optIndex, value),
                  onDelete: () => onDeleteOption(optIndex),
                ),
              );
            }),
        ],
      ),
    );
  }
}
