import '../entities/user_profile.dart';

abstract class UserProfileRepository {
  /// Salva o perfil do usuário
  Future<void> saveUserProfile(UserProfile profile);

  /// Busca o perfil do usuário
  Future<UserProfile?> getUserProfile();

  /// Atualiza dados específicos do perfil
  Future<void> updateUserProfile(UserProfile profile);

  /// Remove o perfil do usuário
  Future<void> deleteUserProfile();

  /// Verifica se existe um perfil salvo
  Future<bool> hasUserProfile();
}
