import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_snackbar.dart';

class CustomAmountDialog extends StatefulWidget {
  final Function(int amount) onAmountSelected;

  const CustomAmountDialog({super.key, required this.onAmountSelected});

  @override
  State<CustomAmountDialog> createState() => _CustomAmountDialogState();
}

class _CustomAmountDialogState extends State<CustomAmountDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      CustomSnackBar.showError(
        context,
        message: AppLocalizations.of(context).invalidAmount,
      );
      return;
    }

    final amount = int.tryParse(text);
    if (amount != null && amount > 0 && amount <= 9999) {
      widget.onAmountSelected(amount);
      Navigator.of(context).pop();
    } else {
      CustomSnackBar.showError(
        context,
        message: AppLocalizations.of(context).amountTooSmall,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(AppLocalizations.of(context).customAmount),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context).amountMl,
          border: OutlineInputBorder(),
          suffixText: 'ml',
        ),
        autofocus: true,
        onSubmitted: (_) => _handleSubmit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context).cancel),
        ),
        ElevatedButton(
          onPressed: _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.lightBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(AppLocalizations.of(context).add),
        ),
      ],
    );
  }
}

/// Função helper para mostrar o dialog
Future<void> showCustomAmountDialog(
  BuildContext context, {
  required Function(int amount) onAmountSelected,
}) async {
  await showDialog(
    context: context,
    builder:
        (context) => CustomAmountDialog(onAmountSelected: onAmountSelected),
  );
}
