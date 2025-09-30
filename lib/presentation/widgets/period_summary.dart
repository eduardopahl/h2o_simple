import 'package:flutter/material.dart';
import 'period_selector.dart';

class PeriodSummary extends StatelessWidget {
  final TimePeriod selectedPeriod;
  final List<dynamic> waterIntakes;

  const PeriodSummary({
    super.key,
    required this.selectedPeriod,
    required this.waterIntakes,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    List<dynamic> periodIntakes;

    switch (selectedPeriod) {
      case TimePeriod.week:
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        periodIntakes =
            waterIntakes.where((intake) {
              final daysDiff = intake.timestamp.difference(weekStart).inDays;
              return daysDiff >= 0 && daysDiff < 7;
            }).toList();
        break;
      case TimePeriod.month:
        periodIntakes =
            waterIntakes
                .where(
                  (intake) =>
                      intake.timestamp.year == now.year &&
                      intake.timestamp.month == now.month,
                )
                .toList();
        break;
      default:
        periodIntakes = waterIntakes;
    }

    final total = periodIntakes.fold<int>(
      0,
      (sum, intake) => sum + intake.amount as int,
    );
    final average =
        periodIntakes.isNotEmpty ? (total / periodIntakes.length).round() : 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total consumido:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                '${total}ml',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Média por registro:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                '${average}ml',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
