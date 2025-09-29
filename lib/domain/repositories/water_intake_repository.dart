import '../entities/water_intake.dart';

abstract class WaterIntakeRepository {
  /// Adiciona um novo registro de ingestão de água
  Future<void> addWaterIntake(WaterIntake intake);

  /// Remove um registro de ingestão de água
  Future<void> removeWaterIntake(String id);

  /// Busca registros de água por data
  Future<List<WaterIntake>> getWaterIntakesByDate(DateTime date);

  /// Busca registros de água em um período
  Future<List<WaterIntake>> getWaterIntakesByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Busca todos os registros de água
  Future<List<WaterIntake>> getAllWaterIntakes();

  /// Calcula total de água ingerida em uma data específica
  Future<int> getTotalWaterIntakeByDate(DateTime date);

  /// Remove todos os registros (para reset/limpeza)
  Future<void> clearAllWaterIntakes();
}
