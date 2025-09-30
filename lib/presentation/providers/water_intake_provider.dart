import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/water_intake.dart';
import '../../domain/repositories/water_intake_repository.dart';
import 'repository_providers.dart';

class WaterIntakeNotifier extends StateNotifier<AsyncValue<List<WaterIntake>>> {
  WaterIntakeNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadTodayIntakes();
  }

  final WaterIntakeRepository _repository;

  Future<void> loadTodayIntakes() async {
    try {
      final today = DateTime.now();
      final intakes = await _repository.getWaterIntakesByDate(today);
      state = AsyncValue.data(intakes);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadIntakesByDate(DateTime date) async {
    state = const AsyncValue.loading();
    try {
      final intakes = await _repository.getWaterIntakesByDate(date);
      state = AsyncValue.data(intakes);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadWeekIntakes() async {
    state = const AsyncValue.loading();
    try {
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));

      List<WaterIntake> allIntakes = [];
      for (int i = 0; i < 7; i++) {
        final date = weekStart.add(Duration(days: i));
        final dayIntakes = await _repository.getWaterIntakesByDate(date);
        allIntakes.addAll(dayIntakes);
      }

      state = AsyncValue.data(allIntakes);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadMonthIntakes() async {
    state = const AsyncValue.loading();
    try {
      final now = DateTime.now();
      final monthEnd = DateTime(now.year, now.month + 1, 0);

      List<WaterIntake> allIntakes = [];
      for (int day = 1; day <= monthEnd.day; day++) {
        final date = DateTime(now.year, now.month, day);
        final dayIntakes = await _repository.getWaterIntakesByDate(date);
        allIntakes.addAll(dayIntakes);
      }

      state = AsyncValue.data(allIntakes);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addWaterIntake(WaterIntake intake) async {
    try {
      await _repository.addWaterIntake(intake);
      await loadTodayIntakes();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> removeWaterIntake(String id, {DateTime? reloadDate}) async {
    try {
      await _repository.removeWaterIntake(id);
      if (reloadDate != null) {
        await loadIntakesByDate(reloadDate);
      } else {
        await loadTodayIntakes();
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<int> getTotalForDate(DateTime date) async {
    return await _repository.getTotalWaterIntakeByDate(date);
  }
}

final waterIntakeProvider =
    StateNotifierProvider<WaterIntakeNotifier, AsyncValue<List<WaterIntake>>>((
      ref,
    ) {
      final repository = ref.watch(waterIntakeRepositoryProvider);
      return WaterIntakeNotifier(repository);
    });

final waterIntakeListProvider = Provider<List<WaterIntake>>((ref) {
  return ref.watch(waterIntakeProvider).valueOrNull ?? [];
});

final todayWaterTotalProvider = Provider<int>((ref) {
  final intakes = ref.watch(waterIntakeListProvider);
  return intakes.fold<int>(0, (total, intake) => total + intake.amount);
});
