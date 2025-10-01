import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/ad_service.dart';
import '../../data/services/google_ad_service.dart';
import 'purchase_provider.dart';

/// Provider do serviço de anúncios
final adServiceProvider = Provider<AdService>((ref) {
  final googleAdService = GoogleAdService();

  // Configura o serviço de compras
  final purchaseService = ref.read(purchaseServiceProvider);
  googleAdService.configurePurchaseService(purchaseService);

  return googleAdService;
});

/// Provider para inicializar o AdService de forma segura
final adServiceInitializerProvider = FutureProvider<void>((ref) async {
  try {
    final service = ref.watch(adServiceProvider);
    await service.initialize();
    print('AdService inicializado com sucesso');
  } catch (e) {
    print('Erro ao inicializar AdService: $e');
    // Não propaga o erro para não crashar o app
  }
});

/// Provider para verificar se anúncios podem ser mostrados
final canShowAdsProvider = FutureProvider<bool>((ref) async {
  final isPremium = await ref.watch(isPremiumUserProvider.future);
  return !isPremium;
});
