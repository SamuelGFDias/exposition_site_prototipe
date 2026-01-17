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

class _FlowVisualizerState extends State<FlowVisualizer>
    with SingleTickerProviderStateMixin {
  final Map<String, Offset> _positions = {};
  final Map<String, double> _cardHeights = {};
  final double _cardWidth = 220;
  final double _cardMinHeight = 140;
  final double _horizontalSpacing = 100;
  final double _verticalSpacing = 100;

  String? _hoveredStepId;
  late AnimationController _animationController;

  // Lane Packing: Mapa que define qual faixa cada conexão usa
  final Map<String, int> _connectionLanes = {};
  int _maxLaneCount = 0;

  @override
  void initState() {
    super.initState();
    _calculateLayout();

    // Animação para "marching ants" (fluxo animado)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FlowVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.flow != widget.flow) {
      _calculateLayout();
    }
  }

  void _calculateLayout() {
    _calculatePositions();
    _calculateLanes();
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

  // Lane Packing: Algoritmo "First Fit" para otimizar faixas
  void _calculateLanes() {
    _connectionLanes.clear();
    // Lista de faixas, cada faixa contém intervalos ocupados [min, max]
    List<List<RangeValues>> lanes = [];

    for (var step in widget.flow) {
      final fromPos = _positions[step.id];
      if (fromPos == null) continue;

      for (var i = 0; i < step.options.length; i++) {
        final option = step.options[i];
        final toPos = _positions[option.nextId];
        if (toPos == null) continue;

        final startX = fromPos.dx + _cardWidth;
        final endX = toPos.dx;

        // Verifica se precisa usar a canaleta
        final dx = endX - startX;
        bool isBackward = dx < 0;
        bool isLongJump = dx > (_cardWidth + 150);

        if (isBackward || isLongJump) {
          // Normaliza o intervalo (min sempre à esquerda)
          double minX = startX < endX ? startX : endX;
          double maxX = startX > endX ? startX : endX;

          // Adiciona margem de segurança (40px total)
          minX -= 20;
          maxX += 20;

          // Algoritmo First Fit: tenta encaixar na primeira faixa disponível
          int assignedLane = -1;

          for (int laneIdx = 0; laneIdx < lanes.length; laneIdx++) {
            bool overlap = false;
            // Verifica colisão com intervalos existentes nesta faixa
            for (var interval in lanes[laneIdx]) {
              if (minX < interval.end && maxX > interval.start) {
                overlap = true;
                break;
              }
            }

            if (!overlap) {
              assignedLane = laneIdx;
              lanes[laneIdx].add(RangeValues(minX, maxX));
              break;
            }
          }

          // Se não coube em nenhuma faixa, cria uma nova
          if (assignedLane == -1) {
            assignedLane = lanes.length;
            lanes.add([RangeValues(minX, maxX)]);
          }

          // Salva a faixa atribuída
          _connectionLanes["${step.id}_$i"] = assignedLane;
        }
      }
    }

    _maxLaneCount = lanes.length;
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

    // Calcular tamanho do canvas baseado nas posições E NA CANALETA
    double maxX = 400;
    double maxY = 400;

    // 1. Achar o limite dos cards
    double lowestCardBottom = 0;
    for (var entry in _positions.entries) {
      final pos = entry.value;
      final step = widget.flow.firstWhere((s) => s.id == entry.key);
      final cardHeight = _cardMinHeight + (step.options.length * 28.0);

      if (pos.dx + _cardWidth > maxX) maxX = pos.dx + _cardWidth + 100;

      final bottom = pos.dy + cardHeight;
      if (bottom > maxY) maxY = bottom;
      if (bottom > lowestCardBottom) lowestCardBottom = bottom;
    }

    // 2. Adicionar espaço para a canaleta de fios (Bus)
    // Usa o número de FAIXAS (otimizado) ao invés de total de conexões
    final busHeight = 40.0 + (_maxLaneCount * 12.0) + 100.0;

    // A nova altura máxima é o fundo do último card + a altura necessária para os fios
    maxY = lowestCardBottom + busHeight;

    return GestureDetector(
      // Absorve gestos de scroll do mouse
      onHorizontalDragUpdate: (_) {},
      onVerticalDragUpdate: (_) {},
      child: Listener(
        onPointerSignal: (event) {
          // Impede propagação de eventos de scroll do mouse
          return;
        },
        child: InteractiveViewer(
          boundaryMargin: const EdgeInsets.all(200),
          minScale: 0.5,
          maxScale: 2.0,
          constrained: false,
          child: SizedBox(
            width: maxX,
            height: maxY,
            child: Stack(
              children: [
                // Camada 1: Conexões (atrás)
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _FlowPainter(
                        flow: widget.flow,
                        positions: _positions,
                        cardHeights: _cardHeights,
                        cardWidth: _cardWidth,
                        themeConfig: widget.themeConfig,
                        hoveredStepId: _hoveredStepId,
                        animationValue: _animationController.value,
                        connectionLanes: _connectionLanes,
                      ),
                      size: Size(maxX, maxY),
                    );
                  },
                ),
                // Camada 2: Cards (na frente)
                ...widget.flow.map((step) {
                  final position = _positions[step.id] ?? Offset.zero;
                  final isStart = step.id == 'start';
                  final index = widget.flow.indexOf(step);

                  return Positioned(
                    left: position.dx,
                    top: position.dy,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          final currentPos = _positions[step.id] ?? Offset.zero;
                          _positions[step.id] = Offset(
                            currentPos.dx + details.delta.dx,
                            currentPos.dy + details.delta.dy,
                          );
                          // Recalcula lanes em tempo real ao arrastar
                          _calculateLanes();
                        });
                      },
                      child: MouseRegion(
                        onEnter: (_) =>
                            setState(() => _hoveredStepId = step.id),
                        onExit: (_) => setState(() => _hoveredStepId = null),
                        cursor: SystemMouseCursors.grab,
                        child: _buildStepCard(step, isStart, index),
                      ),
                    ),
                  );
                }),
              ],
            ),
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
                        Icon(
                          Icons.alt_route,
                          size: 12,
                          color: Colors.grey.shade500,
                        ),
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
                            Icon(
                              Icons.chevron_right,
                              size: 12,
                              color: widget.themeConfig.primaryColor,
                            ),
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
                            Icon(
                              Icons.arrow_forward,
                              size: 10,
                              color: Colors.grey.shade400,
                            ),
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
                        Icon(
                          Icons.check_circle,
                          size: 12,
                          color: Colors.grey.shade400,
                        ),
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
  final String? hoveredStepId;
  final double animationValue;
  final Map<String, int> connectionLanes;

  _FlowPainter({
    required this.flow,
    required this.positions,
    required this.cardHeights,
    required this.cardWidth,
    required this.themeConfig,
    this.hoveredStepId,
    required this.animationValue,
    required this.connectionLanes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Calcular o "Chão Global" (onde termina o card mais baixo da tela)
    double globalBottomY = 0;
    for (var entry in positions.entries) {
      final height = cardHeights[entry.key] ?? 140;
      final bottom = entry.value.dy + height;
      if (bottom > globalBottomY) globalBottomY = bottom;
    }

    // Cores (Red, Blue, Green, Orange, Purple)
    final wireColors = [
      const Color(0xFFFF5252),
      const Color(0xFF448AFF),
      const Color(0xFF69F0AE),
      const Color(0xFFFFAB40),
      const Color(0xFFE040FB),
    ];

    // Contador global de conexões para distribuir as "faixas" na canaleta
    int globalConnectionIndex = 0;

    for (var step in flow) {
      final fromPos = positions[step.id];
      if (fromPos == null) continue;

      final fromCardHeight = cardHeights[step.id] ?? 140;

      for (var i = 0; i < step.options.length; i++) {
        final option = step.options[i];
        final toPos = positions[option.nextId];
        if (toPos == null) continue;

        // Incrementa contador para cada fio desenhado
        globalConnectionIndex++;

        final toCardHeight = cardHeights[option.nextId] ?? 140;

        // Verificar se esta conexão é relevante (conectada ao card hover)
        final isRelevant =
            hoveredStepId == null ||
            step.id == hoveredStepId ||
            option.nextId == hoveredStepId;

        final connectionColor = isRelevant
            ? wireColors[globalConnectionIndex % wireColors.length]
            : Colors.grey.shade300;

        // --- Configuração dos Pontos ---

        // Saída distribuída verticalmente no card de origem
        final exitOffset = (i * 15.0) - ((step.options.length - 1) * 15.0 / 2);
        final start = Offset(
          fromPos.dx + cardWidth,
          fromPos.dy + (fromCardHeight / 2) + exitOffset,
        );

        final end = Offset(toPos.dx, toPos.dy + (toCardHeight / 2));

        // --- Lógica de Roteamento Inteligente ---

        final dx = end.dx - start.dx;
        final dy = end.dy - start.dy;
        const radius = 20.0;

        // Condições para usar a Canaleta Global:
        // 1. É um retorno (end está à esquerda do start)
        // 2. É um salto longo para frente (pula mais de 1 card de distância visual)
        bool isBackward = dx < 0;
        bool isLongJump = dx > (cardWidth + 150);

        final path = Path();
        path.moveTo(start.dx, start.dy);

        if (isBackward || isLongJump) {
          // --- ROTA VIA CANALETA (UNDERPASS) ---

          // Recupera qual faixa foi atribuída (Lane Packing!)
          final laneIndex = connectionLanes["${step.id}_$i"] ?? 0;

          // Calcula altura baseada na faixa (reutilizando espaço!)
          final laneOffset = 40.0 + (laneIndex * 12.0);
          final busY = globalBottomY + laneOffset;

          // Pontos de entrada e saída da canaleta
          final midXExit = start.dx + 30;
          final midXEnter = end.dx - 30;

          // 1. Sai do card e faz curva para baixo
          path.lineTo(midXExit - radius, start.dy);
          path.quadraticBezierTo(
            midXExit,
            start.dy,
            midXExit,
            start.dy + radius,
          );

          // 2. Desce até a faixa exclusiva (busY)
          path.lineTo(midXExit, busY - radius);
          path.quadraticBezierTo(midXExit, busY, midXExit - radius, busY);

          // 3. Viaja horizontalmente pela canaleta
          path.lineTo(midXEnter + radius, busY);

          // 4. Sobe da canaleta para a altura do destino
          path.quadraticBezierTo(midXEnter, busY, midXEnter, busY - radius);
          path.lineTo(midXEnter, end.dy + radius);

          // 5. Curva final para entrar no card
          path.quadraticBezierTo(midXEnter, end.dy, midXEnter + radius, end.dy);
          path.lineTo(end.dx, end.dy);
        } else {
          // --- ROTA DIRETA (Para vizinhos próximos) ---
          final midX = start.dx + (dx / 2);

          path.lineTo(midX - radius, start.dy);

          if (dy.abs() < 10) {
            path.lineTo(end.dx, end.dy);
          } else {
            final directionY = dy > 0 ? 1 : -1;
            path.quadraticBezierTo(
              midX,
              start.dy,
              midX,
              start.dy + (radius * directionY),
            );
            path.lineTo(midX, end.dy - (radius * directionY));
            path.quadraticBezierTo(midX, end.dy, midX + radius, end.dy);
            path.lineTo(end.dx, end.dy);
          }
        }

        // --- Pintura (Camadas) ---

        final strokeWidth = isRelevant ? 3.0 : 2.0;
        final shadowOpacity = isRelevant ? 0.15 : 0.05;

        // 1. Sombra (simula elevação)
        canvas.drawPath(
          path,
          Paint()
            ..color = Colors.black.withValues(alpha: shadowOpacity)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 6.0
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
        );

        // 2. Borda Branca (isolamento)
        canvas.drawPath(
          path,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth + 2.0
            ..strokeCap = StrokeCap.round,
        );

        // 3. Fio Tracejado Animado (Marching Ants)
        if (isRelevant) {
          _drawMarchingAnts(canvas, path, connectionColor, strokeWidth);
        }

        // Terminais
        _drawSolderPoint(canvas, start, connectionColor);
        _drawSolderPoint(canvas, end, connectionColor);
      }
    }
  }

  void _drawSolderPoint(Canvas canvas, Offset pos, Color color) {
    // Anel externo prateado/branco
    canvas.drawCircle(pos, 5, Paint()..color = Colors.grey.shade300);
    // Miolo colorido
    canvas.drawCircle(pos, 3, Paint()..color = color);
  }

  void _drawChipLabel(Canvas canvas, String text, Offset pos, Color color) {
    // Label estilo etiqueta de componente eletrônico
    final textPainter = TextPainter(
      text: TextSpan(
        text: text.length > 20
            ? text.substring(0, 20).toUpperCase()
            : text.toUpperCase(),
        style: TextStyle(
          color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final padding = 4.0;
    final rect = Rect.fromCenter(
      center: pos,
      width: textPainter.width + padding * 3,
      height: textPainter.height + padding * 2,
    );

    // Fundo da etiqueta (arredondado)
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      Paint()..color = color,
    );

    // Borda fina
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    textPainter.paint(
      canvas,
      Offset(rect.left + padding * 1.5, rect.top + padding),
    );
  }

  void _drawMarchingAnts(
    Canvas canvas,
    Path path,
    Color color,
    double strokeWidth,
  ) {
    // Efeito de linha tracejada animada
    final metrics = path.computeMetrics().first;
    final dashLength = 10.0;
    final dashSpace = 5.0;
    final totalLength = metrics.length;

    // Offset baseado na animação (cria movimento)
    final animOffset = animationValue * (dashLength + dashSpace);

    double distance = animOffset;

    while (distance < totalLength) {
      final nextDistance = distance + dashLength;

      if (nextDistance <= totalLength) {
        final start = metrics.getTangentForOffset(distance)?.position;
        final end = metrics.getTangentForOffset(nextDistance)?.position;

        if (start != null && end != null) {
          canvas.drawLine(
            start,
            end,
            Paint()
              ..color = color
              ..strokeWidth = strokeWidth
              ..strokeCap = StrokeCap.round,
          );
        }
      }

      distance += dashLength + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_FlowPainter oldDelegate) {
    return oldDelegate.flow != flow ||
        oldDelegate.positions != positions ||
        oldDelegate.cardHeights != cardHeights ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.hoveredStepId != hoveredStepId ||
        oldDelegate.connectionLanes != connectionLanes;
  }
}
