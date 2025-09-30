import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/theme_settings.dart';
import '../../domain/repositories/theme_settings_repository.dart';
import 'repository_providers.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final ThemeSettingsRepository _repository;

  ThemeNotifier(this._repository) : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final settings = await _repository.getThemeSettings();
      state = settings.themeMode;
    } catch (e) {
      // Se houver erro ao carregar, mantém o tema claro como padrão
      state = ThemeMode.light;
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    try {
      final settings = ThemeSettings(themeMode: themeMode);
      await _repository.saveThemeSettings(settings);
      state = themeMode;
    } catch (e) {
      // Em caso de erro, apenas atualiza o estado sem persistir
      state = themeMode;
    }
  }

  void toggleTheme() {
    final newTheme =
        state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    setThemeMode(newTheme);
  }

  bool get isDarkMode => state == ThemeMode.dark;
  bool get isLightMode => state == ThemeMode.light;
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final repository = ref.watch(themeSettingsRepositoryProvider);
  return ThemeNotifier(repository);
});
