import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/events/water_intake_events.dart';
import '../widgets/goal_achieved_dialog.dart';

class WaterIntakeController {
  /// Processa um evento específico - método público para ser chamado do widget
  static void handleEvent(BuildContext context, WaterIntakeEvent event) {
    switch (event.type) {
      case WaterIntakeEventType.goalAchieved:
        _handleGoalAchieved(context, event);
        break;
      case WaterIntakeEventType.goalProgressUpdated:
        _handleGoalProgressUpdated(context, event);
        break;
      case WaterIntakeEventType.errorOccurred:
        _handleError(context, event);
        break;
    }
  }

  /// Lida com evento de meta alcançada
  static void _handleGoalAchieved(
    BuildContext context,
    WaterIntakeEvent event,
  ) {
    // Aguarda um frame para garantir que o contexto está válido
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        showGoalAchievedDialog(context);
      }
    });
  }

  /// Lida com evento de progresso de meta atualizado
  static void _handleGoalProgressUpdated(
    BuildContext context,
    WaterIntakeEvent event,
  ) {
    // Aqui pode implementar lógica adicional como analytics, logs, etc.
    final totalAmount = event.data['totalAmount'] as int;
    final goalAmount = event.data['goalAmount'] as int;
    final progress = event.data['progress'] as double;

    debugPrint(
      'Progresso da meta: ${(progress * 100).toStringAsFixed(1)}% ($totalAmount/$goalAmount ml)',
    );
  }

  /// Lida com erros
  static void _handleError(BuildContext context, WaterIntakeEvent event) {
    final messageKey = event.data['message'] as String;

    // Traduzir a key da mensagem de erro
    final localizedMessage = _getLocalizedErrorMessage(context, messageKey);

    // Mostra erro para o usuário (pode usar SnackBar customizado aqui se necessário)
    debugPrint('Erro no water intake: $localizedMessage');

    // Aqui poderia mostrar um SnackBar de erro se necessário
    // CustomSnackBar.showError(context, message: localizedMessage);
  }

  /// Traduz uma key de erro para a mensagem localizada
  static String _getLocalizedErrorMessage(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context);

    switch (key) {
      case 'errorLoadingHydrationData':
        return l10n.errorLoadingHydrationData;
      case 'errorAddingWaterIntake':
        return l10n.errorAddingWaterIntake;
      case 'errorRemovingWaterIntake':
        return l10n.errorRemovingWaterIntake;
      case 'errorCheckingNotifications':
        return l10n.errorCheckingNotifications;
      default:
        return key; // Fallback para a key original se não encontrar tradução
    }
  }
}
