import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_config.dart';
import '../models/theme_config.dart';

final appConfigProvider =
    StateNotifierProvider<AppConfigNotifier, AppConfig>((ref) {
  return AppConfigNotifier();
});

class AppConfigNotifier extends StateNotifier<AppConfig> {
  AppConfigNotifier() : super(AppConfig.defaultConfig);

  void updateConfig(AppConfig newConfig) {
    state = newConfig;
  }

  void updateGeneral(GeneralConfig general) {
    state = state.copyWith(general: general);
  }

  void updateContact(ContactConfig contact) {
    state = state.copyWith(contact: contact);
  }

  void updateTheme(AppThemePreset theme) {
    state = state.copyWith(theme: theme);
  }
}
