import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/water_intake.dart';
import '../../providers/daily_water_intake_provider.dart';
import '../../providers/daily_goal_provider.dart';
import '../../controllers/water_intake_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/physics_water_container.dart';
import '../../widgets/water_progress_display.dart';
import '../../widgets/floating_add_buttons.dart';

class DailyTab extends ConsumerStatefulWidget {
  const DailyTab({super.key});

  @override
  ConsumerState<DailyTab> createState() => _DailyTabState();
}

class _DailyTabState extends ConsumerState<DailyTab> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _addWaterIntake(WaterIntake waterIntake) {
    try {
      ref
          .read(dailyWaterIntakeProvider.notifier)
          .addWaterIntakeEntity(waterIntake);
    } catch (e) {
      // Handle error silently or show user-friendly message
    }
  }

  @override
  Widget build(BuildContext context) {
    // Escuta mudanças no provider e processa eventos
    ref.listen<AsyncValue<List<WaterIntake>>>(dailyWaterIntakeProvider, (
      previous,
      next,
    ) {
      if (!context.mounted) return;

      final notifier = ref.read(dailyWaterIntakeProvider.notifier);
      final events = notifier.events;

      // Processa novos eventos
      for (final event in events) {
        WaterIntakeController.handleEvent(context, event);
      }

      // Limpa eventos processados
      notifier.clearEvents();
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Consumer(
          builder: (context, ref, child) {
            final todayTotalAsync = ref.watch(dailyWaterIntakeProvider);
            final currentGoalAsync = ref.watch(dailyGoalProvider);

            return todayTotalAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error:
                  (error, stack) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: AppTheme.errorColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Erro ao carregar dados',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            error.toString(),
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              ref.invalidate(dailyWaterIntakeProvider);
                              ref.invalidate(dailyGoalProvider);
                            },
                            child: const Text('Tentar novamente'),
                          ),
                        ],
                      ),
                    ),
                  ),
              data: (intakes) {
                final todayTotal = intakes.fold<int>(
                  0,
                  (total, intake) => total + intake.amount,
                );
                final currentGoal = currentGoalAsync.valueOrNull;
                final goalAmount =
                    currentGoal?.targetAmount.toDouble() ?? 2000.0;
                final progress = (todayTotal / goalAmount).clamp(0.0, 1.0);
                final isOverGoal = todayTotal > goalAmount;

                return PhysicsWaterContainer(
                  progress: progress,
                  child: Stack(
                    children: [
                      WaterProgressDisplay(
                        todayTotal: todayTotal,
                        goalAmount: goalAmount.toInt(),
                        isOverGoal: isOverGoal,
                      ),
                      FloatingAddButtons(
                        isExpanded: _isExpanded,
                        onToggle: _toggleExpanded,
                        onAddWater: _addWaterIntake,
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
