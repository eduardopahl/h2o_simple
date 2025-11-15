import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/services/ad_service.dart';
import '../../core/config/admob_config.dart';
import '../../core/services/purchase_service.dart';

/// Implementação concreta do serviço de anúncios usando Google Mobile Ads
class GoogleAdService implements AdService {
  static const String _lastAdKey = 'last_ad_timestamp';

  final AdMobConfig _config = AdMobConfig();
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  bool _isInitialized = false;
  PurchaseService? _purchaseService;

  /// Configura o serviço de compras
  void configurePurchaseService(PurchaseService purchaseService) {
    _purchaseService = purchaseService;
  }

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // ...
      await _config.initialize();
      // ...

      if (_hasValidAdIds()) {
        // ...
        await MobileAds.instance.initialize();
        await loadNativeBanner();
        await _loadInterstitial();
      } else {}

      _isInitialized = true;
    } catch (e) {
      _isInitialized = true; // Marca como inicializado mesmo com erro
    }
  }

  @override
  bool canShowAd(String adType) {
    // Verificação básica de premium (síncrona)
    // O provider fará a verificação assíncrona completa
    if (isPremiumUser) return false;

    // Não mostra anúncios se não há IDs configurados
    if (!_hasValidAdIds()) return false;

    return _checkCooldown();
  }

  @override
  Future<void> loadNativeBanner() async {
    if (_purchaseService != null) {
      final isPremium = await _purchaseService!.isPremiumUser();
      if (isPremium) {
        return;
      }
    }

    if (_bannerAd != null) {
      return;
    }
    if (!_hasValidAdIds()) {
      return;
    }

    try {
      _bannerAd = BannerAd(
        adUnitId: _getBannerAdUnitId(),
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {},
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            _bannerAd = null;
          },
        ),
      );

      await _bannerAd!.load();
    } catch (e) {
      _bannerAd?.dispose();
      _bannerAd = null;
    }
  }

  @override
  Future<void> showCelebrationAd(String achievement) async {
    if (_purchaseService != null) {
      final isPremium = await _purchaseService!.isPremiumUser();
      if (isPremium) {
        return;
      }
    }

    if (!canShowAd('celebration')) {
      return;
    }
    if (_interstitialAd == null) {
      await _loadInterstitial();
      // Aguarda o carregamento (máximo 2s)
      for (int i = 0; i < 10; i++) {
        await Future.delayed(const Duration(milliseconds: 200));
        if (_interstitialAd != null) {
          break;
        }
      }
      if (_interstitialAd == null) {
        return;
      }
    }
    if (!_hasValidAdIds()) {
      return;
    }

    await _interstitialAd!.show();
    markAdShown('celebration');

    _interstitialAd = null;
    await _loadInterstitial();
  }

  @override
  void markAdShown(String adType) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt(_lastAdKey, DateTime.now().millisecondsSinceEpoch);
    });
  }

  @override
  bool get isPremiumUser {
    // Verifica com o serviço de compras se disponível
    if (_purchaseService != null) {
      // Como isPremiumUser é síncrono mas PurchaseService é assíncrono,
      // mantemos cache simples aqui. O provider gerenciará o estado real.
      return false; // O provider handle the async check
    }
    return false;
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
  }

  /// Métodos privados

  /// Verifica se há IDs válidos configurados
  bool _hasValidAdIds() {
    return _config.bannerId.isNotEmpty && _config.interstitialId.isNotEmpty;
  }

  bool _checkCooldown() {
    // Método síncrono simples - na prática, você pode querer usar FutureBuilder
    // ou um StateNotifier para gerenciar o estado assíncrono adequadamente
    return true; // Por enquanto, sempre permite - implementar lógica real conforme necessário
  }

  String _getBannerAdUnitId() {
    return _config.bannerId;
  }

  String _getInterstitialAdUnitId() {
    return _config.interstitialId;
  }

  Future<void> _loadInterstitial() async {
    if (_purchaseService != null) {
      final isPremium = await _purchaseService!.isPremiumUser();
      if (isPremium) {
        return;
      }
    }

    if (_interstitialAd != null) {
      return;
    }
    if (!_hasValidAdIds()) {
      return;
    }

    try {
      await InterstitialAd.load(
        adUnitId: _getInterstitialAdUnitId(),
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (ad) {},
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                ad.dispose();
              },
            );
            _interstitialAd = ad;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (error) {
            _interstitialAd = null;
          },
        ),
      );
    } catch (e) {
      _interstitialAd = null;
    }
  }

  /// Getter para o banner (usado pelos widgets)
  BannerAd? get bannerAd => _bannerAd;
}
