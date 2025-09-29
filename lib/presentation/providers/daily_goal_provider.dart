import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/daily_goal.dart';
import '../../domain/repositories/daily_goal_repository.dart';
import 'repository_providers.dart';
import 'user_profile_provider.dart';
import 'water_intake_provider.dart';

class DailyGoalNotifier extends StateNotifier<AsyncValue<DailyGoal?>> {
  DailyGoalNotifier(this._repository, this._ref)
    : super(const AsyncValue.loading()) {
    loadTodayGoal();
  }

  final DailyGoalRepository _repository;
  final Ref _ref;

  Future<void> loadTodayGoal() async {
    try {
      final today = DateTime.now();
      final goal = await _repository.getDailyGoalByDate(today);

      if (goal == null) {
        // Cria goal padrão baseado no perfil do usuário
        await _createDefaultGoalForToday();
      } else {
        // Atualiza com o total atual de água
        await _updateGoalWithCurrentTotal(goal);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> _createDefaultGoalForToday() async {
    final userProfile = _ref.read(currentUserProfileProvider);
    final today = DateTime.now();

    final defaultTarget = userProfile?.defaultDailyGoal ?? 2000; // 2L padrão
    final currentTotal = _ref.read(todayWaterTotalProvider);

    final newGoal = DailyGoal(
      targetAmount: defaultTarget,
      date: today,
      currentAmount: currentTotal,
    );

    await _repository.saveDailyGoal(newGoal);
    state = AsyncValue.data(newGoal);
  }

  Future<void> _updateGoalWithCurrentTotal(DailyGoal goal) async {
    final currentTotal = _ref.read(todayWaterTotalProvider);

    if (goal.currentAmount != currentTotal) {
      final updatedGoal = goal.copyWith(currentAmount: currentTotal);
      await _repository.saveDailyGoal(updatedGoal);
      state = AsyncValue.data(updatedGoal);
    } else {
      state = AsyncValue.data(goal);
    }
  }

  Future<void> updateDailyTarget(int newTarget) async {
    final currentGoal = state.value;
    if (currentGoal != null) {
      final updatedGoal = currentGoal.copyWith(targetAmount: newTarget);
      await _repository.saveDailyGoal(updatedGoal);
      state = AsyncValue.data(updatedGoal);
    }
  }

  Future<void> refreshGoal() async {
    await loadTodayGoal();
  }
}

final dailyGoalProvider =
    StateNotifierProvider<DailyGoalNotifier, AsyncValue<DailyGoal?>>((ref) {
      final repository = ref.watch(dailyGoalRepositoryProvider);
      return DailyGoalNotifier(repository, ref);
    });

// Provider que atualiza automaticamente a meta quando o total de água muda
final currentDailyGoalProvider = Provider<DailyGoal?>((ref) {
  final goalAsync = ref.watch(dailyGoalProvider);
  final waterTotal = ref.watch(todayWaterTotalProvider);

  final goal = goalAsync.value;
  if (goal == null) return null;

  // Retorna a meta com o total atual atualizado
  return goal.copyWith(currentAmount: waterTotal);
});

// Provider que combina goal com progresso em tempo real
final dailyProgressProvider = Provider<double>((ref) {
  final goal = ref.watch(currentDailyGoalProvider);

  if (goal == null || goal.targetAmount <= 0) return 0.0;

  return (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);
});
