import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/daily_goal_provider.dart';
import '../../providers/theme_provider.dart';
import '../../theme/app_theme.dart';

class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentGoal = ref.watch(currentDailyGoalProvider);
    final goalAmount = currentGoal?.targetAmount.toDouble() ?? 2000.0;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Configurações',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Card de Meta Diária
              _buildDailyGoalCard(context, ref, goalAmount),
              const SizedBox(height: 16),

              // Card de Aparência
              _buildThemeCard(context, ref),
              const SizedBox(height: 16),

              // Card de Notificações
              _buildNotificationsCard(context),
              const SizedBox(height: 16),

              // Card Sobre o App
              _buildAboutCard(context),
              const SizedBox(height: 24),

              // Botão de Reset
              _buildResetButton(context, ref),
              const SizedBox(height: 16), // Espaço extra no final
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyGoalCard(
    BuildContext context,
    WidgetRef ref,
    double goalAmount,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flag, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Meta Diária',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Meta atual: ${goalAmount.toStringAsFixed(0)}ml',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showGoalDialog(context, ref, goalAmount),
                child: const Text('Alterar Meta'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeCard(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Aparência',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Consumer(
              builder: (context, ref, child) {
                final themeMode = ref.watch(themeProvider);
                final themeNotifier = ref.read(themeProvider.notifier);

                return Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Tema Claro'),
                      subtitle: const Text('Interface com cores claras'),
                      value: ThemeMode.light,
                      groupValue: themeMode,
                      onChanged: (ThemeMode? value) {
                        if (value != null) {
                          themeNotifier.setThemeMode(value);
                        }
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Tema Escuro'),
                      subtitle: const Text('Interface com cores escuras'),
                      value: ThemeMode.dark,
                      groupValue: themeMode,
                      onChanged: (ThemeMode? value) {
                        if (value != null) {
                          themeNotifier.setThemeMode(value);
                        }
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Sistema'),
                      subtitle: const Text('Seguir configuração do sistema'),
                      value: ThemeMode.system,
                      groupValue: themeMode,
                      onChanged: (ThemeMode? value) {
                        if (value != null) {
                          themeNotifier.setThemeMode(value);
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Notificações',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Lembrete para beber água',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                'Receba notificações regulares',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: Switch(
                value: false,
                onChanged: (value) {
                  // TODO: Implementar lógica de notificações
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Sobre o App',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'H2O Simple v1.0.0',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              'App para acompanhar seu consumo diário de água e manter uma hidratação saudável.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResetButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showResetDialog(context, ref),
        icon: const Icon(Icons.refresh),
        label: const Text('Resetar Dados'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.error,
          side: BorderSide(color: Theme.of(context).colorScheme.error),
          padding: const EdgeInsets.symmetric(vertical: 16),
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
                        backgroundColor: AppTheme.successColor,
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
                      backgroundColor: AppTheme.warningColor,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.warningColor,
                  foregroundColor: AppTheme.surfaceColor,
                ),
                child: const Text('Resetar'),
              ),
            ],
          ),
    );
  }
}
