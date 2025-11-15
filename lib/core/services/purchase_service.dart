import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Serviço para gerenciar compras in-app
/// Permite ao usuário comprar a remoção de anúncios
class PurchaseService {
  static const String _removeAdsProductId = 'h2osync_premium_noads';
  static const String _premiumStatusKey = 'is_premium_user';

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  bool _isAvailable = false;
  List<ProductDetails> _products = [];
  bool _purchasesPending = false;

  /// Inicializa o serviço de compras
  ///
  /// FLUXO DE RESTAURAÇÃO AUTOMÁTICA:
  /// 1. Verifica se compras estão disponíveis
  /// 2. Carrega produtos da loja
  /// 3. Escuta mudanças de compras
  /// 4. RESTAURA AUTOMATICAMENTE compras anteriores
  /// 5. Se houver compras válidas, define status premium
  ///
  /// Isso garante que usuários que:
  /// - Reinstalaram o app
  /// - Trocaram de dispositivo
  /// - Fizeram backup/restore
  /// Mantenham automaticamente o status premium sem ação manual
  Future<void> initialize() async {
    try {
      _isAvailable = await _inAppPurchase.isAvailable();

      if (_isAvailable) {
        await _loadProducts();
        _listenToPurchaseUpdated();

        // IMPORTANTE: Restaura compras automaticamente na inicialização
        // Isso garante que usuários que reinstalaram o app mantenham o premium
        await _restoreAndCheckPurchases();
      }
    } catch (e) {
      _isAvailable = false;
    }
  }

  /// Carrega os produtos disponíveis
  Future<void> _loadProducts() async {
    const Set<String> productIds = {_removeAdsProductId};

    try {
      final ProductDetailsResponse response = await _inAppPurchase
          .queryProductDetails(productIds);

      if (response.notFoundIDs.isNotEmpty) {
        // Produtos não encontrados - normal em desenvolvimento
      }

      _products = response.productDetails;
    } catch (e) {
      // Erro ao carregar produtos
    }
  }

  /// Escuta atualizações de compra
  void _listenToPurchaseUpdated() {
    _subscription = _inAppPurchase.purchaseStream.listen(
      (List<PurchaseDetails> purchaseDetailsList) {
        _handlePurchaseUpdate(purchaseDetailsList);
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        // Erro no stream de compras
      },
    );
  }

  /// Manipula atualizações de compra
  Future<void> _handlePurchaseUpdate(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _purchasesPending = true;
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // Erro na compra
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          // Verifica se é o produto de remoção de anúncios
          if (purchaseDetails.productID == _removeAdsProductId) {
            await _setPremiumStatus(true);
          }
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }

        _purchasesPending = false;
      }
    }
  }

  /// Inicia o processo de compra para remover anúncios
  Future<bool> buyRemoveAds() async {
    if (!_isAvailable) {
      return false;
    }

    if (_products.isEmpty) {
      await _loadProducts();

      if (_products.isEmpty) {
        return false;
      }
    }

    try {
      final ProductDetails productDetails = _products.firstWhere(
        (product) => product.id == _removeAdsProductId,
      );

      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetails,
      );

      final bool success = await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );

      return success;
    } catch (e) {
      // Se o produto não foi encontrado
      if (e.toString().contains('firstWhere')) {
        return false;
      }

      return false;
    }
  }

  /// Restaura compras anteriores (automaticamente na inicialização)
  Future<void> _restoreAndCheckPurchases() async {
    try {
      // Restaura compras silenciosamente
      await _inAppPurchase.restorePurchases();

      // A verificação será feita automaticamente no _handlePurchaseUpdate
      // quando as compras restauradas chegarem
    } catch (e) {
      // Erro ao verificar compras anteriores
    }
  }

  /// Restaura compras anteriores (chamada manual pelo usuário)
  Future<bool> restorePurchases() async {
    try {
      if (!_isAvailable) {
        return false;
      }

      // Verifica o status atual antes da restauração
      final wasPremiusBefore = await isPremiumUser();

      // Executa a restauração
      await _inAppPurchase.restorePurchases();

      // Aguarda um momento para que o processo de restauração complete
      await Future.delayed(const Duration(milliseconds: 500));

      // Verifica se agora é premium após a restauração
      final isPremiusAfter = await isPremiumUser();

      // Retorna true se:
      // 1. Já era premium antes (confirmando que tem compras válidas), ou
      // 2. Tornou-se premium após a restauração
      return wasPremiusBefore || isPremiusAfter;
    } catch (e) {
      return false;
    }
  }

  /// Define o status premium do usuário
  Future<void> _setPremiumStatus(bool isPremium) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_premiumStatusKey, isPremium);
  }

  /// Verifica se o usuário é premium
  ///
  /// IMPORTANTE: O SharedPreferences é usado apenas como cache local.
  /// A verdadeira fonte de verdade são as compras restauradas automaticamente
  /// pela Apple/Google quando o app é inicializado. Isso garante que:
  ///
  /// 1. Se o usuário reinstalar o app, o premium será restaurado automaticamente
  /// 2. Se o usuário trocar de dispositivo (mesmo Apple ID/Google Account),
  ///    o premium será transferido
  /// 3. A compra é permanente e vinculada à conta, não ao dispositivo
  Future<bool> isPremiumUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_premiumStatusKey) ?? false;
  }

  /// Obtém o produto de remoção de anúncios
  ProductDetails? get removeAdsProduct {
    try {
      return _products.firstWhere(
        (product) => product.id == _removeAdsProductId,
      );
    } catch (e) {
      // Se o produto não for encontrado, retorna null
      // Isso pode acontecer se o app ainda não foi publicado na Play Store
      // ou se o produto ainda não foi configurado no Google Play Console
      return null;
    }
  }

  /// Obtém o preço do produto com fallback
  String get removeAdsPrice {
    final product = removeAdsProduct;
    if (product != null) {
      return product.price;
    }

    // Fallback para quando o produto não está disponível
    // Isso permite testar a UI mesmo sem o produto configurado na loja
    return '\$0.99'; // Preço padrão em dólares
  }

  /// Verifica se as compras estão disponíveis
  bool get isAvailable => _isAvailable;

  /// Verifica se há compras pendentes
  bool get purchasesPending => _purchasesPending;

  /// Reset premium status (apenas para testes)
  Future<void> resetPremiumStatus() async {
    await _setPremiumStatus(false);
  }

  /// Dispõe dos recursos
  void dispose() {
    _subscription.cancel();
  }
}
