import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/theme_settings.dart';
import 'repository_providers.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _loadTheme();
    return ThemeMode.light;
  }

  Future<void> _loadTheme() async {
    try {
      final repository = ref.read(themeSettingsRepositoryProvider);
      final settings = await repository.getThemeSettings();
      state = settings.themeMode;
    } catch (e) {
      state = ThemeMode.light;
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    try {
      final repository = ref.read(themeSettingsRepositoryProvider);
      final settings = ThemeSettings(themeMode: themeMode);
      await repository.saveThemeSettings(settings);
      state = themeMode;
    } catch (e) {
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

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);
