import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/water_intake.dart';
import '../../providers/water_intake_provider.dart';
import '../../providers/daily_goal_provider.dart';

class DailyTab extends ConsumerWidget {
  const DailyTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayTotal = ref.watch(todayWaterTotalProvider);
    final currentGoal = ref.watch(currentDailyGoalProvider);
    final goalAmount = currentGoal?.targetAmount.toDouble() ?? 2000.0;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header com progresso
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Consumo de Água Hoje',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Indicador circular de progresso
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: todayTotal / goalAmount,
                        strokeWidth: 8,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue.shade400,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    Text(
                      '${todayTotal.toStringAsFixed(0)}ml',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'de ${goalAmount.toStringAsFixed(0)}ml',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Botões de adição rápida
            Text(
              'Adicionar água',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickAddButton(context, ref, 250, '250ml'),
                _buildQuickAddButton(context, ref, 500, '500ml'),
                _buildQuickAddButton(context, ref, 750, '750ml'),
              ],
            ),

            const SizedBox(height: 16),

            // Botão de adição customizada
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showCustomAmountDialog(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('Quantidade Personalizada'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Estatísticas do dia
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      context,
                      'Meta',
                      '${goalAmount.toStringAsFixed(0)}ml',
                      Icons.flag,
                    ),
                    _buildStatItem(
                      context,
                      'Restante',
                      '${(goalAmount - todayTotal).clamp(0, double.infinity).toStringAsFixed(0)}ml',
                      Icons.water_drop_outlined,
                    ),
                    _buildStatItem(
                      context,
                      'Progresso',
                      '${((todayTotal / goalAmount) * 100).clamp(0, 100).toStringAsFixed(0)}%',
                      Icons.trending_up,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAddButton(
    BuildContext context,
    WidgetRef ref,
    double amount,
    String label,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: () => _addWater(ref, amount),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.water_drop),
              const SizedBox(height: 4),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(title, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  void _addWater(WidgetRef ref, double amount) {
    final waterIntake = WaterIntake(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount.toInt(),
      timestamp: DateTime.now(),
    );
    ref.read(waterIntakeProvider.notifier).addWaterIntake(waterIntake);
  }

  void _showCustomAmountDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Adicionar Água'),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantidade (ml)',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  final amount = double.tryParse(controller.text);
                  if (amount != null && amount > 0) {
                    _addWater(ref, amount);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Adicionar'),
              ),
            ],
          ),
    );
  }
}
