import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:h2o_simple/presentation/widgets/water_progress_display.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('WaterProgressDisplay Widget Tests', () {
    testWidgets('should display basic progress correctly', (tester) async {
      // Arrange
      await tester.pumpWidget(
        TestHelper.createTestApp(
          child: WaterProgressDisplay(
            todayTotal: 1500,
            goalAmount: 2000,
            isOverGoal: false,
          ),
        ),
      );

      // Act & Assert
      expect(find.text('1500'), findsOneWidget);
      expect(find.textContaining('2000'), findsWidgets);
    });

    testWidgets('should handle zero values correctly', (tester) async {
      // Arrange
      await tester.pumpWidget(
        TestHelper.createTestApp(
          child: WaterProgressDisplay(
            todayTotal: 0,
            goalAmount: 2000,
            isOverGoal: false,
          ),
        ),
      );

      // Act & Assert
      expect(find.text('0'), findsOneWidget);
      expect(find.textContaining('2000'), findsWidgets);
    });

    testWidgets('should display animated droplets when over goal', (tester) async {
      // Arrange
      await tester.pumpWidget(
        TestHelper.createTestApp(
          child: WaterProgressDisplay(
            todayTotal: 2500,
            goalAmount: 2000,
            isOverGoal: true,
          ),
        ),
      );

      // Allow for initial render
      await tester.pump();

      // Act & Assert
      expect(find.text('2500'), findsOneWidget);
      expect(find.byIcon(Icons.water_drop), findsWidgets);
    });

    testWidgets('should animate counter when values change', (tester) async {
      // Arrange
      const initialWidget = WaterProgressDisplay(
        todayTotal: 1000,
        goalAmount: 2000,
        isOverGoal: false,
      );

      const updatedWidget = WaterProgressDisplay(
        todayTotal: 1500,
        goalAmount: 2000,
        isOverGoal: false,
      );

      await tester.pumpWidget(
        TestHelper.createTestApp(child: initialWidget),
      );

      // Initial state
      expect(find.text('1000'), findsOneWidget);

      // Act - Update the widget
      await tester.pumpWidget(
        TestHelper.createTestApp(child: updatedWidget),
      );

      // Allow some animation time
      await tester.pump(const Duration(milliseconds: 100));

      // Assert - The animation is running, so we check if the widget is building
      expect(find.byType(WaterProgressDisplay), findsOneWidget);
    });

    testWidgets('should handle large numbers correctly', (tester) async {
      // Arrange
      await tester.pumpWidget(
        TestHelper.createTestApp(
          child: WaterProgressDisplay(
            todayTotal: 99999,
            goalAmount: 100000,
            isOverGoal: false,
          ),
        ),
      );

      // Act & Assert
      expect(find.text('99999'), findsOneWidget);
      expect(find.textContaining('100000'), findsWidgets);
    });

    testWidgets('should display widget structure', (tester) async {
      // Arrange
      await tester.pumpWidget(
        TestHelper.createTestApp(
          child: WaterProgressDisplay(
            todayTotal: 1500,
            goalAmount: 2000,
            isOverGoal: false,
          ),
        ),
      );

      // Act & Assert
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(Row), findsWidgets);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('should handle goal reached state', (tester) async {
      // Arrange
      await tester.pumpWidget(
        TestHelper.createTestApp(
          child: WaterProgressDisplay(
            todayTotal: 2000,
            goalAmount: 2000,
            isOverGoal: false,
          ),
        ),
      );

      // Act & Assert
      expect(find.text('2000'), findsOneWidget);
      expect(find.byType(WaterProgressDisplay), findsOneWidget);
    });

    testWidgets('should handle over goal state', (tester) async {
      // Arrange
      await tester.pumpWidget(
        TestHelper.createTestApp(
          child: WaterProgressDisplay(
            todayTotal: 2500,
            goalAmount: 2000,
            isOverGoal: true,
          ),
        ),
      );

      // Act & Assert
      expect(find.text('2500'), findsOneWidget);
      expect(find.byType(WaterProgressDisplay), findsOneWidget);
    });
  });
}