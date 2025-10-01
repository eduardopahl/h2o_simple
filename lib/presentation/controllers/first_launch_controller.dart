import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/first_launch_service.dart';
import '../../data/models/personal_data_model.dart';
import '../../data/repositories/daily_goal_repository_impl.dart';
import '../../data/repositories/user_profile_repository_impl.dart';
import '../../domain/entities/daily_goal.dart';
import '../../domain/entities/user_profile.dart';
import '../widgets/custom_snackbar.dart';
import '../dialogs/first_launch_setup_dialog.dart';
import '../providers/daily_goal_provider.dart';
import '../providers/user_profile_provider.dart';

class FirstLaunchController {
  /// Verifica se deve mostrar o dialog de primeiro acesso e o exibe se necessário
  static Future<void> handleFirstLaunch(
    BuildContext context,
    WidgetRef ref,
  ) async {
    if (!context.mounted) return;

    final shouldShow = await FirstLaunchService.shouldShowFirstLaunchDialog();

    if (shouldShow && context.mounted) {
      await _showFirstLaunchSetupDialog(context, ref);
    }
  }

  /// Mostra o dialog completo de configuração inicial
  static Future<void> _showFirstLaunchSetupDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => FirstLaunchSetupDialog(
            onComplete:
                (personalData, allowNotifications) => _handleSetupComplete(
                  context,
                  ref,
                  personalData,
                  allowNotifications,
                ),
          ),
    );
  }

  /// Lida com a conclusão da configuração inicial
  static Future<void> _handleSetupComplete(
    BuildContext context,
    WidgetRef ref,
    PersonalDataModel personalData,
    bool allowNotifications,
  ) async {
    try {
      // Salva os dados pessoais (cria/atualiza UserProfile)
      await _savePersonalData(personalData, ref);

      // Configura a meta de hidratação baseada nos dados
      final dailyGoal = personalData.calculateDailyGoal();
      await _saveDailyGoal(dailyGoal);

      // Força refresh do DailyGoalProvider para usar a nova meta
      ref.read(dailyGoalProvider.notifier).refreshGoal();

      // Solicita permissão de notificação se o usuário escolheu permitir
      bool notificationsGranted = false;
      if (allowNotifications) {
        notificationsGranted =
            await FirstLaunchService.requestFirstTimeNotificationPermission();
      } else {
        await FirstLaunchService.markNotificationPermissionRequested();
      }

      // Marca primeiro acesso como completo
      await FirstLaunchService.markFirstLaunchCompleted();

      // Mostra feedback para o usuário
      if (context.mounted) {
        if (notificationsGranted) {
          CustomSnackBar.showSuccess(
            context,
            message: '✅ Configuração concluída! Meta: ${dailyGoal}ml/dia',
          );
        } else {
          CustomSnackBar.showInfo(
            context,
            message: '⚙️ Configuração concluída! Meta: ${dailyGoal}ml/dia',
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar.showError(
          context,
          message: 'Erro ao salvar configurações: $e',
        );
      }
    }
  }

  /// Salva os dados pessoais criando ou atualizando o UserProfile
  static Future<void> _savePersonalData(
    PersonalDataModel personalData,
    WidgetRef ref,
  ) async {
    try {
      final repository = UserProfileRepositoryImpl();
      final goalMl = personalData.calculateDailyGoal();

      // Verificar se já existe um perfil
      final existingProfile = await repository.getUserProfile();

      UserProfile savedProfile;
      if (existingProfile != null) {
        // Atualizar perfil existente
        savedProfile = existingProfile.copyWith(
          weight: personalData.weightKg?.round(),
          defaultDailyGoal: goalMl,
        );
        await repository.updateUserProfile(savedProfile);
      } else {
        // Criar novo perfil
        savedProfile = UserProfile(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          name: 'Usuário', // Nome padrão - pode ser alterado depois
          weight: personalData.weightKg?.round() ?? 70,
          defaultDailyGoal: goalMl,
          notificationsEnabled:
              true, // Será atualizado com a escolha do usuário
        );
        await repository.saveUserProfile(savedProfile);
      }

      // Força atualização do UserProfileProvider para refletir a mudança imediatamente
      if (existingProfile != null) {
        ref.read(userProfileProvider.notifier).updateUserProfile(savedProfile);
      } else {
        ref.read(userProfileProvider.notifier).saveUserProfile(savedProfile);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Salva a meta diária usando o repository
  static Future<void> _saveDailyGoal(int goalMl) async {
    try {
      final repository = DailyGoalRepositoryImpl();
      final today = DateTime.now();

      // Verificar se já existe uma meta para hoje
      final existingGoal = await repository.getDailyGoalByDate(today);

      if (existingGoal != null) {
        // Atualizar meta existente mantendo o progresso atual
        final updatedGoal = existingGoal.copyWith(targetAmount: goalMl);
        await repository.saveDailyGoal(updatedGoal);
      } else {
        // Criar nova meta para hoje
        final newGoal = DailyGoal(
          targetAmount: goalMl,
          date: today,
          currentAmount: 0,
          intakeIds: [],
        );
        await repository.saveDailyGoal(newGoal);
      }
    } catch (e) {
      rethrow;
    }
  }
}
