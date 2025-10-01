import 'package:flutter/material.dart';
import '../../core/services/first_launch_service.dart';
import '../widgets/custom_snackbar.dart';
import '../dialogs/first_launch_dialog.dart';

class FirstLaunchController {
  /// Verifica se deve mostrar o dialog de primeiro acesso e o exibe se necessário
  static Future<void> handleFirstLaunch(BuildContext context) async {
    if (!context.mounted) return;

    final shouldShow = await FirstLaunchService.shouldShowFirstLaunchDialog();

    if (shouldShow && context.mounted) {
      await _showFirstLaunchDialog(context);
    }
  }

  /// Mostra o dialog de primeiro acesso
  static Future<void> _showFirstLaunchDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => FirstLaunchDialog(
            onComplete: () => _handleDialogComplete(context),
          ),
    );
  }

  /// Lida com a conclusão do dialog (permitir ou não notificações)
  static Future<void> _handleDialogComplete(BuildContext context) async {
    // Solicita permissão de notificação
    final granted =
        await FirstLaunchService.requestFirstTimeNotificationPermission();

    // Marca primeiro acesso como completo
    await FirstLaunchService.markFirstLaunchCompleted();

    // Mostra feedback para o usuário se as notificações foram ativadas
    if (granted && context.mounted) {
      CustomSnackBar.showSuccess(
        context,
        message:
            '✅ Notificações ativadas! Configure os horários em Configurações.',
      );
    }
  }

  /// Versão alternativa que permite customizar o callback de permissão
  static Future<void> showFirstLaunchDialogWithCallback(
    BuildContext context, {
    required Future<bool> Function() onRequestPermission,
    VoidCallback? onComplete,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => FirstLaunchDialog(
            onComplete: () async {
              final granted = await onRequestPermission();
              await FirstLaunchService.markFirstLaunchCompleted();

              if (granted && context.mounted) {
                CustomSnackBar.showSuccess(
                  context,
                  message:
                      '✅ Notificações ativadas! Configure os horários em Configurações.',
                );
              }

              onComplete?.call();
            },
          ),
    );
  }
}
