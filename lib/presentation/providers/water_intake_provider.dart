import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/water_intake.dart';
import 'repository_providers.dart';

class WaterIntakeNotifier extends AsyncNotifier<List<WaterIntake>> {
  @override
  Future<List<WaterIntake>> build() async {
    final repository = ref.watch(waterIntakeRepositoryProvider);
    final today = DateTime.now();
    return await repository.getWaterIntakesByDate(today);
  }

  Future<void> loadTodayIntakes() async {
    final repository = ref.read(waterIntakeRepositoryProvider);
    state = const AsyncValue.loading();
    try {
      final today = DateTime.now();
      final intakes = await repository.getWaterIntakesByDate(today);
      state = AsyncValue.data(intakes);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadIntakesByDate(DateTime date) async {
    final repository = ref.read(waterIntakeRepositoryProvider);
    state = const AsyncValue.loading();
    try {
      final intakes = await repository.getWaterIntakesByDate(date);
      state = AsyncValue.data(intakes);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadWeekIntakes() async {
    final repository = ref.read(waterIntakeRepositoryProvider);
    state = const AsyncValue.loading();
    try {
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final allIntakes = <WaterIntake>[];
      for (int i = 0; i < 7; i++) {
        final date = weekStart.add(Duration(days: i));
        final dayIntakes = await repository.getWaterIntakesByDate(date);
        allIntakes.addAll(dayIntakes);
      }
      state = AsyncValue.data(allIntakes);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadMonthIntakes() async {
    final repository = ref.read(waterIntakeRepositoryProvider);
    state = const AsyncValue.loading();
    try {
      final now = DateTime.now();
      final monthEnd = DateTime(now.year, now.month + 1, 0);
      final allIntakes = <WaterIntake>[];
      for (int day = 1; day <= monthEnd.day; day++) {
        final date = DateTime(now.year, now.month, day);
        final dayIntakes = await repository.getWaterIntakesByDate(date);
        allIntakes.addAll(dayIntakes);
      }
      state = AsyncValue.data(allIntakes);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addWaterIntake(WaterIntake intake) async {
    final repository = ref.read(waterIntakeRepositoryProvider);
    try {
      await repository.addWaterIntake(intake);
      await loadTodayIntakes();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> removeWaterIntake(String id, {DateTime? reloadDate}) async {
    final repository = ref.read(waterIntakeRepositoryProvider);
    try {
      await repository.removeWaterIntake(id);
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
    final repository = ref.read(waterIntakeRepositoryProvider);
    return await repository.getTotalWaterIntakeByDate(date);
  }
}

final waterIntakeProvider =
    AsyncNotifierProvider<WaterIntakeNotifier, List<WaterIntake>>(
      WaterIntakeNotifier.new,
    );

final waterIntakeListProvider = Provider<List<WaterIntake>>((ref) {
  return ref.watch(waterIntakeProvider).value ?? [];
});

final todayWaterTotalProvider = Provider<int>((ref) {
  final intakes = ref.watch(waterIntakeListProvider);
  return intakes.fold<int>(0, (total, intake) => total + intake.amount);
});
