import 'package:shared_preferences/shared_preferences.dart';
import 'notification_service.dart';

class FirstLaunchService {
  static const String _firstLaunchKey = 'first_launch_completed';
  static const String _notificationPermissionKey =
      'notification_permission_requested';

  /// Verifica se é o primeiro acesso ao app
  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_firstLaunchKey) ?? false);
  }

  /// Verifica se deve mostrar o dialog de primeiro acesso
  static Future<bool> shouldShowFirstLaunchDialog() async {
    return await isFirstLaunch();
  }

  /// Marca o primeiro acesso como completo
  static Future<void> markFirstLaunchCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLaunchKey, true);
  }

  /// Verifica se a permissão de notificação já foi solicitada
  static Future<bool> wasNotificationPermissionRequested() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationPermissionKey) ?? false;
  }

  /// Marca que a permissão de notificação foi solicitada
  static Future<void> markNotificationPermissionRequested() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationPermissionKey, true);
  }

  /// Solicita permissão de notificação na primeira vez
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
