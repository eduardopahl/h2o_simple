import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/water_intake.dart';
import '../../domain/repositories/water_intake_repository.dart';
import '../../domain/use_cases/add_water_intake_use_case.dart';
import '../../core/extensions/extensions.dart';
import '../../core/services/notification_service.dart';
import '../widgets/goal_achieved_dialog.dart';
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
  BuildContext? _context;
  bool _goalAchievedToday = false;
  int _previousTotal = 0; // Para detectar transição
  bool _isFirstLoad = true; // Para detectar primeira vez

  void setContext(BuildContext context) {
    _context = context;
  }

  Future<void> loadTodayIntakes() async {
    try {
      final today = DateTime.now();
      final intakes = await _repository.getWaterIntakesByDate(today);
      state = AsyncValue.data(intakes);

      // Reset flags para novo dia
      _goalAchievedToday = false;

      // Se é primeira carga e já tem dados, não deve mostrar popup
      if (_isFirstLoad) {
        _previousTotal = intakes.totalAmount; // Inicializa com total atual
        _isFirstLoad = false;
        if (intakes.totalAmount >= 2000) {
          _goalAchievedToday = true; // Evita popup se já está na meta
        }
      }
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

      // Verifica se a meta foi alcançada e cancela notificações se necessário
      await _checkAndUpdateNotifications();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addWaterIntakeEntity(WaterIntake intake) async {
    try {
      await _repository.addWaterIntake(intake);
      await loadTodayIntakes();

      // Verifica se a meta foi alcançada e cancela notificações se necessário
      await _checkAndUpdateNotifications();
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

  Future<void> _checkAndUpdateNotifications() async {
    try {
      final notificationService = NotificationService();
      await notificationService.checkAndUpdateNotificationsForGoal();

      // Verifica se a meta foi alcançada para mostrar popup
      final currentData = state.asData?.value ?? [];
      final totalToday = currentData.totalAmount;
      const goalAmount = 2000; // Meta padrão

      // Só mostra popup se:
      // 1. Meta foi alcançada agora (totalToday >= goalAmount)
      // 2. Meta não tinha sido alcançada antes (_previousTotal < goalAmount)
      // 3. Ainda não mostrou popup hoje (!_goalAchievedToday)
      // 4. Temos contexto válido
      if (totalToday >= goalAmount &&
          _previousTotal < goalAmount &&
          !_goalAchievedToday &&
          _context != null) {
        _goalAchievedToday = true;

        // Aguarda um frame para garantir que o contexto está válido
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_context != null && _context!.mounted) {
            showGoalAchievedDialog(_context!);
          }
        });
      }

      // Atualiza o total anterior para próxima comparação
      _previousTotal = totalToday;
    } catch (e) {
      // Falha silenciosa para não afetar a operação principal
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
