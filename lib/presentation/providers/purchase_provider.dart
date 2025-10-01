import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/purchase_service.dart';

/// Provider para o serviço de compras
final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  final service = PurchaseService();

  // Inicializa o serviço automaticamente
  service.initialize();

  // Dispõe quando não precisar mais
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

/// Provider para verificar se o usuário é premium
final isPremiumUserProvider = FutureProvider<bool>((ref) async {
  final purchaseService = ref.watch(purchaseServiceProvider);
  return await purchaseService.isPremiumUser();
});

/// Provider para verificar se as compras estão disponíveis
final purchasesAvailableProvider = Provider<bool>((ref) {
  final purchaseService = ref.watch(purchaseServiceProvider);
  return purchaseService.isAvailable;
});
