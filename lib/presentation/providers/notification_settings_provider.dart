import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/first_launch_service.dart';

class NotificationSettings {
  final bool enabled;
  final int intervalHours;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const NotificationSettings({
    required this.enabled,
    required this.intervalHours,
    required this.startTime,
    required this.endTime,
  });

  NotificationSettings copyWith({
    bool? enabled,
    int? intervalHours,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    return NotificationSettings(
      enabled: enabled ?? this.enabled,
      intervalHours: intervalHours ?? this.intervalHours,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'intervalHours': intervalHours,
      'startTimeHour': startTime.hour,
      'startTimeMinute': startTime.minute,
      'endTimeHour': endTime.hour,
      'endTimeMinute': endTime.minute,
    };
  }

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      enabled: json['enabled'] ?? false,
      intervalHours: json['intervalHours'] ?? 2,
      startTime: TimeOfDay(
        hour: json['startTimeHour'] ?? 8,
        minute: json['startTimeMinute'] ?? 0,
      ),
      endTime: TimeOfDay(
        hour: json['endTimeHour'] ?? 20,
        minute: json['endTimeMinute'] ?? 0,
      ),
    );
  }

  static const NotificationSettings defaultSettings = NotificationSettings(
    enabled: false,
    intervalHours: 2,
    startTime: TimeOfDay.morning,
    endTime: TimeOfDay.evening,
  );
}

class NotificationSettingsNotifier extends StateNotifier<NotificationSettings> {
  final NotificationService _notificationService;

  NotificationSettingsNotifier(this._notificationService)
    : super(NotificationSettings.defaultSettings) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Verifica se é um usuário novo que concedeu permissão no primeiro lançamento
      final wasPermissionRequested =
          await FirstLaunchService.wasNotificationPermissionRequested();
      final hasActualPermission = await _notificationService.hasPermissions();

      // Se a permissão foi solicitada e o usuário tem permissões ativas,
      // mas ainda não temos configurações salvas, ative as notificações por padrão
      bool defaultEnabled = false;
      if (wasPermissionRequested && hasActualPermission) {
        final hasExistingSettings = prefs.containsKey('notification_enabled');
        if (!hasExistingSettings) {
          defaultEnabled = true;
        }
      }

      final settings = NotificationSettings.fromJson(
        Map<String, dynamic>.from({
          'enabled': prefs.getBool('notification_enabled') ?? defaultEnabled,
          'intervalHours': prefs.getInt('notification_interval') ?? 2,
          'startTimeHour': prefs.getInt('notification_start_hour') ?? 8,
          'startTimeMinute': prefs.getInt('notification_start_minute') ?? 0,
          'endTimeHour': prefs.getInt('notification_end_hour') ?? 20,
          'endTimeMinute': prefs.getInt('notification_end_minute') ?? 0,
        }),
      );

      state = settings;

      // Se as notificações foram ativadas por padrão, salva as configurações
      if (defaultEnabled && !prefs.containsKey('notification_enabled')) {
        await _saveSettings();
      }

      if (settings.enabled) {
        await _scheduleNotifications();
      }
    } catch (e) {
      // If loading fails, keep default settings
      state = NotificationSettings.defaultSettings;
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notification_enabled', state.enabled);
      await prefs.setInt('notification_interval', state.intervalHours);
      await prefs.setInt('notification_start_hour', state.startTime.hour);
      await prefs.setInt('notification_start_minute', state.startTime.minute);
      await prefs.setInt('notification_end_hour', state.endTime.hour);
      await prefs.setInt('notification_end_minute', state.endTime.minute);
    } catch (e) {
      // Handle save error silently
    }
  }

  Future<bool> toggleNotifications(bool enabled) async {
    if (enabled) {
      final hasPermission = await _notificationService.requestPermissions();
      if (!hasPermission) {
        return false;
      }
    }

    state = state.copyWith(enabled: enabled);
    await _saveSettings();
    await _scheduleNotifications();
    return true;
  }

  Future<void> setInterval(int hours) async {
    if (hours < 1 || hours > 12) return;

    state = state.copyWith(intervalHours: hours);
    await _saveSettings();

    if (state.enabled) {
      await _scheduleNotifications();
    }
  }

  Future<void> setStartTime(TimeOfDay startTime) async {
    state = state.copyWith(startTime: startTime);
    await _saveSettings();

    if (state.enabled) {
      await _scheduleNotifications();
    }
  }

  Future<void> setEndTime(TimeOfDay endTime) async {
    state = state.copyWith(endTime: endTime);
    await _saveSettings();

    if (state.enabled) {
      await _scheduleNotifications();
    }
  }

  Future<void> _scheduleNotifications() async {
    await _notificationService.scheduleRepeatingNotifications(
      enabled: state.enabled,
      intervalHours: state.intervalHours,
      startTime: state.startTime,
      endTime: state.endTime,
    );
  }

  Future<void> testNotification() async {
    await _notificationService.showInstantNotification(
      title: 'H2O Simple - Teste',
      body:
          '💧 Esta é uma notificação de teste! Suas notificações estão funcionando.',
    );
  }

  String get intervalDescription {
    return state.intervalHours == 1
        ? 'A cada hora'
        : 'A cada ${state.intervalHours} horas';
  }

  String get scheduleDescription {
    return 'Das ${state.startTime.toDisplayString()} às ${state.endTime.toDisplayString()}';
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final notificationSettingsProvider =
    StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>((
      ref,
    ) {
      final notificationService = ref.watch(notificationServiceProvider);
      return NotificationSettingsNotifier(notificationService);
    });
