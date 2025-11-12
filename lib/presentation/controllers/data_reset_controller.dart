import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/repository_providers.dart';

/// Controller responsável por gerenciar o reset de todos os dados do app
class DataResetController {
  final Ref _ref;

  DataResetController(this._ref);

  /// Reseta todos os dados do aplicativo
  ///
  /// Limpa:
  /// - Registros de ingestão de água
  /// - Metas diárias
  /// - Perfil do usuário
  /// - Configurações de tema
  ///
  /// Returns true se o reset foi bem-sucedido, false caso contrário
  Future<bool> resetAllData() async {
    try {
      // Obter referências dos repositórios
      final waterIntakeRepo = _ref.read(waterIntakeRepositoryProvider);
      final dailyGoalRepo = _ref.read(dailyGoalRepositoryProvider);
      final userProfileRepo = _ref.read(userProfileRepositoryProvider);
      final themeRepo = _ref.read(themeSettingsRepositoryProvider);

      // Reset sequencial para evitar problemas de concorrência
      await waterIntakeRepo.clearAllWaterIntakes();
      await dailyGoalRepo.clearAllDailyGoals();
      await userProfileRepo.deleteUserProfile();
      await themeRepo.deleteThemeSettings();

      // Invalidar todos os providers para refletir mudanças
      _ref.invalidate(waterIntakeRepositoryProvider);
      _ref.invalidate(dailyGoalRepositoryProvider);
      _ref.invalidate(userProfileRepositoryProvider);
      _ref.invalidate(themeSettingsRepositoryProvider);

      return true;
    } catch (e) {
      // Log do erro (em produção, usar um logger apropriado)
      print('Erro ao resetar dados: $e');
      return false;
    }
  }
}

/// Provider do controller de reset de dados
final dataResetControllerProvider = Provider<DataResetController>((ref) {
  return DataResetController(ref);
});

/// Provider para operação de reset (FutureProvider)
final resetDataProvider = FutureProvider.family<bool, void>((ref, _) async {
  final controller = ref.read(dataResetControllerProvider);
  return await controller.resetAllData();
});
