import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/water_intake.dart';
import '../../domain/repositories/water_intake_repository.dart';
import '../../domain/use_cases/add_water_intake_use_case.dart';
import '../../core/extensions/extensions.dart';
import '../../core/events/water_intake_events.dart';
import 'repository_providers.dart';
import 'use_case_providers.dart';
import 'notification_service_provider.dart';

class DailyWaterIntakeNotifier
    extends StateNotifier<AsyncValue<List<WaterIntake>>> {
  DailyWaterIntakeNotifier(
    this._repository,
    this._addWaterIntakeUseCase,
    this._ref,
  ) : super(const AsyncValue.loading()) {
    loadTodayIntakes();
  }

  final WaterIntakeRepository _repository;
  final AddWaterIntakeUseCase _addWaterIntakeUseCase;
  final Ref _ref; // Para acessar outros providers

  // Event stream para comunicação com UI sem acoplamento
  final List<WaterIntakeEvent> _events = [];
  bool _goalAchievedToday = false;
  int _previousTotal = 0;
  bool _isFirstLoad = true;

  /// Stream de eventos para a UI escutar
  List<WaterIntakeEvent> get events => List.unmodifiable(_events);

  /// Adiciona um evento e notifica listeners
  void _addEvent(WaterIntakeEvent event) {
    _events.add(event);
    // Remove eventos antigos para evitar memory leak
    if (_events.length > 10) {
      _events.removeAt(0);
    }
  }

  /// Limpa eventos processados
  void clearEvents() {
    _events.clear();
  }

  Future<void> loadTodayIntakes() async {
    try {
      final today = DateTime.now();
      final intakes = await _repository.getWaterIntakesByDate(today);
      state = AsyncValue.data(intakes);

      // Reset flags para novo dia
      _goalAchievedToday = false;

      // Se é primeira carga e já tem dados, não deve disparar evento de meta
      if (_isFirstLoad) {
        _previousTotal = intakes.totalAmount;
        _isFirstLoad = false;
        if (intakes.totalAmount >= 2000) {
          _goalAchievedToday = true; // Evita evento se já está na meta
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
    try {
      await _addWaterIntakeUseCase.execute(
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
    try {
      await _repository.addWaterIntake(intake);
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
    try {
      await _repository.removeWaterIntake(id);
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
      final notificationService = _ref.read(
        configuredNotificationServiceProvider,
      );
      await notificationService.checkAndUpdateNotificationsForGoal();

      // Verifica se a meta foi alcançada para disparar evento
      final currentData = state.asData?.value ?? [];
      final totalToday = currentData.totalAmount;
      const goalAmount = 2000; // Meta padrão

      // Dispara evento de progresso atualizado
      _addEvent(
        WaterIntakeEvent.goalProgressUpdated(
          totalAmount: totalToday,
          goalAmount: goalAmount,
          progress: (totalToday / goalAmount).clamp(0.0, 1.0),
        ),
      );

      // Só dispara evento de meta alcançada se:
      // 1. Meta foi alcançada agora (totalToday >= goalAmount)
      // 2. Meta não tinha sido alcançada antes (_previousTotal < goalAmount)
      // 3. Ainda não disparou evento hoje (!_goalAchievedToday)
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

      // Atualiza o total anterior para próxima comparação
      _previousTotal = totalToday;
    } catch (e) {
      // Falha silenciosa para não afetar a operação principal
      _addEvent(
        WaterIntakeEvent.error(message: 'errorCheckingNotifications', error: e),
      );
    }
  }
}

final dailyWaterIntakeProvider = StateNotifierProvider<
  DailyWaterIntakeNotifier,
  AsyncValue<List<WaterIntake>>
>((ref) {
  final repository = ref.watch(waterIntakeRepositoryProvider);
  final addWaterIntakeUseCase = ref.watch(addWaterIntakeUseCaseProvider);
  return DailyWaterIntakeNotifier(repository, addWaterIntakeUseCase, ref);
});

final dailyWaterIntakeListProvider = Provider<List<WaterIntake>>((ref) {
  return ref.watch(dailyWaterIntakeProvider).valueOrNull ?? [];
});

final todayWaterTotalProvider = Provider<int>((ref) {
  final intakes = ref.watch(dailyWaterIntakeListProvider);
  return intakes.totalAmount;
});
