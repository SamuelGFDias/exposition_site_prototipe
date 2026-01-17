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
  final Map<String, double> _cardHeights = {};
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
    _cardHeights.clear();
    
    // Calcular alturas dos cards
    for (var step in widget.flow) {
      _cardHeights[step.id] = _cardMinHeight + (step.options.length * 28.0);
    }
    
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
            cardHeights: _cardHeights,
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
  final Map<String, double> cardHeights;
  final double cardWidth;
  final ThemeConfig themeConfig;

  _FlowPainter({
    required this.flow,
    required this.positions,
    required this.cardHeights,
    required this.cardWidth,
    required this.themeConfig,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Desenhar conexões
    for (var step in flow) {
      final fromPos = positions[step.id];
      if (fromPos == null) continue;

      final fromCardHeight = cardHeights[step.id] ?? 140;
      
      for (var i = 0; i < step.options.length; i++) {
        final option = step.options[i];
        final toPos = positions[option.nextId];
        if (toPos == null) continue;

        final toCardHeight = cardHeights[option.nextId] ?? 140;

        // Ponto de saída: Centro-Direita do card de origem
        final fromPoint = Offset(
          fromPos.dx + cardWidth,
          fromPos.dy + (fromCardHeight / 2),
        );

        // Ponto de chegada: Centro-Esquerda do card de destino
        final toPoint = Offset(
          toPos.dx,
          toPos.dy + (toCardHeight / 2),
        );

        // Cor diferente para cada conexão baseada no índice
        final connectionColor = i % 3 == 0 
            ? themeConfig.primaryColor.withValues(alpha: 0.6)
            : i % 3 == 1
                ? Colors.purple.withValues(alpha: 0.6)
                : Colors.teal.withValues(alpha: 0.6);
        
        final connectionPaint = Paint()
          ..color = connectionColor
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke;

        // Desenhar linha curva horizontal (curva de Bézier cúbica)
        final path = Path();
        path.moveTo(fromPoint.dx, fromPoint.dy);

        // Pontos de controle para curva horizontal suave (forma de "S" deitado)
        final distanceX = toPoint.dx - fromPoint.dx;
        final controlOffset = distanceX.abs() / 2;

        final controlPoint1 = Offset(
          fromPoint.dx + controlOffset,
          fromPoint.dy,
        );
        
        final controlPoint2 = Offset(
          toPoint.dx - controlOffset,
          toPoint.dy,
        );

        path.cubicTo(
          controlPoint1.dx, controlPoint1.dy,
          controlPoint2.dx, controlPoint2.dy,
          toPoint.dx, toPoint.dy,
        );

        canvas.drawPath(path, connectionPaint);

        // Desenhar seta no destino (apontando para a esquerda)
        final arrowPaintColored = Paint()
          ..color = connectionColor
          ..style = PaintingStyle.fill;
        _drawHorizontalArrow(canvas, toPoint, arrowPaintColored);

        // Desenhar label da opção com fundo
        final labelPos = _calculateLabelPosition(fromPoint, toPoint, i, step.options.length);
        _drawLabelWithBackground(
          canvas, 
          option.label, 
          labelPos,
          connectionColor,
        );
      }
    }
  }

  // Calcular posição inteligente para o label
  Offset _calculateLabelPosition(Offset from, Offset to, int index, int totalOptions) {
    // Posição base: 40% do caminho (um pouco mais perto da origem)
    final baseX = from.dx + (to.dx - from.dx) * 0.4;
    final baseY = from.dy + (to.dy - from.dy) * 0.4;
    
    // Se múltiplas opções, espaçar verticalmente
    final yOffset = (index - (totalOptions - 1) / 2) * 20;
    
    return Offset(baseX, baseY + yOffset);
  }

  void _drawHorizontalArrow(Canvas canvas, Offset tip, Paint paint) {
    const arrowSize = 10.0;
    final path = Path();
    
    // Seta apontando para a esquerda
    path.moveTo(tip.dx, tip.dy);
    path.lineTo(tip.dx - arrowSize, tip.dy - arrowSize / 2);
    path.lineTo(tip.dx - arrowSize, tip.dy + arrowSize / 2);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  void _drawLabelWithBackground(Canvas canvas, String text, Offset position, Color color) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text.length > 18 ? '${text.substring(0, 18)}...' : text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    
    // Desenhar fundo branco arredondado
    final padding = 4.0;
    final bgRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        position.dx - padding,
        position.dy - padding,
        textPainter.width + padding * 2,
        textPainter.height + padding * 2,
      ),
      const Radius.circular(4),
    );
    
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.95)
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(bgRect, bgPaint);
    
    // Borda do fundo
    final borderPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    canvas.drawRRect(bgRect, borderPaint);
    
    // Desenhar texto
    textPainter.paint(canvas, position);
  }

  @override
  bool shouldRepaint(_FlowPainter oldDelegate) {
    return oldDelegate.flow != flow || 
           oldDelegate.positions != positions ||
           oldDelegate.cardHeights != cardHeights;
  }
}
