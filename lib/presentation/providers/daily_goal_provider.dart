import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/daily_goal.dart';
import 'repository_providers.dart';
import 'user_profile_provider.dart';
import 'water_intake_provider.dart';

class DailyGoalNotifier extends AsyncNotifier<DailyGoal?> {
  @override
  Future<DailyGoal?> build() async {
    return await _loadTodayGoal();
  }

  Future<DailyGoal?> _loadTodayGoal() async {
    final repository = ref.read(dailyGoalRepositoryProvider);
    final today = DateTime.now();
    final goal = await repository.getDailyGoalByDate(today);
    if (goal == null) {
      return await _createDefaultGoalForToday();
    } else {
      return await _updateGoalWithCurrentTotal(goal);
    }
  }

  Future<DailyGoal?> _createDefaultGoalForToday() async {
    final repository = ref.read(dailyGoalRepositoryProvider);
    final today = DateTime.now();
    final currentTotal = ref.read(todayWaterTotalProvider);
    final newGoal = DailyGoal(date: today, currentAmount: currentTotal);
    await repository.saveDailyGoal(newGoal);
    return newGoal;
  }

  Future<DailyGoal?> _updateGoalWithCurrentTotal(DailyGoal goal) async {
    final repository = ref.read(dailyGoalRepositoryProvider);
    final currentTotal = ref.read(todayWaterTotalProvider);
    if (goal.currentAmount != currentTotal) {
      final updatedGoal = goal.copyWith(currentAmount: currentTotal);
      await repository.saveDailyGoal(updatedGoal);
      return updatedGoal;
    }
    return goal;
  }

  Future<void> updateDailyTarget(int newTarget) async {
    final userProfile = ref.read(currentUserProfileProvider);
    if (userProfile != null) {
      final updatedProfile = userProfile.copyWith(defaultDailyGoal: newTarget);
      final notifier = ref.read(userProfileProvider.notifier);
      await notifier.updateUserProfile(updatedProfile);
    }
  }

  Future<void> refreshGoal() async {
    state = const AsyncValue.loading();
    try {
      final goal = await _loadTodayGoal();
      state = AsyncValue.data(goal);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final dailyGoalProvider = AsyncNotifierProvider<DailyGoalNotifier, DailyGoal?>(
  DailyGoalNotifier.new,
);

final currentDailyGoalProvider = Provider<DailyGoal?>((ref) {
  final goalAsync = ref.watch(dailyGoalProvider);
  final waterTotal = ref.watch(todayWaterTotalProvider);
  final goal = goalAsync.value;
  if (goal == null) return null;
  return goal.copyWith(currentAmount: waterTotal);
});

final dailyProgressProvider = Provider<double>((ref) {
  final goal = ref.watch(currentDailyGoalProvider);
  final userProfile = ref.watch(currentUserProfileProvider);
  final target = userProfile?.defaultDailyGoal ?? 2000;
  if (goal == null || target <= 0) return 0.0;
  return (goal.currentAmount / target).clamp(0.0, 1.0);
});
