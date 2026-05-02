import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class LanguageNotifier extends Notifier<Locale> {
  static const String _storageKey = 'selected_language';

  @override
  Locale build() {
    _loadSavedLanguage();
    return const Locale('en');
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_storageKey);

      if (savedLanguage != null) {
        final language = SupportedLanguage.fromCode(savedLanguage);
        state = Locale(language.code);
      } else {
        final systemLanguage = _detectSystemLanguage();
        state = Locale(systemLanguage.code);
        await prefs.setString(_storageKey, systemLanguage.code);
      }
    } catch (e) {
      state = const Locale('en');
    }
  }

  SupportedLanguage _detectSystemLanguage() {
    final systemLocale = Platform.localeName;
    if (systemLocale.startsWith('pt')) {
      return SupportedLanguage.portuguese;
    }
    return SupportedLanguage.english;
  }

  Future<void> setLanguage(SupportedLanguage language) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, language.code);
      state = Locale(language.code);
    } catch (e) {
      state = Locale(language.code);
    }
  }

  Future<void> toggleLanguage() async {
    final currentLanguage = SupportedLanguage.fromCode(state.languageCode);
    final newLanguage =
        currentLanguage == SupportedLanguage.english
            ? SupportedLanguage.portuguese
            : SupportedLanguage.english;
    await setLanguage(newLanguage);
  }

  SupportedLanguage get currentLanguage {
    return SupportedLanguage.fromCode(state.languageCode);
  }
}

final languageProvider = NotifierProvider<LanguageNotifier, Locale>(
  LanguageNotifier.new,
);

final currentLanguageProvider = Provider<SupportedLanguage>((ref) {
  final locale = ref.watch(languageProvider);
  return SupportedLanguage.fromCode(locale.languageCode);
});
