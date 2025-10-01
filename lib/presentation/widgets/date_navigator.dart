import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DateNavigator extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  const DateNavigator({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isToday = _isSameDay(selectedDate, DateTime.now());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Botão anterior
          IconButton(
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            padding: const EdgeInsets.all(4),
            onPressed: () {
              final newDate = selectedDate.subtract(const Duration(days: 1));
              onDateChanged(newDate);
            },
            icon: Icon(
              Icons.chevron_left,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          // Data atual
          Expanded(
            child: Text(
              _formatSelectedDate(context),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),

          // Botão próximo (desabilitado se for hoje)
          IconButton(
            onPressed:
                isToday
                    ? null
                    : () {
                      final newDate = selectedDate.add(const Duration(days: 1));
                      onDateChanged(newDate);
                    },
            icon: Icon(
              Icons.chevron_right,
              color:
                  isToday
                      ? Theme.of(context).colorScheme.onSurface.withOpacity(0.3)
                      : Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _formatSelectedDate(BuildContext context) {
    final now = DateTime.now();
    if (_isSameDay(selectedDate, now)) {
      return AppLocalizations.of(context).today;
    } else if (_isSameDay(
      selectedDate,
      now.subtract(const Duration(days: 1)),
    )) {
      return AppLocalizations.of(context).yesterday;
    } else {
      return '${selectedDate.day.toString().padLeft(2, '0')}/'
          '${selectedDate.month.toString().padLeft(2, '0')}/'
          '${selectedDate.year}';
    }
  }
}
