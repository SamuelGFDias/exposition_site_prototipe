import 'package:flutter/material.dart';
import '../../../core/models/service_model.dart';
import '../../../core/models/theme_config.dart';

class ServicesSection extends StatelessWidget {
  final List<ServiceModel> services;
  final ThemeConfig themeConfig;

  const ServicesSection({
    super.key,
    required this.services,
    required this.themeConfig,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: isMobile ? 64 : 96,
      ),
      child: Column(
        children: [
          Text(
            'EXPERTISE TÉCNICA',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: themeConfig.textColor,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Soluções para cada etapa',
            style: TextStyle(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 48),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = isMobile
                  ? constraints.maxWidth
                  : (constraints.maxWidth < 900
                        ? (constraints.maxWidth - 24) / 2
                        : (constraints.maxWidth - 72) / 4);

              return Wrap(
                spacing: 24,
                runSpacing: 24,
                children: services.map((service) {
                  return SizedBox(
                    width: cardWidth,
                    child: _ServiceCard(
                      service: service,
                      themeConfig: themeConfig,
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final ServiceModel service;
  final ThemeConfig themeConfig;

  const _ServiceCard({required this.service, required this.themeConfig});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: _isHovered ? Colors.white : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ]
              : [],
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _isHovered
                    ? widget.themeConfig.primaryColor
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                widget.service.icon,
                size: 28,
                color: _isHovered ? Colors.white : widget.themeConfig.textColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.service.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade900,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Text(
              widget.service.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.6,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
