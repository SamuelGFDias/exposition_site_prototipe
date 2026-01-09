import 'package:flutter/material.dart';
import '../../../core/models/app_config.dart';
import '../../../core/models/theme_config.dart';

class GeneralTab extends StatefulWidget {
  final AppConfig initialConfig;
  final Function(AppConfig) onSave;

  const GeneralTab({
    super.key,
    required this.initialConfig,
    required this.onSave,
  });

  @override
  State<GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends State<GeneralTab> {
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
              Row(
                children: [
                  Icon(Icons.palette, color: themeConfig.textColor),
                  const SizedBox(width: 12),
                  const Text(
                    'Aparência do Site',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(height: 32),
              const Text(
                'Cor Principal (Tema)',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: AppThemePreset.values.map((preset) {
                  final tc = ThemeConfig.getPreset(preset);
                  final isSelected = _config.theme == preset;

                  return InkWell(
                    onTap: () => _updateConfig(_config.copyWith(theme: preset)),
                    child: Container(
                      width: 120,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? tc.primaryColor : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected ? tc.bgLightColor : Colors.transparent,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: tc.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            tc.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              const Text(
                'Textos Principais',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Nome da Empresa',
                value: _config.general.companyName,
                onChanged: (value) => _updateConfig(
                  _config.copyWith(
                    general: _config.general.copyWith(companyName: value),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Título Hero',
                value: _config.general.heroTitle,
                onChanged: (value) => _updateConfig(
                  _config.copyWith(
                    general: _config.general.copyWith(heroTitle: value),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Subtítulo',
                value: _config.general.heroSubtitle,
                onChanged: (value) => _updateConfig(
                  _config.copyWith(
                    general: _config.general.copyWith(heroSubtitle: value),
                  ),
                ),
                maxLines: 3,
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
    int maxLines = 1,
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
          maxLines: maxLines,
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
