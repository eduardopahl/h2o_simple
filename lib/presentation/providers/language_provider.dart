import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Enum para os idiomas suportados
enum SupportedLanguage {
  english('en', 'English', '🇺🇸'),
  portuguese('pt', 'Português', '🇧🇷');

  const SupportedLanguage(this.code, this.name, this.flag);

  final String code;
  final String name;
  final String flag;

  static SupportedLanguage fromCode(String code) {
    return SupportedLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => SupportedLanguage.english,
    );
  }
}

/// Notifier para gerenciar o idioma da aplicação
class LanguageNotifier extends StateNotifier<Locale> {
  static const String _storageKey = 'selected_language';

  LanguageNotifier() : super(const Locale('en')) {
    _loadSavedLanguage();
  }

  /// Carrega o idioma salvo ou detecta automaticamente
  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_storageKey);

      if (savedLanguage != null) {
        // Usa o idioma salvo pelo usuário
        final language = SupportedLanguage.fromCode(savedLanguage);
        state = Locale(language.code);
      } else {
        // Auto-detecta baseado no sistema
        final systemLanguage = _detectSystemLanguage();
        await setLanguage(systemLanguage);
      }
    } catch (e) {
      // Em caso de erro, usa inglês como padrão
      state = const Locale('en');
    }
  }

  /// Detecta o idioma do sistema
  SupportedLanguage _detectSystemLanguage() {
    final systemLocale = Platform.localeName;

    if (systemLocale.startsWith('pt')) {
      return SupportedLanguage.portuguese;
    }

    // Padrão é inglês para todos os outros idiomas
    return SupportedLanguage.english;
  }

  /// Define um novo idioma e salva a preferência
  Future<void> setLanguage(SupportedLanguage language) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, language.code);
      state = Locale(language.code);
    } catch (e) {
      // Se não conseguir salvar, ainda atualiza o estado
      state = Locale(language.code);
    }
  }

  /// Alterna entre os idiomas disponíveis
  Future<void> toggleLanguage() async {
    final currentLanguage = SupportedLanguage.fromCode(state.languageCode);
    final newLanguage =
        currentLanguage == SupportedLanguage.english
            ? SupportedLanguage.portuguese
            : SupportedLanguage.english;

    await setLanguage(newLanguage);
  }

  /// Obtém o idioma atual como enum
  SupportedLanguage get currentLanguage {
    return SupportedLanguage.fromCode(state.languageCode);
  }
}

/// Provider para o idioma da aplicação
final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>(
  (ref) => LanguageNotifier(),
);

/// Provider helper para obter o idioma atual como enum
final currentLanguageProvider = Provider<SupportedLanguage>((ref) {
  final locale = ref.watch(languageProvider);
  return SupportedLanguage.fromCode(locale.languageCode);
});
