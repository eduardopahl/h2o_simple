import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/water_intake.dart';
import '../../domain/repositories/water_intake_repository.dart';
import 'repository_providers.dart';
import '../widgets/period_selector.dart';

class HistoryWaterIntakeNotifier
    extends StateNotifier<AsyncValue<List<WaterIntake>>> {
  HistoryWaterIntakeNotifier(this._repository)
    : super(const AsyncValue.loading());

  final WaterIntakeRepository _repository;

  Future<void> loadIntakesByDate(DateTime date) async {
    state = const AsyncValue.loading();
    try {
      final intakes = await _repository.getWaterIntakesByDate(date);
      state = AsyncValue.data(intakes);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadWeekIntakes(DateTime date) async {
    state = const AsyncValue.loading();
    try {
      // Calcular início da semana baseado na data fornecida
      final weekStart = date.subtract(Duration(days: date.weekday - 1));

      List<WaterIntake> allIntakes = [];
      for (int i = 0; i < 7; i++) {
        final dayDate = weekStart.add(Duration(days: i));
        final dayIntakes = await _repository.getWaterIntakesByDate(dayDate);
        allIntakes.addAll(dayIntakes);
      }

      state = AsyncValue.data(allIntakes);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadMonthIntakes(DateTime date) async {
    state = const AsyncValue.loading();
    try {
      final monthEnd = DateTime(date.year, date.month + 1, 0);

      List<WaterIntake> allIntakes = [];
      for (int day = 1; day <= monthEnd.day; day++) {
        final dayDate = DateTime(date.year, date.month, day);
        final dayIntakes = await _repository.getWaterIntakesByDate(dayDate);
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
    try {
      await _repository.removeWaterIntake(id);

      // Recarregar dados baseado no período e data atual
      if (reloadDate != null && period != null) {
        switch (period) {
          case TimePeriod.day:
            await loadIntakesByDate(reloadDate);
            break;
          case TimePeriod.week:
            await loadWeekIntakes(reloadDate);
            break;
          case TimePeriod.month:
            await loadMonthIntakes(reloadDate);
            break;
        }
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<int> getTotalForDate(DateTime date) async {
    return await _repository.getTotalWaterIntakeByDate(date);
  }
}

// Provider específico para a aba History
final historyWaterIntakeProvider = StateNotifierProvider<
  HistoryWaterIntakeNotifier,
  AsyncValue<List<WaterIntake>>
>((ref) {
  final repository = ref.watch(waterIntakeRepositoryProvider);
  return HistoryWaterIntakeNotifier(repository);
});

// Provider derivado para lista de intakes da aba History
final historyWaterIntakeListProvider = Provider<List<WaterIntake>>((ref) {
  return ref.watch(historyWaterIntakeProvider).valueOrNull ?? [];
});
