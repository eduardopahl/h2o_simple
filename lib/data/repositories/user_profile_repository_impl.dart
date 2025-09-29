import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../models/user_profile_model.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  static const String _userProfileKey = 'user_profile';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    final prefs = await _prefs;
    final model = UserProfileModel.fromEntity(profile);
    await prefs.setString(_userProfileKey, jsonEncode(model.toJson()));
  }

  @override
  Future<UserProfile?> getUserProfile() async {
    final prefs = await _prefs;
    final jsonString = prefs.getString(_userProfileKey);

    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final model = UserProfileModel.fromJson(json);
      return model.toEntity();
    } catch (e) {
      // Se houver erro na deserialização, remove o perfil inválido
      await deleteUserProfile();
      return null;
    }
  }

  @override
  Future<void> updateUserProfile(UserProfile profile) async {
    // Para SharedPreferences, update é igual a save
    await saveUserProfile(profile);
  }

  @override
  Future<void> deleteUserProfile() async {
    final prefs = await _prefs;
    await prefs.remove(_userProfileKey);
  }

  @override
  Future<bool> hasUserProfile() async {
    final prefs = await _prefs;
    return prefs.containsKey(_userProfileKey);
  }
}
