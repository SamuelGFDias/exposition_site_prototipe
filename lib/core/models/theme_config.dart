import 'package:flutter/material.dart';

enum AppThemePreset { blue, emerald, violet, rose, amber }

class ThemeConfig {
  final AppThemePreset preset;
  final String name;
  final Color primaryColor;
  final Color textColor;
  final Color bgLightColor;

  const ThemeConfig({
    required this.preset,
    required this.name,
    required this.primaryColor,
    required this.textColor,
    required this.bgLightColor,
  });

  static const Map<AppThemePreset, ThemeConfig> presets = {
    AppThemePreset.blue: ThemeConfig(
      preset: AppThemePreset.blue,
      name: 'Ocean Blue',
      primaryColor: Color(0xFF2563EB),
      textColor: Color(0xFF1E40AF),
      bgLightColor: Color(0xFFEFF6FF),
    ),
    AppThemePreset.emerald: ThemeConfig(
      preset: AppThemePreset.emerald,
      name: 'Eco Emerald',
      primaryColor: Color(0xFF059669),
      textColor: Color(0xFF065F46),
      bgLightColor: Color(0xFFECFDF5),
    ),
    AppThemePreset.violet: ThemeConfig(
      preset: AppThemePreset.violet,
      name: 'Digital Violet',
      primaryColor: Color(0xFF7C3AED),
      textColor: Color(0xFF5B21B6),
      bgLightColor: Color(0xFFF5F3FF),
    ),
    AppThemePreset.rose: ThemeConfig(
      preset: AppThemePreset.rose,
      name: 'Berry Rose',
      primaryColor: Color(0xFFE11D48),
      textColor: Color(0xFF9F1239),
      bgLightColor: Color(0xFFFFF1F2),
    ),
    AppThemePreset.amber: ThemeConfig(
      preset: AppThemePreset.amber,
      name: 'Solar Amber',
      primaryColor: Color(0xFFD97706),
      textColor: Color(0xFF92400E),
      bgLightColor: Color(0xFFFEF3C7),
    ),
  };

  static ThemeConfig getPreset(AppThemePreset preset) =>
      presets[preset] ?? presets[AppThemePreset.blue]!;
}
