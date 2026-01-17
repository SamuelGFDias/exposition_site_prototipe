import 'package:flutter/material.dart';
import '../../../../core/models/app_config.dart';
import '../../../../core/models/theme_config.dart';

class FlowStepOption extends StatelessWidget {
  final ChatbotFlowOption option;
  final int optionIndex;
  final List<ChatbotFlowStep> allSteps;
  final ThemeConfig themeConfig;
  final Function(String) onLabelChanged;
  final Function(String) onNextIdChanged;
  final VoidCallback onDelete;
  final bool isMobile;

  const FlowStepOption({
    super.key,
    required this.option,
    required this.optionIndex,
    required this.allSteps,
    required this.themeConfig,
    required this.onLabelChanged,
    required this.onNextIdChanged,
    required this.onDelete,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Opção ${optionIndex + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: themeConfig.textColor,
                    fontSize: 12,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 18),
                onPressed: onDelete,
                tooltip: 'Remover opção',
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildLabelField(),
          const SizedBox(height: 12),
          _buildNextIdDropdown(),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Texto do Botão',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 6),
              _buildLabelField(),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Próximo Passo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 6),
              _buildNextIdDropdown(),
            ],
          ),
        ),
        const Spacer(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: themeConfig.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '#${optionIndex + 1}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: themeConfig.primaryColor,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 18),
              onPressed: onDelete,
              tooltip: 'Remover opção',
              color: Colors.red,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLabelField() {
    return TextField(
      controller: TextEditingController(text: option.label)
        ..selection = TextSelection.fromPosition(
          TextPosition(offset: option.label.length),
        ),
      onChanged: onLabelChanged,
      decoration: InputDecoration(
        hintText: 'Ex: Sim, Não, Continuar...',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
      style: const TextStyle(fontSize: 13),
    );
  }

  Widget _buildNextIdDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: option.nextId,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
      items: allSteps.map((step) {
        return DropdownMenuItem(
          value: step.id,
          child: Text(
            step.id == 'start' ? '⭐ Início' : step.id,
            style: const TextStyle(fontSize: 13),
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) onNextIdChanged(value);
      },
    );
  }
}
