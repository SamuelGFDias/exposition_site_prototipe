import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/theme_config.dart';
import '../../../core/providers/config_provider.dart';
import '../widgets/public_navbar.dart';
import '../widgets/hero_section.dart';
import '../widgets/services_section.dart';
import '../widgets/about_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/footer_section.dart';
import '../widgets/chat_widget.dart';

class PublicSiteScreen extends ConsumerStatefulWidget {
  const PublicSiteScreen({super.key});

  @override
  ConsumerState<PublicSiteScreen> createState() => _PublicSiteScreenState();
}

class _PublicSiteScreenState extends ConsumerState<PublicSiteScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _scrolled = false;

  final heroKey = GlobalKey();
  final servicesKey = GlobalKey();
  final aboutKey = GlobalKey();
  final contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 20 && !_scrolled) {
      setState(() => _scrolled = true);
    } else if (_scrollController.offset <= 20 && _scrolled) {
      setState(() => _scrolled = false);
    }
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);
    final themeConfig = ThemeConfig.getPreset(config.theme);

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  HeroSection(
                    key: heroKey,
                    config: config.general,
                    themeConfig: themeConfig,
                    onContactClick: () => _scrollToSection(contactKey),
                    onServicesClick: () => _scrollToSection(servicesKey),
                  ),
                  ServicesSection(
                    key: servicesKey,
                    services: config.services,
                    themeConfig: themeConfig,
                  ),
                  AboutSection(
                    key: aboutKey,
                    aboutText: config.general.aboutText,
                    themeConfig: themeConfig,
                  ),
                  ContactSection(
                    key: contactKey,
                    contact: config.contact,
                    themeConfig: themeConfig,
                  ),
                  FooterSection(footerText: config.general.footerText),
                ]),
              ),
            ],
          ),
          // Navbar fixo por cima
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: _scrolled
                    ? Colors.white.withValues(alpha: 0.95)
                    : Colors.transparent,
                boxShadow: _scrolled
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: PublicNavbar(
                scrolled: _scrolled,
                themeConfig: themeConfig,
                companyName: config.general.companyName,
                onNavigateToSection: (section) {
                  switch (section) {
                    case 'services':
                      _scrollToSection(servicesKey);
                      break;
                    case 'about':
                      _scrollToSection(aboutKey);
                      break;
                    case 'contact':
                      _scrollToSection(contactKey);
                      break;
                  }
                },
                onNavigateToAdmin: () => context.go('/login'),
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: ChatWidget(themeConfig: themeConfig),
          ),
        ],
      ),
    );
  }
}
