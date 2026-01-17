import 'package:flutter/material.dart';
import '../../../core/models/app_config.dart';
import '../../../core/models/theme_config.dart';
import 'flow_visualizer.dart';

/// Modal fullscreen para visualização do diagrama de fluxo
class FlowVisualizerModal extends StatelessWidget {
  final List<ChatbotFlowStep> flow;
  final ThemeConfig themeConfig;

  const FlowVisualizerModal({
    super.key,
    required this.flow,
    required this.themeConfig,
  });

  static Future<void> show(BuildContext context, {
    required List<ChatbotFlowStep> flow,
    required ThemeConfig themeConfig,
  }) {
    return showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) => FlowVisualizerModal(
        flow: flow,
        themeConfig: themeConfig,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: Row(
            children: [
              Icon(Icons.account_tree, color: themeConfig.primaryColor),
              const SizedBox(width: 12),
              const Text('Visualizador de Fluxo'),
            ],
          ),
          backgroundColor: Colors.white,
          foregroundColor: themeConfig.textColor,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Fechar',
          ),
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: themeConfig.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.touch_app, size: 18, color: themeConfig.primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    'Arraste para navegar • Pinça para zoom',
                    style: TextStyle(
                      fontSize: 13,
                      color: themeConfig.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: FlowVisualizer(
          flow: flow,
          themeConfig: themeConfig,
          onStepTap: (index) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Passo "${flow[index].id}" selecionado'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
      ),
    );
  }
}
