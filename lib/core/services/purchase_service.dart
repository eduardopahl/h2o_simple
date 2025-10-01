import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Serviço para gerenciar compras in-app
/// Permite ao usuário comprar a remoção de anúncios
class PurchaseService {
  static const String _removeAdsProductId = 'remove_ads_forever';
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

      print('PurchaseService: Inicializado (disponível: $_isAvailable)');
    } catch (e) {
      print('Erro ao inicializar PurchaseService: $e');
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
        print('Produtos não encontrados: ${response.notFoundIDs}');
      }

      _products = response.productDetails;
      print('Produtos carregados: ${_products.length}');
    } catch (e) {
      print('Erro ao carregar produtos: $e');
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
        print('Erro no stream de compras: $error');
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
          print('Erro na compra: ${purchaseDetails.error}');
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          // Verifica se é o produto de remoção de anúncios
          if (purchaseDetails.productID == _removeAdsProductId) {
            await _setPremiumStatus(true);
            print('Compra realizada: Anúncios removidos');
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
    if (!_isAvailable || _products.isEmpty) {
      print('Compras não disponíveis ou produtos não carregados');
      return false;
    }

    final ProductDetails productDetails = _products.firstWhere(
      (product) => product.id == _removeAdsProductId,
      orElse: () => throw Exception('Produto não encontrado'),
    );

    try {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetails,
      );

      final bool success = await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );

      return success;
    } catch (e) {
      print('Erro ao iniciar compra: $e');
      return false;
    }
  }

  /// Restaura compras anteriores (automaticamente na inicialização)
  Future<void> _restoreAndCheckPurchases() async {
    try {
      print('Verificando compras anteriores...');

      // Restaura compras silenciosamente
      await _inAppPurchase.restorePurchases();

      // A verificação será feita automaticamente no _handlePurchaseUpdate
      // quando as compras restauradas chegarem
    } catch (e) {
      print('Erro ao verificar compras anteriores: $e');
    }
  }

  /// Restaura compras anteriores (chamada manual pelo usuário)
  Future<bool> restorePurchases() async {
    try {
      if (!_isAvailable) {
        return false;
      }

      await _inAppPurchase.restorePurchases();
      return true;
    } catch (e) {
      print('Erro ao restaurar compras: $e');
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
      return null;
    }
  }

  /// Verifica se as compras estão disponíveis
  bool get isAvailable => _isAvailable;

  /// Verifica se há compras pendentes
  bool get purchasesPending => _purchasesPending;

  /// Dispõe dos recursos
  void dispose() {
    _subscription.cancel();
  }
}
