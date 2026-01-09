import 'package:flutter/material.dart';

class FooterSection extends StatelessWidget {
  final String footerText;

  const FooterSection({
    super.key,
    required this.footerText,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      color: Colors.black,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: 32,
      ),
      child: isMobile
          ? Column(
              children: [
                Text(
                  footerText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 16),
                _buildLinks(),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  footerText,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade400,
                  ),
                ),
                _buildLinks(),
              ],
            ),
    );
  }

  Widget _buildLinks() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: () {},
          child: Text(
            'Termos',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
        ),
        const SizedBox(width: 16),
        TextButton(
          onPressed: () {},
          child: Text(
            'Privacidade',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
