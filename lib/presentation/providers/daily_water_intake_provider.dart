import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/water_intake.dart';
import '../../core/extensions/extensions.dart';
import '../../core/events/water_intake_events.dart';
import 'repository_providers.dart';
import 'use_case_providers.dart';
import 'notification_service_provider.dart';
import 'user_profile_provider.dart';

class DailyWaterIntakeNotifier extends AsyncNotifier<List<WaterIntake>> {
  final List<WaterIntakeEvent> _events = [];
  bool _goalAchievedToday = false;
  int _previousTotal = 0;
  bool _isFirstLoad = true;

  @override
  Future<List<WaterIntake>> build() async {
    final repository = ref.watch(waterIntakeRepositoryProvider);
    final today = DateTime.now();
    final intakes = await repository.getWaterIntakesByDate(today);
    _goalAchievedToday = false;
    if (_isFirstLoad) {
      _previousTotal = intakes.totalAmount;
      _isFirstLoad = false;
      if (intakes.totalAmount >= 2000) {
        _goalAchievedToday = true;
      }
    }
    return intakes;
  }

  List<WaterIntakeEvent> get events => List.unmodifiable(_events);

  void _addEvent(WaterIntakeEvent event) {
    _events.add(event);
    if (_events.length > 10) {
      _events.removeAt(0);
    }
  }

  void clearEvents() {
    _events.clear();
  }

  Future<void> loadTodayIntakes() async {
    final repository = ref.read(waterIntakeRepositoryProvider);
    state = const AsyncValue.loading();
    try {
      final today = DateTime.now();
      final intakes = await repository.getWaterIntakesByDate(today);
      state = AsyncValue.data(intakes);
      _goalAchievedToday = false;
      if (_isFirstLoad) {
        _previousTotal = intakes.totalAmount;
        _isFirstLoad = false;
        if (intakes.totalAmount >= 2000) {
          _goalAchievedToday = true;
        }
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      _addEvent(
        WaterIntakeEvent.error(
          message: 'errorLoadingHydrationData',
          error: error,
        ),
      );
    }
  }

  Future<void> addWaterIntake({
    required int amount,
    DateTime? timestamp,
    String? note,
  }) async {
    final addWaterIntakeUseCase = ref.read(addWaterIntakeUseCaseProvider);
    try {
      await addWaterIntakeUseCase.execute(
        amount: amount,
        timestamp: timestamp,
        note: note,
      );
      await loadTodayIntakes();
      await _checkAndUpdateNotifications();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      _addEvent(
        WaterIntakeEvent.error(message: 'errorAddingWaterIntake', error: error),
      );
    }
  }

  Future<void> addWaterIntakeEntity(WaterIntake intake) async {
    final repository = ref.read(waterIntakeRepositoryProvider);
    try {
      await repository.addWaterIntake(intake);
      await loadTodayIntakes();
      await _checkAndUpdateNotifications();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      _addEvent(
        WaterIntakeEvent.error(message: 'errorAddingWaterIntake', error: error),
      );
    }
  }

  Future<void> removeWaterIntake(String id) async {
    final repository = ref.read(waterIntakeRepositoryProvider);
    try {
      await repository.removeWaterIntake(id);
      await loadTodayIntakes();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      _addEvent(
        WaterIntakeEvent.error(
          message: 'errorRemovingWaterIntake',
          error: error,
        ),
      );
    }
  }

  Future<void> _checkAndUpdateNotifications() async {
    try {
      final notificationService = ref.read(
        configuredNotificationServiceProvider,
      );
      await notificationService.checkAndUpdateNotificationsForGoal();

      final currentData = state.value ?? [];
      final totalToday = currentData.totalAmount;
      final userProfile = ref.read(currentUserProfileProvider);
      final goalAmount = userProfile?.defaultDailyGoal ?? 2000;

      _addEvent(
        WaterIntakeEvent.goalProgressUpdated(
          totalAmount: totalToday,
          goalAmount: goalAmount,
          progress:
              goalAmount > 0
                  ? (totalToday / goalAmount).clamp(0.0, 1.0)
                  : 0.0,
        ),
      );

      if (totalToday >= goalAmount &&
          _previousTotal < goalAmount &&
          !_goalAchievedToday) {
        _goalAchievedToday = true;
        _addEvent(
          WaterIntakeEvent.goalAchieved(
            totalAmount: totalToday,
            goalAmount: goalAmount,
          ),
        );
      }

      _previousTotal = totalToday;
    } catch (e) {
      _addEvent(
        WaterIntakeEvent.error(message: 'errorCheckingNotifications', error: e),
      );
    }
  }
}

final dailyWaterIntakeProvider =
    AsyncNotifierProvider<DailyWaterIntakeNotifier, List<WaterIntake>>(
      DailyWaterIntakeNotifier.new,
    );

final dailyWaterIntakeListProvider = Provider<List<WaterIntake>>((ref) {
  return ref.watch(dailyWaterIntakeProvider).value ?? [];
});

final todayWaterTotalProvider = Provider<int>((ref) {
  final intakes = ref.watch(dailyWaterIntakeListProvider);
  return intakes.totalAmount;
});
