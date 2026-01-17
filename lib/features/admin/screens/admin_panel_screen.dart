import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/theme_config.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/config_provider.dart';
import '../widgets/general_tab.dart';
import '../widgets/services_tab.dart';
import '../widgets/contact_tab.dart';
import '../widgets/chatbot_tab.dart';

class AdminPanelScreen extends ConsumerStatefulWidget {
  final int initialTab;

  const AdminPanelScreen({super.key, this.initialTab = 0});

  @override
  ConsumerState<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends ConsumerState<AdminPanelScreen> {
  late int _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  void _handleLogout() {
    ref.read(authProvider.notifier).logout();
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);
    final authState = ref.watch(authProvider);
    final themeConfig = ThemeConfig.getPreset(config.theme);
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: themeConfig.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.dashboard, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Painel de Controle',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Logado como ${authState.username}',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
        actions: [
          if (!isMobile)
            TextButton.icon(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.public, size: 16),
              label: const Text('Ver Site'),
            ),
          TextButton.icon(
            onPressed: _handleLogout,
            icon: const Icon(Icons.logout, size: 16),
            label: const Text('Sair'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          if (!isMobile)
            Container(
              width: 250,
              color: Colors.white,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'PERSONALIZAÇÃO',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  _buildTabButton(
                    0,
                    Icons.palette,
                    'Geral & Tema',
                    themeConfig,
                  ),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'CONTEÚDO',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  _buildTabButton(
                    1,
                    Icons.miscellaneous_services,
                    'Serviços',
                    themeConfig,
                  ),
                  _buildTabButton(
                    2,
                    Icons.contact_mail,
                    'Contato',
                    themeConfig,
                  ),
                  _buildTabButton(3, Icons.chat, 'Chatbot AI', themeConfig),
                ],
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                padding: const EdgeInsets.all(32),
                child: _buildTabContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    int index,
    IconData icon,
    String label,
    ThemeConfig themeConfig,
  ) {
    final isSelected = _selectedTab == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: isSelected ? themeConfig.bgLightColor : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => setState(() => _selectedTab = index),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isSelected
                      ? themeConfig.textColor
                      : Colors.grey.shade600,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected
                        ? themeConfig.textColor
                        : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return switch (_selectedTab) {
      0 => GeneralTab(
        initialConfig: ref.read(appConfigProvider),
        onSave: (newConfig) {
          ref.read(appConfigProvider.notifier).updateConfig(newConfig);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Configurações gerais salvas!'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
      1 => ServicesTab(
        initialConfig: ref.read(appConfigProvider),
        onSave: (newConfig) {
          ref.read(appConfigProvider.notifier).updateConfig(newConfig);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Serviços salvos!'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
      2 => ContactTab(
        initialConfig: ref.read(appConfigProvider),
        onSave: (newConfig) {
          ref.read(appConfigProvider.notifier).updateConfig(newConfig);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Informações de contato salvas!'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
      3 => ChatbotTab(
        initialConfig: ref.read(appConfigProvider),
        onSave: (newConfig) {
          ref.read(appConfigProvider.notifier).updateConfig(newConfig);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Configurações do chatbot salvas!'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
      _ => const Center(child: Text('Tab não encontrada')),
    };
  }
}
