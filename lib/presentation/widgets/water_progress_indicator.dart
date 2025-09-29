import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WaterProgressIndicator extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final int currentAmount; // em ml
  final int targetAmount; // em ml
  final double size;

  const WaterProgressIndicator({
    super.key,
    required this.progress,
    required this.currentAmount,
    required this.targetAmount,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.progressEmpty, width: 8),
      ),
      child: Stack(
        children: [
          // Círculo de progresso
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 8,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress >= 1.0
                    ? AppTheme.progressCompleted
                    : AppTheme.progressFilled,
              ),
            ),
          ),

          // Conteúdo central
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Quantidade atual
                Text(
                  '${currentAmount}ml',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlue,
                  ),
                ),

                const SizedBox(height: 4),

                // Meta
                Text('de ${targetAmount}ml', style: theme.textTheme.bodyMedium),

                const SizedBox(height: 8),

                // Porcentagem
                Text(
                  '${(progress * 100).round()}%',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
