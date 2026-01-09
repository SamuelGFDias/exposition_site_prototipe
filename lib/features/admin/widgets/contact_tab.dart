import 'package:flutter/material.dart';
import '../../../core/models/app_config.dart';
import '../../../core/models/theme_config.dart';

class ContactTab extends StatefulWidget {
  final AppConfig initialConfig;
  final Function(AppConfig) onSave;

  const ContactTab({
    super.key,
    required this.initialConfig,
    required this.onSave,
  });

  @override
  State<ContactTab> createState() => _ContactTabState();
}

class _ContactTabState extends State<ContactTab> {
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
                'Informações de Contato',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 32),
              _buildTextField(
                label: 'Endereço',
                value: _config.contact.address,
                onChanged: (value) => _updateConfig(
                  _config.copyWith(
                    contact: _config.contact.copyWith(address: value),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Telefone',
                value: _config.contact.phone,
                onChanged: (value) => _updateConfig(
                  _config.copyWith(
                    contact: _config.contact.copyWith(phone: value),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Email',
                value: _config.contact.email,
                onChanged: (value) => _updateConfig(
                  _config.copyWith(
                    contact: _config.contact.copyWith(email: value),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Horário',
                value: _config.contact.hours,
                onChanged: (value) => _updateConfig(
                  _config.copyWith(
                    contact: _config.contact.copyWith(hours: value),
                  ),
                ),
              ),
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

  Widget _buildTextField({
    required String label,
    required String value,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: value)
            ..selection = TextSelection.collapsed(offset: value.length),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
