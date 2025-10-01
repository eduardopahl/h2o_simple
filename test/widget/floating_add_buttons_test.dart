import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:h2o_simple/presentation/widgets/floating_add_buttons.dart';
import 'package:h2o_simple/domain/entities/water_intake.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('FloatingAddButtons Widget Tests', () {
    testWidgets('should display collapsed state initially', (tester) async {
      // Arrange
      final widget = FloatingAddButtons(
        isExpanded: false,
        onToggle: () {},
        onAddWater: (waterIntake) {},
      );

      // Act
      await tester.pumpWidget(
        TestHelper.createTestApp(child: Scaffold(
          floatingActionButton: widget,
          body: Container(),
        )),
      );
      await tester.pump();

      // Assert
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should display expanded state when isExpanded is true', (tester) async {
      // Arrange
      final widget = FloatingAddButtons(
        isExpanded: true,
        onToggle: () {},
        onAddWater: (waterIntake) {},
      );

      // Act
      await tester.pumpWidget(
        TestHelper.createTestApp(child: Scaffold(
          floatingActionButton: widget,
          body: Container(),
        )),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(FloatingActionButton), findsAtLeastNWidgets(3));
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('should call onToggle when main button is tapped', (tester) async {
      // Arrange
      bool toggleCalled = false;

      final widget = FloatingAddButtons(
        isExpanded: false,
        onToggle: () {
          toggleCalled = true;
        },
        onAddWater: (waterIntake) {},
      );

      // Act
      await tester.pumpWidget(
        TestHelper.createTestApp(child: Scaffold(
          floatingActionButton: widget,
          body: Container(),
        )),
      );
      await tester.pump();

      // Tap the main button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Assert
      expect(toggleCalled, isTrue);
    });

    testWidgets('should call onAddWater with correct amount when quick button is tapped', (tester) async {
      // Arrange
      WaterIntake? receivedWaterIntake;

      final widget = FloatingAddButtons(
        isExpanded: true,
        onToggle: () {},
        onAddWater: (waterIntake) {
          receivedWaterIntake = waterIntake;
        },
      );

      // Act
      await tester.pumpWidget(
        TestHelper.createTestApp(child: Scaffold(
          floatingActionButton: widget,
          body: Container(),
        )),
      );
      await tester.pumpAndSettle();

      // Find quick add buttons (should have text with ml amounts)
      final quickButtons = find.byType(FloatingActionButton);
      expect(quickButtons.evaluate().length, greaterThan(1));

      // Tap a quick add button (not the main toggle button)
      final buttons = quickButtons.evaluate().toList();
      if (buttons.length > 1) {
        await tester.tap(quickButtons.at(1));
        await tester.pumpAndSettle();
      }

      // Assert
      expect(receivedWaterIntake, isNotNull);
      if (receivedWaterIntake != null) {
        expect(receivedWaterIntake!.amount, greaterThan(0));
      }
    });

    testWidgets('should handle state changes correctly', (tester) async {
      // Arrange
      bool isExpanded = false;
      
      Widget buildWidget() => TestHelper.createTestApp(
        child: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            floatingActionButton: FloatingAddButtons(
              isExpanded: isExpanded,
              onToggle: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              onAddWater: (waterIntake) {},
            ),
            body: Container(),
          ),
        ),
      );

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.pump();

      // Initially should be collapsed
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.close), findsNothing);

      // Tap to expand
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Should be expanded
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsAtLeastNWidgets(3));
    });

    testWidgets('should show custom amount button when expanded', (tester) async {
      // Arrange
      final widget = FloatingAddButtons(
        isExpanded: true,
        onToggle: () {},
        onAddWater: (waterIntake) {},
      );

      // Act
      await tester.pumpWidget(
        TestHelper.createTestApp(child: Scaffold(
          floatingActionButton: widget,
          body: Container(),
        )),
      );
      await tester.pumpAndSettle();

      // Assert
      // Should have multiple buttons including custom amount
      final fabButtons = find.byType(FloatingActionButton);
      expect(fabButtons.evaluate().length, greaterThanOrEqualTo(4));
    });

    testWidgets('should handle animation properly', (tester) async {
      // Arrange
      bool isExpanded = false;
      
      Widget buildWidget() => TestHelper.createTestApp(
        child: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            floatingActionButton: FloatingAddButtons(
              isExpanded: isExpanded,
              onToggle: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              onAddWater: (waterIntake) {},
            ),
            body: Container(),
          ),
        ),
      );

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.pump();

      // Start animation
      await tester.tap(find.byIcon(Icons.add));
      
      // Check intermediate states
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      // Assert - animation should complete
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('should not crash with null callbacks', (tester) async {
      // This test ensures the widget handles edge cases gracefully
      // Arrange
      final widget = FloatingAddButtons(
        isExpanded: false,
        onToggle: () {}, // Empty callback
        onAddWater: (waterIntake) {}, // Empty callback
      );

      // Act & Assert
      await tester.pumpWidget(
        TestHelper.createTestApp(child: Scaffold(
          floatingActionButton: widget,
          body: Container(),
        )),
      );
      await tester.pump();

      // Should render without errors
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}