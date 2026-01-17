import 'package:flutter/material.dart';
import '../../../../core/models/theme_config.dart';

class ChatbotHeader extends StatelessWidget {
  final ThemeConfig themeConfig;
  final VoidCallback onAddStep;
  final VoidCallback onViewDiagram;
  final bool isMobile;

  const ChatbotHeader({
    super.key,
    required this.themeConfig,
    required this.onAddStep,
    required this.onViewDiagram,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Editor de Fluxo de Conversa',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: themeConfig.textColor,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.account_tree),
                onPressed: onViewDiagram,
                tooltip: 'Visualizar Diagrama Fullscreen',
                color: themeConfig.primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Crie passos e conecte opções para guiar o usuário.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onAddStep,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Novo Passo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeConfig.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
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
        ),
        const SizedBox(width: 16),
        OutlinedButton.icon(
          onPressed: onViewDiagram,
          icon: const Icon(Icons.account_tree, size: 16),
          label: const Text('Ver Diagrama'),
          style: OutlinedButton.styleFrom(
            foregroundColor: themeConfig.primaryColor,
            side: BorderSide(color: themeConfig.primaryColor),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: onAddStep,
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Novo Passo'),
          style: ElevatedButton.styleFrom(
            backgroundColor: themeConfig.primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
