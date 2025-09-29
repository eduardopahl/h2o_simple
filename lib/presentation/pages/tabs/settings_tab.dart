import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/daily_goal_provider.dart';

class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentGoal = ref.watch(currentDailyGoalProvider);
    final goalAmount = currentGoal?.targetAmount.toDouble() ?? 2000.0;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configurações',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.flag, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Meta Diária',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Meta atual: ${goalAmount.toStringAsFixed(0)}ml',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            () => _showGoalDialog(context, ref, goalAmount),
                        child: const Text('Alterar Meta'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.notifications,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Notificações',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Lembrete para beber água'),
                      subtitle: const Text('Receba notificações regulares'),
                      trailing: Switch(value: false, onChanged: (value) {}),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Sobre o App',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('H2O Simple v1.0.0'),
                    const SizedBox(height: 8),
                    const Text(
                      'App para acompanhar seu consumo diário de água e manter uma hidratação saudável.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showResetDialog(context, ref),
                icon: const Icon(Icons.refresh, color: Colors.orange),
                label: const Text('Resetar Dados'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.orange,
                  side: const BorderSide(color: Colors.orange),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGoalDialog(
    BuildContext context,
    WidgetRef ref,
    double currentGoal,
  ) {
    final TextEditingController controller = TextEditingController(
      text: currentGoal.toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Alterar Meta Diária'),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Meta (ml)',
                border: OutlineInputBorder(),
                helperText: 'Recomendado: 2000ml - 2500ml por dia',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  final newGoal = int.tryParse(controller.text);
                  if (newGoal != null && newGoal > 0) {
                    ref
                        .read(dailyGoalProvider.notifier)
                        .updateDailyTarget(newGoal);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Meta alterada para ${newGoal}ml'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Resetar Dados'),
            content: const Text(
              'Tem certeza que deseja resetar todos os dados? Esta ação não pode ser desfeita.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Dados resetados com sucesso'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Resetar'),
              ),
            ],
          ),
    );
  }
}
