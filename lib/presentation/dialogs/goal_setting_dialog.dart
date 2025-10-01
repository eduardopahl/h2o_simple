import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GoalSettingDialog extends StatefulWidget {
  final double currentGoal;
  final Function(int newGoal) onGoalChanged;

  const GoalSettingDialog({
    super.key,
    required this.currentGoal,
    required this.onGoalChanged,
  });

  @override
  State<GoalSettingDialog> createState() => _GoalSettingDialogState();
}

class _GoalSettingDialogState extends State<GoalSettingDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.currentGoal.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final newGoal = int.tryParse(_controller.text);
    if (newGoal != null && newGoal > 0) {
      widget.onGoalChanged(newGoal);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(
            Icons.flag_outlined,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(AppLocalizations.of(context).changeDailyGoal),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(5), // Max 99999ml
            ],
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).goalMlLabel,
              border: const OutlineInputBorder(),
              helperText: AppLocalizations.of(context).recommendedDailyGoal,
              suffixText: 'ml',
            ),
            autofocus: true,
            onSubmitted: (_) => _handleSubmit(),
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
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).adultRecommendation,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize: 12,
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
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context).cancel),
        ),
        ElevatedButton(
          onPressed: _handleSubmit,
          child: Text(AppLocalizations.of(context).save),
        ),
      ],
    );
  }
}

/// Função helper para mostrar o dialog de configuração de meta
Future<void> showGoalSettingDialog(
  BuildContext context, {
  required double currentGoal,
  required Function(int newGoal) onGoalChanged,
}) async {
  await showDialog(
    context: context,
    builder:
        (context) => GoalSettingDialog(
          currentGoal: currentGoal,
          onGoalChanged: onGoalChanged,
        ),
  );
}
