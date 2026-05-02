import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_profile.dart';
import 'repository_providers.dart';

class UserProfileNotifier extends AsyncNotifier<UserProfile?> {
  @override
  Future<UserProfile?> build() async {
    final repository = ref.watch(userProfileRepositoryProvider);
    return await repository.getUserProfile();
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(userProfileRepositoryProvider);
      await repository.saveUserProfile(profile);
      state = AsyncValue.data(profile);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      final repository = ref.read(userProfileRepositoryProvider);
      await repository.updateUserProfile(profile);
      state = AsyncValue.data(profile);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteUserProfile() async {
    try {
      final repository = ref.read(userProfileRepositoryProvider);
      await repository.deleteUserProfile();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<bool> hasUserProfile() async {
    final repository = ref.read(userProfileRepositoryProvider);
    return await repository.hasUserProfile();
  }
}

final userProfileProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserProfile?>(
      UserProfileNotifier.new,
    );

final currentUserProfileProvider = Provider<UserProfile?>((ref) {
  return ref.watch(userProfileProvider).value;
});
