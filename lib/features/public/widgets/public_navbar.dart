import 'package:flutter/material.dart';
import '../../../core/models/theme_config.dart';

class PublicNavbar extends StatefulWidget {
  final bool scrolled;
  final ThemeConfig themeConfig;
  final String companyName;
  final Function(String) onNavigateToSection;
  final VoidCallback onNavigateToAdmin;

  const PublicNavbar({
    super.key,
    required this.scrolled,
    required this.themeConfig,
    required this.companyName,
    required this.onNavigateToSection,
    required this.onNavigateToAdmin,
  });

  @override
  State<PublicNavbar> createState() => _PublicNavbarState();
}

class _PublicNavbarState extends State<PublicNavbar> {
  bool _mobileMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final textColor =
        widget.scrolled ? Colors.grey.shade700 : Colors.white;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: widget.scrolled ? 12 : 24,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: widget.themeConfig.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: widget.themeConfig.primaryColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.memory, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                widget.companyName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          if (!isMobile)
            Row(
              children: [
                _NavLink('Serviços', () => widget.onNavigateToSection('services'),
                    textColor, widget.themeConfig),
                const SizedBox(width: 32),
                _NavLink('Sobre', () => widget.onNavigateToSection('about'),
                    textColor, widget.themeConfig),
                const SizedBox(width: 32),
                _NavLink('Contato', () => widget.onNavigateToSection('contact'),
                    textColor, widget.themeConfig),
                const SizedBox(width: 32),
                OutlinedButton.icon(
                  onPressed: widget.onNavigateToAdmin,
                  icon: const Icon(Icons.person, size: 14),
                  label: const Text('Admin'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: textColor,
                    side: BorderSide(
                      color: widget.scrolled
                          ? Colors.grey.shade300
                          : Colors.white.withOpacity(0.2),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ],
            )
          else
            IconButton(
              icon: Icon(_mobileMenuOpen ? Icons.close : Icons.menu,
                  color: textColor),
              onPressed: () => setState(() => _mobileMenuOpen = !_mobileMenuOpen),
            ),
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;
  final ThemeConfig themeConfig;

  const _NavLink(this.label, this.onTap, this.color, this.themeConfig);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
