import 'dart:io';
import 'package:flutter/services.dart';

/// Gerenciador de configurações do AdMob
/// Carrega IDs de forma segura do arquivo admob.properties
class AdMobConfig {
  static final AdMobConfig _instance = AdMobConfig._internal();
  factory AdMobConfig() => _instance;
  AdMobConfig._internal();

  // Cache das configurações
  Map<String, String>? _config;
  bool _isLoaded = false;

  /// Carrega as configurações do arquivo admob.properties
  Future<void> initialize() async {
    if (_isLoaded) return;

    try {
      final configString = await rootBundle.loadString('admob.properties');
      _config = _parseProperties(configString);
      _isLoaded = true;
      print('AdMob Config: Carregado com sucesso');
    } catch (e) {
      // Se não conseguir carregar, usa IDs de teste como fallback
      _config = _getTestConfig();
      _isLoaded = true;
      print(
        'AdMob Config: Erro ao carregar arquivo ($e) - usando fallback seguro',
      );
    }
  }

  /// Parse do arquivo properties
  Map<String, String> _parseProperties(String content) {
    final config = <String, String>{};
    final lines = content.split('\n');

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;

      final separatorIndex = trimmed.indexOf('=');
      if (separatorIndex == -1) continue;

      final key = trimmed.substring(0, separatorIndex).trim();
      final value = trimmed.substring(separatorIndex + 1).trim();
      config[key] = value;
    }

    return config;
  }

  /// Configuração vazia como fallback seguro
  Map<String, String> _getTestConfig() {
    return {'is_testing': 'true'};
  }

  /// Getters para IDs específicos
  String get androidAppId => _config?['android_app_id'] ?? '';
  String get iosAppId => _config?['ios_app_id'] ?? '';

  String get androidBannerId => _config?['android_banner_id'] ?? '';
  String get iosBannerId => _config?['ios_banner_id'] ?? '';

  String get androidInterstitialId => _config?['android_interstitial_id'] ?? '';
  String get iosInterstitialId => _config?['ios_interstitial_id'] ?? '';

  /// Helpers por plataforma
  String get appId => Platform.isAndroid ? androidAppId : iosAppId;
  String get bannerId => Platform.isAndroid ? androidBannerId : iosBannerId;
  String get interstitialId =>
      Platform.isAndroid ? androidInterstitialId : iosInterstitialId;

  /// Verifica se está em modo de teste
  bool get isTesting => _config?['is_testing']?.toLowerCase() == 'true';

  /// Status do carregamento
  bool get isLoaded => _isLoaded;
}
