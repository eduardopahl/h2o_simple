import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/daily_goal_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/notification_settings_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_snackbar.dart';
import '../../../core/services/notification_service.dart' as custom;

class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentGoal = ref.watch(currentDailyGoalProvider);
    final goalAmount = currentGoal?.targetAmount.toDouble() ?? 2000.0;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Configurações',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Seção Principal
              _buildSection(
                context,
                children: [
                  _buildDailyGoalTile(context, ref, goalAmount),
                  _buildDarkModeTile(context, ref),
                  _buildNotificationsTile(context, ref),
                ],
              ),

              const SizedBox(height: 20),

              // Seção Sobre
              _buildSection(
                context,
                title: 'Sobre',
                children: [
                  _buildAboutTile(context),
                  _buildVersionTile(context),
                ],
              ),

              const SizedBox(height: 20),

              // Seção Dados
              _buildSection(
                context,
                title: 'Dados',
                children: [_buildResetDataTile(context, ref)],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    String? title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Column(
            children:
                children.asMap().entries.map((entry) {
                  final index = entry.key;
                  final child = entry.value;
                  return Column(
                    children: [
                      child,
                      if (index < children.length - 1)
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withOpacity(0.1),
                          indent: 16,
                          endIndent: 16,
                        ),
                    ],
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDailyGoalTile(
    BuildContext context,
    WidgetRef ref,
    double goalAmount,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.flag_outlined,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(
        'Meta Diária',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        '${goalAmount.toStringAsFixed(0)}ml por dia',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showGoalDialog(context, ref, goalAmount),
    );
  }

  Widget _buildDarkModeTile(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final themeMode = ref.watch(themeProvider);
        final themeNotifier = ref.read(themeProvider.notifier);
        final isDarkMode = themeMode == ThemeMode.dark;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          title: Text(
            'Modo Escuro',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            isDarkMode ? 'Ativado' : 'Desativado',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: Switch(
            value: isDarkMode,
            onChanged: (value) {
              themeNotifier.setThemeMode(
                value ? ThemeMode.dark : ThemeMode.light,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildNotificationsTile(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final notificationSettings = ref.watch(notificationSettingsProvider);
        final notificationNotifier = ref.read(
          notificationSettingsProvider.notifier,
        );

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              notificationSettings.enabled
                  ? Icons.notifications_active
                  : Icons.notifications_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          title: Text(
            'Notificações',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            notificationSettings.enabled
                ? '${notificationNotifier.intervalDescription} - ${notificationNotifier.scheduleDescription}'
                : 'Lembretes para beber água',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: Switch(
            value: notificationSettings.enabled,
            onChanged: (value) async {
              final success = await notificationNotifier.toggleNotifications(
                value,
              );
              if (!success && value) {
                if (context.mounted) {
                  CustomSnackBar.showError(
                    context,
                    message: 'Permissão para notificações negada',
                  );
                }
              }
            },
          ),
          onTap: () => _showNotificationSettings(context, ref),
        );
      },
    );
  }

  Widget _buildAboutTile(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.info_outline,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(
        'Sobre o App',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        'Informações e créditos',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        _showAboutDialog(context);
      },
    );
  }

  Widget _buildVersionTile(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.apps,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text('Versão', style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text('1.0.0', style: Theme.of(context).textTheme.bodyMedium),
    );
  }

  Widget _buildResetDataTile(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.refresh,
          color: Theme.of(context).colorScheme.error,
          size: 20,
        ),
      ),
      title: Text(
        'Resetar Dados',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
      subtitle: Text(
        'Apagar todos os dados salvos',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showResetDialog(context, ref),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Sobre o H2O Simple'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'H2O Simple v1.0.0',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Text(
                  'App para acompanhar seu consumo diário de água e manter uma hidratação saudável.',
                ),
                SizedBox(height: 16),
                Text(
                  'Desenvolvido com Flutter 💙',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fechar'),
              ),
            ],
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
                    CustomSnackBar.showSuccess(
                      context,
                      message: 'Meta alterada para ${newGoal}ml',
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
                  CustomSnackBar.showWarning(
                    context,
                    message: 'Dados resetados com sucesso',
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

  void _showNotificationSettings(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _NotificationSettingsDialog(ref: ref),
    );
  }
}

class _NotificationSettingsDialog extends ConsumerWidget {
  final WidgetRef ref;

  const _NotificationSettingsDialog({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsProvider);
    final notifier = ref.read(notificationSettingsProvider.notifier);

    return AlertDialog(
      title: const Text('Configurações de Notificação'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Intervalo entre notificações:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: settings.intervalHours,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items:
                  [1, 2, 3, 4, 6, 8, 12].map((hours) {
                    return DropdownMenuItem(
                      value: hours,
                      child: Text(
                        hours == 1 ? 'A cada hora' : 'A cada $hours horas',
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) notifier.setInterval(value);
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Horário de início:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap:
                  () =>
                      _selectTime(context, true, settings.startTime, notifier),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(settings.startTime.toDisplayString()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Horário de fim:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap:
                  () => _selectTime(context, false, settings.endTime, notifier),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(settings.endTime.toDisplayString()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => notifier.testNotification(),
                icon: const Icon(Icons.notification_add),
                label: const Text('Enviar Notificação de Teste'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightBlue,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
      ],
    );
  }

  Future<void> _selectTime(
    BuildContext context,
    bool isStartTime,
    custom.TimeOfDay currentTime,
    NotificationSettingsNotifier notifier,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: currentTime.hour,
        minute: currentTime.minute,
      ),
    );

    if (picked != null) {
      final customTime = custom.TimeOfDay(
        hour: picked.hour,
        minute: picked.minute,
      );
      if (isStartTime) {
        notifier.setStartTime(customTime);
      } else {
        notifier.setEndTime(customTime);
      }
    }
  }
}
