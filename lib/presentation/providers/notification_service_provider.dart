import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/notification_service.dart';
import 'repository_providers.dart';

/// Provider que configura o NotificationService com as dependências corretas
final configuredNotificationServiceProvider = Provider<NotificationService>((
  ref,
) {
  final service = NotificationService();

  // Configura as dependências do service
  service.configureDependencies(
    goalRepository: ref.watch(dailyGoalRepositoryProvider),
    intakeRepository: ref.watch(waterIntakeRepositoryProvider),
  );

  return service;
});

/// Provider para inicializar o NotificationService
final notificationServiceInitializerProvider = FutureProvider<void>((
  ref,
) async {
  final service = ref.watch(configuredNotificationServiceProvider);
  await service.initialize();
});

/// Provider para verificar permissões de notificação
final notificationPermissionsProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(configuredNotificationServiceProvider);
  return await service.hasPermissions();
});
