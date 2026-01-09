import 'package:flutter/material.dart';
import '../../../core/models/app_config.dart';
import '../../../core/models/theme_config.dart';

class ServicesTab extends StatefulWidget {
  final AppConfig initialConfig;
  final Function(AppConfig) onSave;

  const ServicesTab({
    super.key,
    required this.initialConfig,
    required this.onSave,
  });

  @override
  State<ServicesTab> createState() => _ServicesTabState();
}

class _ServicesTabState extends State<ServicesTab> {
  late AppConfig _config;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _config = widget.initialConfig;
  }

  void _updateConfig(AppConfig newConfig) {
    setState(() {
      _config = newConfig;
      _hasChanges = true;
    });
  }

  void _handleSave() {
    widget.onSave(_config);
    setState(() {
      _hasChanges = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeConfig = ThemeConfig.getPreset(_config.theme);

    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              const Text(
                'Gerenciar Serviços',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 32),
              const Text(
                'Edite os títulos e descrições dos serviços exibidos na home.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ..._config.services.asMap().entries.map((entry) {
                final index = entry.key;
                final service = entry.value;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SERVIÇO #${index + 1}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: TextEditingController(text: service.title)
                          ..selection =
                              TextSelection.collapsed(offset: service.title.length),
                        decoration: const InputDecoration(
                          labelText: 'Título',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onChanged: (value) {
                          final updatedServices = [..._config.services];
                          updatedServices[index] =
                              service.copyWith(title: value);
                          _updateConfig(
                              _config.copyWith(services: updatedServices));
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: TextEditingController(text: service.description)
                          ..selection = TextSelection.collapsed(
                              offset: service.description.length),
                        decoration: const InputDecoration(
                          labelText: 'Descrição',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        maxLines: 2,
                        onChanged: (value) {
                          final updatedServices = [..._config.services];
                          updatedServices[index] =
                              service.copyWith(description: value);
                          _updateConfig(
                              _config.copyWith(services: updatedServices));
                        },
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _hasChanges ? _handleSave : null,
              icon: const Icon(Icons.save, size: 18),
              label: const Text('Salvar Alterações'),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeConfig.primaryColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                disabledForegroundColor: Colors.grey.shade500,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
