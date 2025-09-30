import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/water_intake.dart';
import '../../domain/repositories/water_intake_repository.dart';
import '../../domain/use_cases/add_water_intake_use_case.dart';
import '../../core/extensions/extensions.dart';
import 'repository_providers.dart';
import 'use_case_providers.dart';

class DailyWaterIntakeNotifier
    extends StateNotifier<AsyncValue<List<WaterIntake>>> {
  DailyWaterIntakeNotifier(this._repository, this._addWaterIntakeUseCase)
    : super(const AsyncValue.loading()) {
    loadTodayIntakes();
  }

  final WaterIntakeRepository _repository;
  final AddWaterIntakeUseCase _addWaterIntakeUseCase;

  Future<void> loadTodayIntakes() async {
    try {
      final today = DateTime.now();
      final intakes = await _repository.getWaterIntakesByDate(today);
      state = AsyncValue.data(intakes);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addWaterIntake({
    required int amount,
    DateTime? timestamp,
    String? note,
  }) async {
    try {
      await _addWaterIntakeUseCase.execute(
        amount: amount,
        timestamp: timestamp,
        note: note,
      );
      await loadTodayIntakes();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addWaterIntakeEntity(WaterIntake intake) async {
    try {
      await _repository.addWaterIntake(intake);
      await loadTodayIntakes();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> removeWaterIntake(String id) async {
    try {
      await _repository.removeWaterIntake(id);
      await loadTodayIntakes();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final dailyWaterIntakeProvider = StateNotifierProvider<
  DailyWaterIntakeNotifier,
  AsyncValue<List<WaterIntake>>
>((ref) {
  final repository = ref.watch(waterIntakeRepositoryProvider);
  final addWaterIntakeUseCase = ref.watch(addWaterIntakeUseCaseProvider);
  return DailyWaterIntakeNotifier(repository, addWaterIntakeUseCase);
});

final dailyWaterIntakeListProvider = Provider<List<WaterIntake>>((ref) {
  return ref.watch(dailyWaterIntakeProvider).valueOrNull ?? [];
});

final todayWaterTotalProvider = Provider<int>((ref) {
  final intakes = ref.watch(dailyWaterIntakeListProvider);
  return intakes.totalAmount;
});
