/// Interface para o serviço de anúncios
/// Segue os princípios da arquitetura limpa
abstract class AdService {
  /// Inicializa o SDK de anúncios
  Future<void> initialize();

  /// Verifica se pode mostrar um anúncio baseado na frequência
  bool canShowAd(String adType);

  /// Carrega um banner nativo
  Future<void> loadNativeBanner();

  /// Mostra um anúncio intersticial comemorativo
  Future<void> showCelebrationAd(String achievement);

  /// Registra que um anúncio foi mostrado
  void markAdShown(String adType);

  /// Verifica se o usuário é premium (sem anúncios)
  bool get isPremiumUser;

  /// Dispose dos recursos
  void dispose();
}
