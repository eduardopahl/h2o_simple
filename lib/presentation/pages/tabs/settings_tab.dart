import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../providers/daily_goal_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/notification_settings_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/purchase_provider.dart';
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
                  AppLocalizations.of(context).settings,
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
                  _buildLanguageTile(context, ref),
                  _buildDarkModeTile(context, ref),
                  _buildNotificationsTile(context, ref),
                ],
              ),

              const SizedBox(height: 20),

              // Seção Premium
              _buildSection(
                context,
                title: AppLocalizations.of(context).premiumFeatures,
                children: [_buildRemoveAdsTile(context, ref)],
              ),

              const SizedBox(height: 20),

              // Seção Sobre
              _buildSection(
                context,
                title: AppLocalizations.of(context).about,
                children: [
                  _buildAboutTile(context),
                  _buildVersionTile(context),
                ],
              ),

              const SizedBox(height: 20),

              // Seção Dados
              _buildSection(
                context,
                title: AppLocalizations.of(context).data,
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
        AppLocalizations.of(context).dailyGoal,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        AppLocalizations.of(context).perDay(goalAmount.toStringAsFixed(0)),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showGoalDialog(context, ref, goalAmount),
    );
  }

  Widget _buildLanguageTile(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final currentLanguage = ref.watch(currentLanguageProvider);

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
              Icons.language,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          title: Text(
            'Language / Idioma',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            '${currentLanguage.flag} ${currentLanguage.name}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showLanguageDialog(context, ref),
        );
      },
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
            AppLocalizations.of(context).darkMode,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            isDarkMode
                ? AppLocalizations.of(context).enabled
                : AppLocalizations.of(context).disabled,
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
            AppLocalizations.of(context).notifications,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            notificationSettings.enabled
                ? '${notificationNotifier.getIntervalDescription(AppLocalizations.of(context).everyHourInterval, (hours) => AppLocalizations.of(context).everyXHoursInterval(hours))} - ${notificationNotifier.getScheduleDescription((start, end) => AppLocalizations.of(context).fromToSchedule(start, end))}'
                : AppLocalizations.of(context).waterReminders,
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
                    message:
                        AppLocalizations.of(
                          context,
                        ).notificationPermissionDenied,
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

  Widget _buildRemoveAdsTile(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Consumer(
      builder: (context, ref, child) {
        final isPremiumAsync = ref.watch(isPremiumUserProvider);
        final purchaseService = ref.watch(purchaseServiceProvider);

        return isPremiumAsync.when(
          data: (isPremium) {
            if (isPremium) {
              // Usuário já é premium
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
                title: Text(l10n.premiumUser),
                subtitle: Text(l10n.thanksForSupport),
              );
            } else {
              // Usuário não é premium - mostrar opção de compra
              final product = purchaseService.removeAdsProduct;
              final price = product?.price ?? 'R\$ 9,90';

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.star, color: Colors.amber, size: 20),
                ),
                title: Text(l10n.removeAds),
                subtitle: Text('${l10n.removeAdsDescription} - $price'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showPurchaseDialog(context, ref, price),
              );
            }
          },
          loading:
              () => ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: const CircularProgressIndicator(),
                title: Text(l10n.purchaseNotAvailable),
              ),
          error: (error, stack) => const SizedBox.shrink(),
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
        AppLocalizations.of(context).aboutApp,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        AppLocalizations.of(context).appInfo,
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
      title: Text(
        AppLocalizations.of(context).version,
        style: Theme.of(context).textTheme.titleMedium,
      ),
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
        AppLocalizations.of(context).resetAllData,
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
      subtitle: Text(
        AppLocalizations.of(context).deleteAllSavedData,
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
            title: Text(AppLocalizations.of(context).aboutH2OSimple),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).appVersion,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Text(AppLocalizations.of(context).h2oSimpleDescription),
                SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context).developedWithFlutter,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context).close),
              ),
            ],
          ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.read(currentLanguageProvider);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(AppLocalizations.of(context).selectLanguage),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  SupportedLanguage.values.map((language) {
                    return RadioListTile<SupportedLanguage>(
                      value: language,
                      groupValue: currentLanguage,
                      onChanged: (value) {
                        if (value != null) {
                          ref
                              .read(languageProvider.notifier)
                              .setLanguage(value);
                          Navigator.of(context).pop();

                          CustomSnackBar.showSuccess(
                            context,
                            message:
                                AppLocalizations.of(context).languageChanged,
                          );
                        }
                      },
                      title: Row(
                        children: [
                          Text(language.flag),
                          const SizedBox(width: 12),
                          Text(language.name),
                        ],
                      ),
                    );
                  }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context).cancel),
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
            title: Text(AppLocalizations.of(context).changeDailyGoal),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).goalMl,
                border: OutlineInputBorder(),
                helperText: AppLocalizations.of(context).recommendedDaily,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context).cancel),
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
                      message: AppLocalizations.of(
                        context,
                      ).goalChangedTo(newGoal),
                    );
                  }
                },
                child: Text(AppLocalizations.of(context).save),
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
            title: Text(AppLocalizations.of(context).resetData),
            content: Text(AppLocalizations.of(context).resetDataConfirmation),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context).cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  CustomSnackBar.showWarning(
                    context,
                    message: AppLocalizations.of(context).dataResetSuccess,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.warningColor,
                  foregroundColor: AppTheme.surfaceColor,
                ),
                child: Text(AppLocalizations.of(context).reset),
              ),
            ],
          ),
    );
  }

  void _showPurchaseDialog(BuildContext context, WidgetRef ref, String price) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(l10n.purchaseRemoveAds),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.removeAdsForever),
                const SizedBox(height: 16),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  final purchaseService = ref.read(purchaseServiceProvider);
                  final success = await purchaseService.restorePurchases();

                  if (context.mounted) {
                    if (success) {
                      CustomSnackBar.showSuccess(
                        context,
                        message: l10n.restoreSuccess,
                      );
                    } else {
                      CustomSnackBar.showError(
                        context,
                        message: l10n.restoreError,
                      );
                    }
                  }
                },
                child: Text(l10n.restorePurchases),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  final purchaseService = ref.read(purchaseServiceProvider);
                  final success = await purchaseService.buyRemoveAds();

                  if (context.mounted) {
                    if (success) {
                      CustomSnackBar.showSuccess(
                        context,
                        message: l10n.purchaseSuccess,
                      );
                    } else {
                      CustomSnackBar.showError(
                        context,
                        message: l10n.purchaseError,
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text(l10n.buyNow),
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
      title: Text(AppLocalizations.of(context).notificationSettings),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).intervalBetweenNotifications,
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
                        hours == 1
                            ? AppLocalizations.of(context).everyHour
                            : AppLocalizations.of(context).everyXHours(hours),
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) notifier.setInterval(value);
              },
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context).startTime,
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
              AppLocalizations.of(context).endTime,
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
                onPressed:
                    () => notifier.testNotification(
                      title: AppLocalizations.of(context).testNotificationTitle,
                      body: AppLocalizations.of(context).testNotificationBody,
                    ),
                icon: const Icon(Icons.notification_add),
                label: Text(AppLocalizations.of(context).sendTestNotification),
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
          child: Text(AppLocalizations.of(context).close),
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
