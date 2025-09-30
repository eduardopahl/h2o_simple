import '../entities/theme_settings.dart';

abstract class ThemeSettingsRepository {
  /// Salva as configurações de tema
  Future<void> saveThemeSettings(ThemeSettings settings);

  /// Busca as configurações de tema
  Future<ThemeSettings> getThemeSettings();

  /// Atualiza as configurações de tema
  Future<void> updateThemeSettings(ThemeSettings settings);

  /// Remove as configurações de tema (volta ao padrão)
  Future<void> deleteThemeSettings();

  /// Verifica se existem configurações salvas
  Future<bool> hasThemeSettings();
}
