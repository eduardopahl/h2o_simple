import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import 'repository_providers.dart';

class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  UserProfileNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadUserProfile();
  }

  final UserProfileRepository _repository;

  Future<void> _loadUserProfile() async {
    try {
      final profile = await _repository.getUserProfile();
      state = AsyncValue.data(profile);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    state = const AsyncValue.loading();
    try {
      await _repository.saveUserProfile(profile);
      state = AsyncValue.data(profile);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      await _repository.updateUserProfile(profile);
      state = AsyncValue.data(profile);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteUserProfile() async {
    try {
      await _repository.deleteUserProfile();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<bool> hasUserProfile() async {
    return await _repository.hasUserProfile();
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile?>>((ref) {
      final repository = ref.watch(userProfileRepositoryProvider);
      return UserProfileNotifier(repository);
    });

final currentUserProfileProvider = Provider<UserProfile?>((ref) {
  return ref.watch(userProfileProvider).valueOrNull;
});
