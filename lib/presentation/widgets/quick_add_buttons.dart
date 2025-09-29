import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class QuickAddButton extends StatelessWidget {
  final int amount; // em ml
  final VoidCallback onTap;
  final String? label;

  const QuickAddButton({
    super.key,
    required this.amount,
    required this.onTap,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.primaryBlue.withOpacity(0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: AppTheme.primaryBlue.withOpacity(0.05),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícone de gota
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.water_drop,
                color: AppTheme.primaryBlue,
                size: 24,
              ),
            ),

            const SizedBox(height: 8),

            // Quantidade
            Text(
              '${amount}ml',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlue,
              ),
            ),

            // Label opcional
            if (label != null) ...[
              const SizedBox(height: 4),
              Text(
                label!,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class QuickAddButtonsGrid extends StatelessWidget {
  final Function(int amount) onAmountSelected;

  const QuickAddButtonsGrid({super.key, required this.onAmountSelected});

  static const List<Map<String, dynamic>> _presetAmounts = [
    {'amount': 250, 'label': 'Copo'},
    {'amount': 330, 'label': 'Lata'},
    {'amount': 500, 'label': 'Garrafa'},
    {'amount': 750, 'label': 'Garrafa G'},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: _presetAmounts.length,
      itemBuilder: (context, index) {
        final preset = _presetAmounts[index];
        return QuickAddButton(
          amount: preset['amount'] as int,
          label: preset['label'] as String,
          onTap: () => onAmountSelected(preset['amount'] as int),
        );
      },
    );
  }
}
