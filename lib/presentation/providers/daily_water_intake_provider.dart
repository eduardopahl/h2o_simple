import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/water_intake.dart';
import '../../domain/repositories/water_intake_repository.dart';
import 'repository_providers.dart';

class DailyWaterIntakeNotifier
    extends StateNotifier<AsyncValue<List<WaterIntake>>> {
  DailyWaterIntakeNotifier(this._repository)
    : super(const AsyncValue.loading()) {
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

  Future<void> addWaterIntake(WaterIntake intake) async {
    try {
      await _repository.addWaterIntake(intake);
      await loadTodayIntakes(); // Sempre recarrega apenas o dia atual
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> removeWaterIntake(String id) async {
    try {
      await _repository.removeWaterIntake(id);
      await loadTodayIntakes(); // Sempre recarrega apenas o dia atual
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// Provider específico para a aba Daily que sempre mostra dados do dia atual
final dailyWaterIntakeProvider = StateNotifierProvider<
  DailyWaterIntakeNotifier,
  AsyncValue<List<WaterIntake>>
>((ref) {
  final repository = ref.watch(waterIntakeRepositoryProvider);
  return DailyWaterIntakeNotifier(repository);
});

// Provider derivado para lista de intakes do dia atual
final dailyWaterIntakeListProvider = Provider<List<WaterIntake>>((ref) {
  return ref.watch(dailyWaterIntakeProvider).valueOrNull ?? [];
});

// Provider derivado para total do dia atual
final todayWaterTotalProvider = Provider<int>((ref) {
  final intakes = ref.watch(dailyWaterIntakeListProvider);
  return intakes.fold<int>(0, (total, intake) => total + intake.amount);
});
