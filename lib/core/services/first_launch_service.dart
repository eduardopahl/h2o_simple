import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_service.dart';

class FirstLaunchService {
  static const String _firstLaunchKey = 'first_launch_completed';
  static const String _notificationPermissionKey =
      'notification_permission_requested';

  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_firstLaunchKey) ?? false);
  }

  static Future<void> markFirstLaunchCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLaunchKey, true);
  }

  static Future<bool> wasNotificationPermissionRequested() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationPermissionKey) ?? false;
  }

  static Future<void> markNotificationPermissionRequested() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationPermissionKey, true);
  }

  static Future<bool> requestFirstTimeNotificationPermission() async {
    if (await wasNotificationPermissionRequested()) {
      return false; // Já foi solicitado antes
    }

    final notificationService = NotificationService();
    final granted = await notificationService.requestPermissions();

    // Marca como já solicitado, independente da resposta
    await markNotificationPermissionRequested();

    return granted;
  }
}

class FirstLaunchDialog extends StatelessWidget {
  final VoidCallback onComplete;

  const FirstLaunchDialog({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(
            Icons.water_drop,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 8),
          const Text('Bem-vindo ao H2O Simple!'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Para ajudá-lo a manter uma hidratação saudável, gostaríamos de enviar lembretes para beber água.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Você poderá personalizar os horários e intervalos nas configurações.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await FirstLaunchService.markNotificationPermissionRequested();
            await FirstLaunchService.markFirstLaunchCompleted();
            onComplete();
          },
          child: const Text('Agora não'),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop();

            // Solicita permissão
            final granted =
                await FirstLaunchService.requestFirstTimeNotificationPermission();
            await FirstLaunchService.markFirstLaunchCompleted();

            if (granted) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      '✅ Notificações ativadas! Configure os horários em Configurações.',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            }

            onComplete();
          },
          child: const Text('Permitir Notificações'),
        ),
      ],
    );
  }
}
