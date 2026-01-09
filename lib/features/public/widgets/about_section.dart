import 'package:flutter/material.dart';
import '../../../core/models/theme_config.dart';

class AboutSection extends StatelessWidget {
  final String aboutText;
  final ThemeConfig themeConfig;

  const AboutSection({
    super.key,
    required this.aboutText,
    required this.themeConfig,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      color: themeConfig.bgLightColor,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: isMobile ? 64 : 96,
      ),
      child: isMobile
          ? Column(
              children: [
                _buildImage(),
                const SizedBox(height: 32),
                _buildContent(isMobile),
              ],
            )
          : Row(
              children: [
                Expanded(child: _buildImage()),
                const SizedBox(width: 64),
                Expanded(child: _buildContent(isMobile)),
              ],
            ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        'https://images.unsplash.com/photo-1553877616-15281dec3db4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
        fit: BoxFit.cover,
        height: 400,
        errorBuilder: (_, __, ___) => Container(
          height: 400,
          color: Colors.grey.shade300,
        ),
      ),
    );
  }

  Widget _buildContent(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sobre Nós',
          style: TextStyle(
            fontSize: isMobile ? 28 : 36,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade900,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          aboutText,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade700,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 32),
        ...['Atendimento personalizado', 'Tecnologias de ponta', 
            'Redução de custos', 'Segurança máxima'].map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: themeConfig.textColor, size: 20),
                const SizedBox(width: 12),
                Text(
                  item,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
