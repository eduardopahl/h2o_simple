import '../entities/daily_goal.dart';

abstract class DailyGoalRepository {
  /// Salva ou atualiza a meta diária
  Future<void> saveDailyGoal(DailyGoal goal);

  /// Busca a meta diária por data
  Future<DailyGoal?> getDailyGoalByDate(DateTime date);

  /// Busca metas em um período
  Future<List<DailyGoal>> getDailyGoalsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Atualiza o progresso atual de uma meta
  Future<void> updateDailyGoalProgress(DateTime date, int currentAmount);

  /// Adiciona um ID de ingestão de água à meta do dia
  Future<void> addIntakeIdToGoal(DateTime date, String intakeId);

  /// Remove um ID de ingestão de água da meta do dia
  Future<void> removeIntakeIdFromGoal(DateTime date, String intakeId);

  /// Remove uma meta diária
  Future<void> removeDailyGoal(DateTime date);

  /// Remove todas as metas (para reset/limpeza)
  Future<void> clearAllDailyGoals();
}
