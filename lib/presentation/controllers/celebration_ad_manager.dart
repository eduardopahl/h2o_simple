import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/ad_service_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Gerenciador de anúncios comemorativos
/// Mostra anúncios em momentos de conquista do usuário
class CelebrationAdManager {
  static Future<void> showGoalCompletedCelebration(
    BuildContext context,
    WidgetRef ref, {
    required double goalAmount,
    required double achievedAmount,
  }) async {
    final adService = ref.read(adServiceProvider);
    final l10n = AppLocalizations.of(context);

    // SEMPRE mostra o diálogo comemorativo (premium ou não)
    await _showCelebrationDialog(
      context,
      title: l10n.goalCompleted,
      message: l10n.goalCompletedMessage(goalAmount.toInt()),
      icon: Icons.emoji_events,
      color: Colors.amber,
    );

    // Só mostra anúncio se NÃO for usuário premium e puder mostrar anúncios
    if (adService.canShowAd('celebration')) {
      await adService.showCelebrationAd('daily_goal_completed');
    }
  }

  static Future<void> showWeeklyAchievement(
    BuildContext context,
    WidgetRef ref, {
    required int completedDays,
  }) async {
    final adService = ref.read(adServiceProvider);
    final l10n = AppLocalizations.of(context);

    // Só mostra para conquistas significativas (5+ dias)
    if (completedDays < 5) return;

    // SEMPRE mostra o diálogo comemorativo
    await _showCelebrationDialog(
      context,
      title: l10n.weeklyAchievement,
      message: l10n.weeklyAchievementMessage(completedDays),
      icon: Icons.calendar_today,
      color: Colors.green,
    );

    // Só mostra anúncio se NÃO for usuário premium
    if (adService.canShowAd('celebration')) {
      await adService.showCelebrationAd('weekly_achievement');
    }
  }

  static Future<void> showStreakMilestone(
    BuildContext context,
    WidgetRef ref, {
    required int streakDays,
  }) async {
    final adService = ref.read(adServiceProvider);
    final l10n = AppLocalizations.of(context);

    // Só mostra para marcos importantes (múltiplos de 7)
    if (streakDays % 7 != 0) return;

    // SEMPRE mostra o diálogo comemorativo
    await _showCelebrationDialog(
      context,
      title: l10n.streakMilestone,
      message: l10n.streakMilestoneMessage(streakDays),
      icon: Icons.local_fire_department,
      color: Colors.orange,
    );

    // Só mostra anúncio se NÃO for usuário premium
    if (adService.canShowAd('celebration')) {
      await adService.showCelebrationAd('streak_milestone');
    }
  }

  static Future<void> _showCelebrationDialog(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
    required Color color,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ícone animado
                  TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 800),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, double value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, size: 48, color: color),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Título
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Mensagem
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Botão de continuar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context).continueText,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
