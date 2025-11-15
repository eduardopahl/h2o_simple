import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../domain/repositories/daily_goal_repository.dart';
import '../../domain/repositories/water_intake_repository.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Dependency injection - repositories como interfaces
  DailyGoalRepository? _goalRepository;
  WaterIntakeRepository? _intakeRepository;

  /// Configura as dependências do service
  void configureDependencies({
    required DailyGoalRepository goalRepository,
    required WaterIntakeRepository intakeRepository,
  }) {
    _goalRepository = goalRepository;
    _intakeRepository = intakeRepository;
  }

  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const String channelId = 'water_reminder_channel';
  static const String channelName = 'Water Reminders';
  static const String channelDescription =
      'Notifications to remind you to drink water';

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );
    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    if (Platform.isAndroid) {
      await _createNotificationChannel();
    }
  }

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      // Primeiro solicita permissão básica de notificação
      if (await Permission.notification.isDenied) {
        final status = await Permission.notification.request();
        if (status != PermissionStatus.granted) {
          return false;
        }
      }

      // Tenta solicitar permissão de alarmes exatos (opcional)
      try {
        await Permission.scheduleExactAlarm.request();
      } catch (e) {
        // Permissão não disponível ou falhou - continua sem alarmes exatos
      }

      return true;
    } else if (Platform.isIOS) {
      final granted = await _notifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return granted ?? false;
    }
    return false;
  }

  Future<bool> hasPermissions() async {
    if (Platform.isAndroid) {
      return await Permission.notification.isGranted;
    } else if (Platform.isIOS) {
      final granted = await _notifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: false, badge: false, sound: false);
      return granted ?? false;
    }
    return false;
  }

  Future<void> _createNotificationChannel() async {
    const androidChannel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.defaultImportance,
      playSound: true,
      enableVibration: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);
  }

  Future<void> scheduleRepeatingNotifications({
    required bool enabled,
    required int intervalHours,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
  }) async {
    await cancelAllNotifications();

    if (!enabled) return;

    final hasPermission = await requestPermissions();
    if (!hasPermission) return;

    final messages = [
      '💧 Hora de se hidratar! Que tal um copo de água?',
      '🌊 Lembrete: Seu corpo precisa de água para funcionar bem!',
      '💦 Ei! Não se esqueça de beber água!',
      '🥤 Que tal uma pausa para se hidratar?',
      '💧 Sua meta diária de água está te esperando!',
      '🌊 Hidrate-se! Seu corpo agradece!',
      '💦 Hora da água! Mantenha-se saudável!',
      '🥤 Lembrete amigável: Beba água regularmente!',
    ];

    int notificationId = 1000;
    final now = DateTime.now();

    for (int day = 0; day < 7; day++) {
      final currentDay = now.add(Duration(days: day));

      for (
        int hour = startTime.hour;
        hour <= endTime.hour;
        hour += intervalHours
      ) {
        if (hour > endTime.hour) break;

        final scheduledTime = DateTime(
          currentDay.year,
          currentDay.month,
          currentDay.day,
          hour,
          startTime.minute,
        );

        if (scheduledTime.isAfter(now)) {
          await _scheduleNotification(
            id: notificationId++,
            title: 'H2O Simple',
            body: messages[notificationId % messages.length],
            scheduledTime: scheduledTime,
          );
        }
      }
    }
  }

  Future<bool> _shouldSendNotification() async {
    // Verifica se as dependências foram configuradas
    if (_goalRepository == null || _intakeRepository == null) {
      return true;
    }

    try {
      final today = DateTime.now();
      // Não existe mais targetAmount em DailyGoal, então buscamos a meta do perfil
      // Aqui, para manter compatibilidade, usamos 2000ml como fallback
      final currentTotal = await _intakeRepository!.getTotalWaterIntakeByDate(
        today,
      );
      // TODO: Idealmente, injetar o UserProfileRepository para buscar a meta do perfil
      // Por ora, mantemos 2000ml como padrão
      const defaultGoal = 2000;
      return currentTotal < defaultGoal;
    } catch (e) {
      // Em caso de erro, envia a notificação (comportamento padrão)
      return true;
    }
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF42A5F5),
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      sound: 'default',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      // Usa alarmes inexatos para melhor compatibilidade
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      // Se falhar, tenta sem agendamento (notificação imediata como fallback)
    }
  }

  Future<void> showInstantNotification({
    required String title,
    required String body,
    bool checkGoal = false,
  }) async {
    // Se checkGoal for true, verifica se a meta foi alcançada
    if (checkGoal) {
      final shouldSend = await _shouldSendNotification();
      if (!shouldSend) {
        return; // Não envia notificação se a meta já foi alcançada
      }
    }

    const androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/launcher_icon',
      color: Color(0xFF42A5F5),
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      sound: 'default',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      999, // ID fixo para notificações instantâneas
      title,
      body,
      details,
    );
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<void> cancelTodayNotificationsIfGoalReached() async {
    final shouldCancel = !(await _shouldSendNotification());
    if (shouldCancel) {
      // Cancela todas as notificações agendadas para hoje
      await _cancelTodayNotifications();
    }
  }

  Future<void> _cancelTodayNotifications() async {
    // Obtém todas as notificações pendentes
    final pendingNotifications =
        await _notifications.pendingNotificationRequests();

    // Cancela notificações do dia atual
    for (final notification in pendingNotifications) {
      // Como não podemos verificar o horário agendado diretamente,
      // vamos cancelar e reagendar todas as notificações
      await _notifications.cancel(notification.id);
    }
  }

  Future<void> checkAndUpdateNotificationsForGoal() async {
    final shouldSend = await _shouldSendNotification();

    if (!shouldSend) {
      // Meta alcançada - cancela notificações do resto do dia
      await _cancelTodayNotifications();
    }
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  static void _onNotificationTapped(NotificationResponse response) {}
}

class TimeOfDay {
  final int hour;
  final int minute;

  const TimeOfDay({required this.hour, required this.minute});

  static const TimeOfDay morning = TimeOfDay(hour: 8, minute: 0);
  static const TimeOfDay evening = TimeOfDay(hour: 20, minute: 0);

  @override
  String toString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  String toDisplayString() {
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final period = hour < 12 ? 'AM' : 'PM';
    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }
}
