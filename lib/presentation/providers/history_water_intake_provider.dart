import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/water_intake.dart';
import 'repository_providers.dart';
import '../widgets/period_selector.dart';
import 'daily_water_intake_provider.dart';

class HistoryWaterIntakeNotifier extends AsyncNotifier<List<WaterIntake>> {
  @override
  Future<List<WaterIntake>> build() async {
    return [];
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

  Future<void> loadWeekIntakes(DateTime date) async {
    final repository = ref.read(waterIntakeRepositoryProvider);
    state = const AsyncValue.loading();
    try {
      final weekStart = date.subtract(Duration(days: date.weekday - 1));
      final allIntakes = <WaterIntake>[];
      for (int i = 0; i < 7; i++) {
        final dayDate = weekStart.add(Duration(days: i));
        final dayIntakes = await repository.getWaterIntakesByDate(dayDate);
        allIntakes.addAll(dayIntakes);
      }
      state = AsyncValue.data(allIntakes);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadMonthIntakes(DateTime date) async {
    final repository = ref.read(waterIntakeRepositoryProvider);
    state = const AsyncValue.loading();
    try {
      final monthEnd = DateTime(date.year, date.month + 1, 0);
      final allIntakes = <WaterIntake>[];
      for (int day = 1; day <= monthEnd.day; day++) {
        final dayDate = DateTime(date.year, date.month, day);
        final dayIntakes = await repository.getWaterIntakesByDate(dayDate);
        allIntakes.addAll(dayIntakes);
      }
      state = AsyncValue.data(allIntakes);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> removeWaterIntake(
    String id, {
    DateTime? reloadDate,
    TimePeriod? period,
  }) async {
    final repository = ref.read(waterIntakeRepositoryProvider);
    try {
      final today = DateTime.now();
      bool shouldInvalidateDaily = false;

      final currentData = state.value;
      if (currentData != null) {
        final itemToDelete = currentData.firstWhere(
          (intake) => intake.id == id,
          orElse:
              () => WaterIntake(
                id: '',
                amount: 0,
                timestamp: DateTime(2000),
              ),
        );

        if (itemToDelete.id.isNotEmpty &&
            itemToDelete.timestamp.day == today.day &&
            itemToDelete.timestamp.month == today.month &&
            itemToDelete.timestamp.year == today.year) {
          shouldInvalidateDaily = true;
        }
      }

      await repository.removeWaterIntake(id);

      if (shouldInvalidateDaily) {
        ref.invalidate(dailyWaterIntakeProvider);
      }

      if (reloadDate != null && period != null) {
        switch (period) {
          case TimePeriod.day:
            await loadIntakesByDate(reloadDate);
          case TimePeriod.week:
            await loadWeekIntakes(reloadDate);
          case TimePeriod.month:
            await loadMonthIntakes(reloadDate);
        }
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

final historyWaterIntakeProvider =
    AsyncNotifierProvider<HistoryWaterIntakeNotifier, List<WaterIntake>>(
      HistoryWaterIntakeNotifier.new,
    );

final historyWaterIntakeListProvider = Provider<List<WaterIntake>>((ref) {
  return ref.watch(historyWaterIntakeProvider).value ?? [];
});
