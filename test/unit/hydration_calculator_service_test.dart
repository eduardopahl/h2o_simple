import 'package:flutter_test/flutter_test.dart';
import 'package:h2osync/core/services/hydration_calculator_service.dart';

void main() {
  group('HydrationCalculatorService Tests', () {
    test('should calculate basic hydration goal for sedentary male', () {
      // Arrange
      const weightKg = 70.0;
      const ageYears = 30;
      const gender = Gender.male;
      const activityLevel = ActivityLevel.sedentary;

      // Act
      final result = HydrationCalculatorService.calculateDailyWaterIntake(
        weightKg: weightKg,
        ageYears: ageYears,
        gender: gender,
        activityLevel: activityLevel,
      );

      // Assert
      expect(result, greaterThan(2000));
      expect(result, lessThan(4000));
    });

    test('should calculate higher hydration goal for active individuals', () {
      // Arrange
      const weightKg = 70.0;
      const ageYears = 30;
      const gender = Gender.male;

      // Act
      final sedentaryGoal =
          HydrationCalculatorService.calculateDailyWaterIntake(
            weightKg: weightKg,
            ageYears: ageYears,
            gender: gender,
            activityLevel: ActivityLevel.sedentary,
          );

      final activeGoal = HydrationCalculatorService.calculateDailyWaterIntake(
        weightKg: weightKg,
        ageYears: ageYears,
        gender: gender,
        activityLevel: ActivityLevel.intense,
      );

      // Assert
      expect(activeGoal, greaterThan(sedentaryGoal));
    });

    test('should calculate different goals for different weights', () {
      // Arrange
      const ageYears = 25;
      const activityLevel = ActivityLevel.moderate;

      // Act
      final lightPersonGoal =
          HydrationCalculatorService.calculateDailyWaterIntake(
            weightKg: 50.0,
            ageYears: ageYears,
            gender: Gender.female,
            activityLevel: activityLevel,
          );

      final heavyPersonGoal =
          HydrationCalculatorService.calculateDailyWaterIntake(
            weightKg: 90.0,
            ageYears: ageYears,
            gender: Gender.male,
            activityLevel: activityLevel,
          );

      // Assert
      expect(heavyPersonGoal, greaterThan(lightPersonGoal));
    });

    test('should handle edge cases with minimum weight', () {
      // Arrange
      const weightKg = 30.0; // Very low weight
      const ageYears = 18;
      const gender = Gender.female;
      const activityLevel = ActivityLevel.sedentary;

      // Act
      final result = HydrationCalculatorService.calculateDailyWaterIntake(
        weightKg: weightKg,
        ageYears: ageYears,
        gender: gender,
        activityLevel: activityLevel,
      );

      // Assert
      expect(result, greaterThan(800)); // Should still have reasonable minimum
      expect(result, lessThan(2000));
    });

    test('should handle edge cases with maximum weight', () {
      // Arrange
      const weightKg = 150.0; // Very high weight
      const ageYears = 40;
      const gender = Gender.male;
      const activityLevel = ActivityLevel.extreme;

      // Act
      final result = HydrationCalculatorService.calculateDailyWaterIntake(
        weightKg: weightKg,
        ageYears: ageYears,
        gender: gender,
        activityLevel: activityLevel,
      );

      // Assert
      expect(result, greaterThanOrEqualTo(4000));
      expect(result, lessThan(10000)); // Should have reasonable maximum
    });

    test('should account for gender differences', () {
      // Arrange
      const weightKg = 70.0;
      const ageYears = 30;
      const activityLevel = ActivityLevel.moderate;

      // Act
      final maleGoal = HydrationCalculatorService.calculateDailyWaterIntake(
        weightKg: weightKg,
        ageYears: ageYears,
        gender: Gender.male,
        activityLevel: activityLevel,
      );

      final femaleGoal = HydrationCalculatorService.calculateDailyWaterIntake(
        weightKg: weightKg,
        ageYears: ageYears,
        gender: Gender.female,
        activityLevel: activityLevel,
      );

      // Assert
      // Males need more hydration (10% more according to the service)
      expect(maleGoal, greaterThan(femaleGoal));
    });

    test('should account for age differences', () {
      // Arrange
      const weightKg = 70.0;
      const gender = Gender.male;
      const activityLevel = ActivityLevel.moderate;

      // Act
      final youngGoal = HydrationCalculatorService.calculateDailyWaterIntake(
        weightKg: weightKg,
        ageYears: 20,
        gender: gender,
        activityLevel: activityLevel,
      );

      final olderGoal = HydrationCalculatorService.calculateDailyWaterIntake(
        weightKg: weightKg,
        ageYears: 70,
        gender: gender,
        activityLevel: activityLevel,
      );

      // Assert
      // Young people need more hydration according to the service
      expect(youngGoal, greaterThan(olderGoal));
      expect(youngGoal, greaterThan(1500));
      expect(olderGoal, greaterThan(1500));
    });

    test('should return consistent results for same input', () {
      // Arrange
      const weightKg = 75.0;
      const ageYears = 35;
      const gender = Gender.male;
      const activityLevel = ActivityLevel.intense;

      // Act
      final result1 = HydrationCalculatorService.calculateDailyWaterIntake(
        weightKg: weightKg,
        ageYears: ageYears,
        gender: gender,
        activityLevel: activityLevel,
      );

      final result2 = HydrationCalculatorService.calculateDailyWaterIntake(
        weightKg: weightKg,
        ageYears: ageYears,
        gender: gender,
        activityLevel: activityLevel,
      );

      final result3 = HydrationCalculatorService.calculateDailyWaterIntake(
        weightKg: weightKg,
        ageYears: ageYears,
        gender: gender,
        activityLevel: activityLevel,
      );

      // Assert
      expect(result1, equals(result2));
      expect(result2, equals(result3));
    });

    test('should handle all activity levels correctly', () {
      // Arrange
      const weightKg = 70.0;
      const ageYears = 30;
      const gender = Gender.male;
      final activityLevels = ActivityLevel.values;
      final results = <ActivityLevel, int>{};

      // Act
      for (final level in activityLevels) {
        results[level] = HydrationCalculatorService.calculateDailyWaterIntake(
          weightKg: weightKg,
          ageYears: ageYears,
          gender: gender,
          activityLevel: level,
        );
      }

      // Assert
      // Sedentary should be lowest, extreme should be highest
      expect(
        results[ActivityLevel.sedentary]!,
        lessThan(results[ActivityLevel.moderate]!),
      );
      expect(
        results[ActivityLevel.moderate]!,
        lessThan(results[ActivityLevel.intense]!),
      );
      expect(
        results[ActivityLevel.intense]!,
        lessThan(results[ActivityLevel.extreme]!),
      );

      // All results should be reasonable
      for (final result in results.values) {
        expect(result, greaterThan(1000));
        expect(result, lessThan(8000));
      }
    });

    test('should handle boundary weight values', () {
      // Arrange
      const ageYears = 30;
      const gender = Gender.male;
      const activityLevel = ActivityLevel.moderate;

      // Act
      final minWeight = HydrationCalculatorService.calculateDailyWaterIntake(
        weightKg: 40.0,
        ageYears: ageYears,
        gender: gender,
        activityLevel: activityLevel,
      );

      final maxWeight = HydrationCalculatorService.calculateDailyWaterIntake(
        weightKg: 120.0,
        ageYears: ageYears,
        gender: gender,
        activityLevel: activityLevel,
      );

      // Assert
      expect(maxWeight, greaterThan(minWeight));
      expect(minWeight, greaterThan(1000));
      expect(maxWeight, lessThan(6000));
    });
  });
}
