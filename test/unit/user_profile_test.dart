import 'package:flutter_test/flutter_test.dart';
import 'package:h2o_simple/domain/entities/user_profile.dart';

void main() {
  group('UserProfile Entity Tests', () {
    test('should create UserProfile with valid data', () {
      // Arrange
      const userId = 'test_user_123';
      const userName = 'Test User';
      const weight = 70;
      const dailyGoal = 2000;
      const notificationsEnabled = true;

      // Act
      final userProfile = UserProfile(
        id: userId,
        name: userName,
        weight: weight,
        defaultDailyGoal: dailyGoal,
        notificationsEnabled: notificationsEnabled,
      );

      // Assert
      expect(userProfile.id, equals(userId));
      expect(userProfile.name, equals(userName));
      expect(userProfile.weight, equals(weight));
      expect(userProfile.defaultDailyGoal, equals(dailyGoal));
      expect(userProfile.notificationsEnabled, equals(notificationsEnabled));
    });

    test('should calculate recommended daily goal correctly', () {
      // Arrange
      final userProfile = UserProfile(
        id: 'test_123',
        name: 'John Doe',
        weight: 70, // 70kg * 35 = 2450ml
        defaultDailyGoal: 2000,
      );

      // Act
      final recommendedGoal = userProfile.recommendedDailyGoal;

      // Assert
      expect(recommendedGoal, equals(2450));
    });

    test('should format wake up time correctly', () {
      // Arrange
      final userProfile = UserProfile(
        id: 'test_123',
        name: 'John Doe',
        weight: 70,
        defaultDailyGoal: 2000,
        wakeUpTime: 420, // 7:00 AM (7 * 60 + 0)
      );

      // Act
      final wakeUpTimeString = userProfile.wakeUpTimeString;

      // Assert
      expect(wakeUpTimeString, equals('07:00'));
    });

    test('should format sleep time correctly', () {
      // Arrange
      final userProfile = UserProfile(
        id: 'test_123',
        name: 'John Doe',
        weight: 70,
        defaultDailyGoal: 2000,
        sleepTime: 1380, // 11:00 PM (23 * 60 + 0)
      );

      // Act
      final sleepTimeString = userProfile.sleepTimeString;

      // Assert
      expect(sleepTimeString, equals('23:00'));
    });

    test('should handle copyWith method correctly', () {
      // Arrange
      final originalProfile = UserProfile(
        id: 'test_789',
        name: 'Original Name',
        weight: 80,
        defaultDailyGoal: 3000,
        notificationsEnabled: true,
      );

      // Act
      final updatedProfile = originalProfile.copyWith(
        name: 'Updated Name',
        weight: 85,
      );

      // Assert
      expect(updatedProfile.id, equals(originalProfile.id));
      expect(updatedProfile.name, equals('Updated Name'));
      expect(updatedProfile.weight, equals(85));
      expect(updatedProfile.defaultDailyGoal, equals(originalProfile.defaultDailyGoal));
      expect(updatedProfile.notificationsEnabled, equals(originalProfile.notificationsEnabled));
    });

    test('should maintain equality when comparing identical profiles', () {
      // Arrange
      final profile1 = UserProfile(
        id: 'same_id',
        name: 'Same Name',
        weight: 70,
        defaultDailyGoal: 2000,
        notificationsEnabled: true,
      );

      final profile2 = UserProfile(
        id: 'same_id',
        name: 'Same Name',
        weight: 70,
        defaultDailyGoal: 2000,
        notificationsEnabled: true,
      );

      // Act & Assert
      expect(profile1, equals(profile2));
      expect(profile1.hashCode, equals(profile2.hashCode));
    });

    test('should handle default values correctly', () {
      // Arrange & Act
      final userProfile = UserProfile(
        id: 'test_defaults',
        name: 'Default User',
        weight: 70,
        defaultDailyGoal: 2000,
      );

      // Assert
      expect(userProfile.wakeUpTime, equals(420)); // 7:00 AM
      expect(userProfile.sleepTime, equals(1380)); // 11:00 PM
      expect(userProfile.reminderIntervals, equals([60, 120, 180]));
      expect(userProfile.notificationsEnabled, equals(true));
    });

    test('should convert minutes to time string correctly', () {
      // Arrange
      final userProfile = UserProfile(
        id: 'test_time',
        name: 'Time User',
        weight: 70,
        defaultDailyGoal: 2000,
      );

      // Act & Assert
      expect(userProfile.minutesToTimeString(0), equals('00:00')); // Midnight
      expect(userProfile.minutesToTimeString(360), equals('06:00')); // 6:00 AM
      expect(userProfile.minutesToTimeString(540), equals('09:00')); // 9:00 AM
      expect(userProfile.minutesToTimeString(750), equals('12:30')); // 12:30 PM
      expect(userProfile.minutesToTimeString(1440), equals('24:00')); // Next day
    });
  });
}