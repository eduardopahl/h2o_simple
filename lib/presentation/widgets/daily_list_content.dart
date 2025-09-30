import 'package:flutter/material.dart';

class DailyListContent extends StatelessWidget {
  final List<dynamic> waterIntakes;
  final DateTime selectedDate;
  final Function(String) onDeleteIntake;

  const DailyListContent({
    super.key,
    required this.waterIntakes,
    required this.selectedDate,
    required this.onDeleteIntake,
  });

  @override
  Widget build(BuildContext context) {
    final selectedDayIntakes =
        waterIntakes
            .where(
              (intake) =>
                  intake.timestamp.day == selectedDate.day &&
                  intake.timestamp.month == selectedDate.month &&
                  intake.timestamp.year == selectedDate.year,
            )
            .toList();

    if (selectedDayIntakes.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.water_drop_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum registro neste dia',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children:
          selectedDayIntakes.map((intake) {
            return Dismissible(
              key: Key(intake.id),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) async {
                // Chama o callback de delete que abrirá o diálogo
                onDeleteIntake(intake.id);
                // Retorna false para não deletar automaticamente
                // O delete real será feito pelo diálogo
                return false;
              },
              background: Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.onError,
                  size: 28,
                ),
              ),
              child: Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    child: Icon(
                      Icons.water_drop,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  title: Text(
                    '${intake.amount}ml',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    _formatDateTime(intake.timestamp),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    onPressed: () => onDeleteIntake(intake.id),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.year} - '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
