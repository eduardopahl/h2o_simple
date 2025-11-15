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
        await _createDefaultGoalForToday();
      } else {
        await _updateGoalWithCurrentTotal(goal);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> _createDefaultGoalForToday() async {
    final today = DateTime.now();
    final currentTotal = _ref.read(todayWaterTotalProvider);
    final newGoal = DailyGoal(date: today, currentAmount: currentTotal);
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
    // Agora só atualiza o perfil do usuário
    final userProfile = _ref.read(currentUserProfileProvider);
    if (userProfile != null) {
      final updatedProfile = userProfile.copyWith(defaultDailyGoal: newTarget);
      final notifier = _ref.read(userProfileProvider.notifier);
      await notifier.updateUserProfile(updatedProfile);
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

final currentDailyGoalProvider = Provider<DailyGoal?>((ref) {
  final goalAsync = ref.watch(dailyGoalProvider);
  final waterTotal = ref.watch(todayWaterTotalProvider);
  final goal = goalAsync.value;
  if (goal == null) return null;
  // A meta diária agora é sempre a do perfil, mas mantemos o objeto DailyGoal para data e progresso
  return goal.copyWith(currentAmount: waterTotal);
});

final dailyProgressProvider = Provider<double>((ref) {
  final goal = ref.watch(currentDailyGoalProvider);
  final userProfile = ref.watch(currentUserProfileProvider);
  final target = userProfile?.defaultDailyGoal ?? 2000;
  if (goal == null || target <= 0) return 0.0;
  return (goal.currentAmount / target).clamp(0.0, 1.0);
});
