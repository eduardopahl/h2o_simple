import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/theme_settings.dart';
import '../../domain/repositories/theme_settings_repository.dart';
import '../models/theme_settings_model.dart';

class ThemeSettingsRepositoryImpl implements ThemeSettingsRepository {
  static const String _themeSettingsKey = 'theme_settings';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  @override
  Future<void> saveThemeSettings(ThemeSettings settings) async {
    final prefs = await _prefs;
    final model = ThemeSettingsModel.fromEntity(settings);
    await prefs.setString(_themeSettingsKey, jsonEncode(model.toJson()));
  }

  @override
  Future<ThemeSettings> getThemeSettings() async {
    final prefs = await _prefs;
    final jsonString = prefs.getString(_themeSettingsKey);

    if (jsonString == null) {
      // Retorna configuração padrão se não houver nada salvo
      return const ThemeSettings();
    }

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final model = ThemeSettingsModel.fromJson(json);
      return model.toEntity();
    } catch (e) {
      // Se houver erro na deserialização, remove as configurações inválidas
      await deleteThemeSettings();
      return const ThemeSettings();
    }
  }

  @override
  Future<void> updateThemeSettings(ThemeSettings settings) async {
    // Para SharedPreferences, update é igual a save
    await saveThemeSettings(settings);
  }

  @override
  Future<void> deleteThemeSettings() async {
    final prefs = await _prefs;
    await prefs.remove(_themeSettingsKey);
  }

  @override
  Future<bool> hasThemeSettings() async {
    final prefs = await _prefs;
    return prefs.containsKey(_themeSettingsKey);
  }
}
