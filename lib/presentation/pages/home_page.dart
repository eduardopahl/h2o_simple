import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/water_intake.dart';
import '../providers/water_intake_provider.dart';
import '../providers/daily_goal_provider.dart';
import '../providers/user_profile_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/water_progress_indicator.dart';
import '../widgets/quick_add_buttons.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _customAmountController = TextEditingController();

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }

  void _addWaterIntake(int amount) {
    final intake = WaterIntake(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      timestamp: DateTime.now(),
    );

    ref.read(waterIntakeProvider.notifier).addWaterIntake(intake);
    // Não precisa mais de refresh manual - os providers são reativos
  }

  void _showCustomAmountDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Quantidade Personalizada'),
            content: TextField(
              controller: _customAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantidade em ml',
                hintText: 'Ex: 300',
              ),
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _customAmountController.clear();
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  final amount = int.tryParse(_customAmountController.text);
                  if (amount != null && amount > 0) {
                    _addWaterIntake(amount);
                    Navigator.of(context).pop();
                    _customAmountController.clear();
                  }
                },
                child: const Text('Adicionar'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final todayWaterTotal = ref.watch(todayWaterTotalProvider);
    final dailyGoal = ref.watch(currentDailyGoalProvider);
    final userProfile = ref.watch(currentUserProfileProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('H2O Simple'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navegação para configurações
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(todayWaterTotalProvider);
          await ref.read(waterIntakeProvider.notifier).loadTodayIntakes();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Saudação e data
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userProfile != null
                            ? 'Olá, ${userProfile.name}!'
                            : 'Olá!',
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat(
                          'EEEE, d MMMM yyyy',
                          'pt_BR',
                        ).format(DateTime.now()),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Indicador de progresso
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Builder(
                        builder: (context) {
                          final goal = dailyGoal;
                          final target = goal?.targetAmount ?? 2000;
                          final total = todayWaterTotal;
                          final progress = target > 0 ? (total / target) : 0.0;

                          return WaterProgressIndicator(
                            progress: progress,
                            currentAmount: total,
                            targetAmount: target,
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      Builder(
                        builder: (context) {
                          final goal = dailyGoal;
                          final target = goal?.targetAmount ?? 2000;
                          final total = todayWaterTotal;
                          final remaining = target - total;

                          if (remaining <= 0) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.progressCompleted.withOpacity(
                                  0.1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '🎉 Meta atingida!',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: AppTheme.progressCompleted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          } else {
                            return Text(
                              'Faltam ${remaining}ml para sua meta',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Botões de adição rápida
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Adicionar Água',
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      QuickAddButtonsGrid(onAmountSelected: _addWaterIntake),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _showCustomAmountDialog,
                          icon: const Icon(Icons.add),
                          label: const Text('Quantidade Personalizada'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Histórico do dia
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hoje', style: theme.textTheme.headlineSmall),
                      const SizedBox(height: 12),
                      Consumer(
                        builder: (context, ref, child) {
                          final intakesAsync = ref.watch(waterIntakeProvider);

                          return intakesAsync.when(
                            data: (intakes) {
                              if (intakes.isEmpty) {
                                return Container(
                                  padding: const EdgeInsets.all(24),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.water_drop_outlined,
                                          size: 48,
                                          color: Colors.grey[400],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Nenhum registro hoje',
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: intakes.length,
                                separatorBuilder:
                                    (context, index) => const Divider(),
                                itemBuilder: (context, index) {
                                  final intake = intakes[index];
                                  return ListTile(
                                    leading: const CircleAvatar(
                                      backgroundColor: AppTheme.primaryBlue,
                                      child: Icon(
                                        Icons.water_drop,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    title: Text('${intake.amount}ml'),
                                    subtitle: Text(
                                      DateFormat(
                                        'HH:mm',
                                      ).format(intake.timestamp),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: () {
                                        ref
                                            .read(waterIntakeProvider.notifier)
                                            .removeWaterIntake(intake.id);
                                        // Não precisa mais de refresh manual - os providers são reativos
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            loading:
                                () => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                            error:
                                (error, stack) => Center(
                                  child: Text(
                                    'Erro ao carregar registros',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
