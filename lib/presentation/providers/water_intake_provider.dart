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

  Future<void> addWaterIntake(WaterIntake intake) async {
    try {
      await _repository.addWaterIntake(intake);
      // Recarrega os dados
      await loadTodayIntakes();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> removeWaterIntake(String id) async {
    try {
      await _repository.removeWaterIntake(id);
      // Recarrega os dados
      await loadTodayIntakes();
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

// Provider simples para acessar a lista sem AsyncValue
final waterIntakeListProvider = Provider<List<WaterIntake>>((ref) {
  return ref.watch(waterIntakeProvider).valueOrNull ?? [];
});

// Provider para total de água do dia atual - agora reativo aos dados
final todayWaterTotalProvider = Provider<int>((ref) {
  final intakes = ref.watch(waterIntakeListProvider);
  return intakes.fold<int>(0, (total, intake) => total + intake.amount);
});
