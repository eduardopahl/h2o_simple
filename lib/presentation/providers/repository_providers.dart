import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/water_intake_repository.dart';
import '../../domain/repositories/daily_goal_repository.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../data/repositories/water_intake_repository_impl.dart';
import '../../data/repositories/daily_goal_repository_impl.dart';
import '../../data/repositories/user_profile_repository_impl.dart';

final waterIntakeRepositoryProvider = Provider<WaterIntakeRepository>((ref) {
  return WaterIntakeRepositoryImpl();
});

final dailyGoalRepositoryProvider = Provider<DailyGoalRepository>((ref) {
  return DailyGoalRepositoryImpl();
});

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepositoryImpl();
});
