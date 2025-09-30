import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/use_cases/add_water_intake_use_case.dart';
import '../../domain/use_cases/calculate_hydration_stats_use_case.dart';
import 'repository_providers.dart';

final addWaterIntakeUseCaseProvider = Provider<AddWaterIntakeUseCase>((ref) {
  final repository = ref.watch(waterIntakeRepositoryProvider);
  return AddWaterIntakeUseCase(repository);
});

final calculateHydrationStatsUseCaseProvider =
    Provider<CalculateHydrationStatsUseCase>((ref) {
      final repository = ref.watch(waterIntakeRepositoryProvider);
      return CalculateHydrationStatsUseCase(repository);
    });
