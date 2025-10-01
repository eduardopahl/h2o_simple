import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmButtonText;
  final String cancelButtonText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmButtonColor;
  final Color? confirmTextColor;
  final IconData? icon;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmButtonText = 'Confirmar',
    this.cancelButtonText = 'Cancelar',
    this.onConfirm,
    this.onCancel,
    this.confirmButtonColor,
    this.confirmTextColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: Text(message, style: Theme.of(context).textTheme.bodyMedium),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onCancel?.call();
          },
          child: Text(cancelButtonText),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm?.call();
          },
          style:
              confirmButtonColor != null
                  ? ElevatedButton.styleFrom(
                    backgroundColor: confirmButtonColor,
                    foregroundColor: confirmTextColor ?? Colors.white,
                  )
                  : null,
          child: Text(confirmButtonText),
        ),
      ],
    );
  }
}

/// Função helper para mostrar dialog de confirmação
Future<bool?> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmButtonText = 'Confirmar',
  String cancelButtonText = 'Cancelar',
  Color? confirmButtonColor,
  Color? confirmTextColor,
  IconData? icon,
}) async {
  return await showDialog<bool>(
    context: context,
    builder:
        (context) => ConfirmationDialog(
          title: title,
          message: message,
          confirmButtonText: confirmButtonText,
          cancelButtonText: cancelButtonText,
          confirmButtonColor: confirmButtonColor,
          confirmTextColor: confirmTextColor,
          icon: icon,
          onConfirm: () => Navigator.of(context).pop(true),
          onCancel: () => Navigator.of(context).pop(false),
        ),
  );
}

/// Dialog de confirmação para exclusão
Future<bool?> showDeleteConfirmationDialog(
  BuildContext context, {
  required String itemName,
  String? customMessage,
}) async {
  return await showConfirmationDialog(
    context,
    title: 'Confirmar exclusão',
    message: customMessage ?? 'Deseja realmente excluir $itemName?',
    confirmButtonText: 'Excluir',
    cancelButtonText: 'Cancelar',
    confirmButtonColor: Theme.of(context).colorScheme.error,
    confirmTextColor: Colors.white,
    icon: Icons.delete_outline,
  );
}

/// Dialog de confirmação para reset de dados
Future<bool?> showResetConfirmationDialog(
  BuildContext context, {
  String? customMessage,
}) async {
  return await showConfirmationDialog(
    context,
    title: 'Resetar Dados',
    message:
        customMessage ??
        'Tem certeza que deseja resetar todos os dados? Esta ação não pode ser desfeita.',
    confirmButtonText: 'Resetar',
    cancelButtonText: 'Cancelar',
    confirmButtonColor: Theme.of(context).colorScheme.error,
    confirmTextColor: Colors.white,
    icon: Icons.warning_outlined,
  );
}
