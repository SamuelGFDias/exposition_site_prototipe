import 'package:flutter/material.dart';
import '../../../core/models/app_config.dart';
import '../../../core/models/theme_config.dart';

class FlowVisualizer extends StatefulWidget {
  final List<ChatbotFlowStep> flow;
  final ThemeConfig themeConfig;
  final Function(int) onStepTap;

  const FlowVisualizer({
    super.key,
    required this.flow,
    required this.themeConfig,
    required this.onStepTap,
  });

  @override
  State<FlowVisualizer> createState() => _FlowVisualizerState();
}

class _FlowVisualizerState extends State<FlowVisualizer> {
  final Map<String, Offset> _positions = {};
  final double _cardWidth = 220;
  final double _cardMinHeight = 140;
  final double _horizontalSpacing = 100;
  final double _verticalSpacing = 100;

  @override
  void initState() {
    super.initState();
    _calculatePositions();
  }

  @override
  void didUpdateWidget(FlowVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.flow != widget.flow) {
      _calculatePositions();
    }
  }

  void _calculatePositions() {
    _positions.clear();
    
    // Organizar em níveis (hierarquia de profundidade)
    final levels = <String, int>{};
    final visited = <String>{};
    
    void assignLevel(String id, int level) {
      if (visited.contains(id)) return;
      visited.add(id);
      
      levels[id] = level;
      
      final step = widget.flow.firstWhere(
        (s) => s.id == id,
        orElse: () => ChatbotFlowStep(id: id, message: '', options: []),
      );
      
      for (var option in step.options) {
        assignLevel(option.nextId, level + 1);
      }
    }
    
    // Começar do 'start'
    if (widget.flow.isNotEmpty) {
      assignLevel('start', 0);
      
      // Garantir que todos os passos tenham um nível
      for (var step in widget.flow) {
        if (!levels.containsKey(step.id)) {
          levels[step.id] = 0;
        }
      }
    }
    
    // Agrupar por nível
    final stepsPerLevel = <int, List<String>>{};
    for (var entry in levels.entries) {
      stepsPerLevel.putIfAbsent(entry.value, () => []).add(entry.key);
    }
    
    // Calcular posições
    for (var entry in stepsPerLevel.entries) {
      final level = entry.key;
      final steps = entry.value;
      
      // Calcular altura total necessária para este nível
      double currentY = 50.0;
      
      for (var i = 0; i < steps.length; i++) {
        final stepId = steps[i];
        final step = widget.flow.firstWhere(
          (s) => s.id == stepId,
          orElse: () => ChatbotFlowStep(id: stepId, message: '', options: []),
        );
        
        final x = 50.0 + level * (_cardWidth + _horizontalSpacing);
        _positions[stepId] = Offset(x, currentY);
        
        // Incrementar Y baseado na altura do card
        final cardHeight = _cardMinHeight + (step.options.length * 28.0);
        currentY += cardHeight + _verticalSpacing;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.flow.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_tree, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'Nenhum fluxo para visualizar',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Adicione passos para ver o diagrama',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    // Calcular tamanho do canvas baseado nas posições
    double maxX = 400;
    double maxY = 400;
    for (var entry in _positions.entries) {
      final pos = entry.value;
      final step = widget.flow.firstWhere((s) => s.id == entry.key);
      final cardHeight = _cardMinHeight + (step.options.length * 28.0);
      
      if (pos.dx + _cardWidth > maxX) maxX = pos.dx + _cardWidth + 100;
      if (pos.dy + cardHeight > maxY) maxY = pos.dy + cardHeight + 100;
    }

    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(200),
      minScale: 0.5,
      maxScale: 2.0,
      constrained: false,
      child: SizedBox(
        width: maxX,
        height: maxY,
        child: CustomPaint(
          painter: _FlowPainter(
            flow: widget.flow,
            positions: _positions,
            cardWidth: _cardWidth,
            themeConfig: widget.themeConfig,
          ),
          child: Stack(
            children: widget.flow.map((step) {
              final position = _positions[step.id] ?? Offset.zero;
              final isStart = step.id == 'start';
              final index = widget.flow.indexOf(step);

              return Positioned(
                left: position.dx,
                top: position.dy,
                child: _buildStepCard(step, isStart, index),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildStepCard(ChatbotFlowStep step, bool isStart, int index) {
    final hasOptions = step.options.isNotEmpty;
    
    return GestureDetector(
      onTap: () => widget.onStepTap(index),
      child: Container(
        width: _cardWidth,
        constraints: BoxConstraints(
          minHeight: _cardMinHeight,
          maxHeight: _cardMinHeight + (step.options.length * 28.0),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isStart 
                ? Colors.green.shade400 
                : widget.themeConfig.primaryColor.withValues(alpha: 0.3),
            width: isStart ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isStart 
                    ? Colors.green.shade50 
                    : widget.themeConfig.bgLightColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isStart ? Icons.play_circle : Icons.chat_bubble_outline,
                    size: 16,
                    color: isStart 
                        ? Colors.green.shade700 
                        : widget.themeConfig.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      step.id,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                        color: isStart 
                            ? Colors.green.shade700 
                            : widget.themeConfig.textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    step.message,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  const Divider(height: 8),
                  if (hasOptions) ...[
                    Row(
                      children: [
                        Icon(Icons.alt_route, 
                            size: 12, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          'Opções:',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ...step.options.map((option) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Icon(Icons.chevron_right, 
                                size: 12, 
                                color: widget.themeConfig.primaryColor),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                option.label,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.arrow_forward, 
                                size: 10, 
                                color: Colors.grey.shade400),
                            const SizedBox(width: 4),
                            Text(
                              option.nextId,
                              style: TextStyle(
                                fontSize: 9,
                                fontFamily: 'monospace',
                                color: widget.themeConfig.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    }),
                  ] else
                    Row(
                      children: [
                        Icon(Icons.check_circle, 
                            size: 12, color: Colors.grey.shade400),
                        const SizedBox(width: 4),
                        Text(
                          'Fim do fluxo',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlowPainter extends CustomPainter {
  final List<ChatbotFlowStep> flow;
  final Map<String, Offset> positions;
  final double cardWidth;
  final ThemeConfig themeConfig;

  _FlowPainter({
    required this.flow,
    required this.positions,
    required this.cardWidth,
    required this.themeConfig,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Desenhar conexões
    for (var step in flow) {
      final fromPos = positions[step.id];
      if (fromPos == null) continue;

      final cardHeight = 140 + (step.options.length * 28.0);
      final fromCenter = Offset(
        fromPos.dx + cardWidth / 2,
        fromPos.dy + cardHeight,
      );

      for (var i = 0; i < step.options.length; i++) {
        final option = step.options[i];
        final toPos = positions[option.nextId];
        if (toPos == null) continue;

        final toCenter = Offset(
          toPos.dx + cardWidth / 2,
          toPos.dy,
        );

        // Cor diferente para cada conexão baseada no índice
        final connectionColor = i % 3 == 0 
            ? themeConfig.primaryColor.withValues(alpha: 0.5)
            : i % 3 == 1
                ? Colors.purple.withValues(alpha: 0.5)
                : Colors.teal.withValues(alpha: 0.5);
        
        final connectionPaint = Paint()
          ..color = connectionColor
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke;

        // Desenhar linha curva
        final path = Path();
        path.moveTo(fromCenter.dx, fromCenter.dy);

        final controlPoint1 = Offset(
          fromCenter.dx,
          fromCenter.dy + (toCenter.dy - fromCenter.dy) / 3,
        );
        final controlPoint2 = Offset(
          toCenter.dx,
          toCenter.dy - (toCenter.dy - fromCenter.dy) / 3,
        );

        path.cubicTo(
          controlPoint1.dx, controlPoint1.dy,
          controlPoint2.dx, controlPoint2.dy,
          toCenter.dx, toCenter.dy,
        );

        canvas.drawPath(path, connectionPaint);

        // Desenhar seta
        final arrowPaintColored = Paint()
          ..color = connectionColor
          ..style = PaintingStyle.fill;
        _drawArrow(canvas, toCenter, arrowPaintColored);

        // Desenhar label da opção
        final labelPos = Offset(
          (fromCenter.dx + toCenter.dx) / 2 + 5,
          (fromCenter.dy + toCenter.dy) / 2,
        );
        
        _drawLabel(
          canvas, 
          option.label, 
          labelPos,
          i,
          connectionColor,
        );
      }
    }
  }

  void _drawArrow(Canvas canvas, Offset tip, Paint paint) {
    const arrowSize = 8.0;
    final path = Path();
    path.moveTo(tip.dx, tip.dy);
    path.lineTo(tip.dx - arrowSize / 2, tip.dy - arrowSize);
    path.lineTo(tip.dx + arrowSize / 2, tip.dy - arrowSize);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawLabel(Canvas canvas, String text, Offset position, int index, Color color) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text.length > 20 ? '${text.substring(0, 20)}...' : text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.white.withValues(alpha: 0.95),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    
    // Offset adicional para múltiplas opções
    final yOffset = index * 15.0;
    
    textPainter.paint(
      canvas, 
      Offset(position.dx, position.dy + yOffset),
    );
  }

  @override
  bool shouldRepaint(_FlowPainter oldDelegate) {
    return oldDelegate.flow != flow || 
           oldDelegate.positions != positions;
  }
}
