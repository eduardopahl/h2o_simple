import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/ad_service_provider.dart';
import '../providers/purchase_provider.dart';
import '../../data/services/google_ad_service.dart';

/// Widget para exibir banner nativo contextual de forma não-intrusiva
class ContextualAdBanner extends ConsumerWidget {
  final String context;
  final EdgeInsets margin;

  const ContextualAdBanner({
    super.key,
    required this.context,
    this.margin = const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Verifica se o usuário é premium
    final isPremiumAsync = ref.watch(isPremiumUserProvider);

    return isPremiumAsync.when(
      data: (isPremium) {
        // Se for premium, não mostra anúncios
        if (isPremium) return const SizedBox.shrink();

        final adService = ref.watch(adServiceProvider);

        // Não mostra se não pode mostrar anúncio
        if (!adService.canShowAd('banner')) {
          return const SizedBox.shrink();
        }

        // Se for GoogleAdService, tenta mostrar o banner do Google Ads
        if (adService is GoogleAdService && adService.bannerAd != null) {
          return _buildGoogleAdBanner(adService.bannerAd!);
        }

        // Fallback: banner nativo personalizado
        return _buildNativeBanner(this.context);
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildGoogleAdBanner(BannerAd bannerAd) {
    return Container(margin: margin, height: 60, child: AdWidget(ad: bannerAd));
  }

  Widget _buildNativeBanner(String context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200, width: 0.5),
      ),
      child: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context);

          return Row(
            children: [
              Icon(
                _getContextIcon(this.context),
                color: Colors.blue.shade600,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getAdTitle(l10n, this.context),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getAdSubtitle(l10n, this.context),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  l10n.adLabel,
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  IconData _getContextIcon(String context) {
    switch (context) {
      case 'stats':
        return Icons.analytics;
      case 'history':
        return Icons.history;
      case 'settings':
        return Icons.local_drink;
      default:
        return Icons.water_drop;
    }
  }

  String _getAdTitle(AppLocalizations l10n, String context) {
    switch (context) {
      case 'stats':
        return l10n.smartHydrationBottle;
      case 'history':
        return l10n.hydrationSupplements;
      case 'settings':
        return l10n.premiumFitWaterApp;
      default:
        return l10n.hydrationProducts;
    }
  }

  String _getAdSubtitle(AppLocalizations l10n, String context) {
    switch (context) {
      case 'stats':
        return l10n.monitorAutomatically;
      case 'history':
        return l10n.naturalElectrolytes;
      case 'settings':
        return l10n.advancedFeaturesNoAds;
      default:
        return l10n.improveDailyHydration;
    }
  }
}
