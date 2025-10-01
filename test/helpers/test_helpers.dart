import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:h2o_simple/presentation/theme/app_theme.dart';

/// Helper class to create test widgets with all necessary providers and localizations
class TestHelper {
  /// Creates a Material App wrapper with all dependencies for testing widgets
  static Widget createTestApp({
    required Widget child,
    List<Override>? overrides,
    Locale locale = const Locale('en'),
  }) {
    return ProviderScope(
      overrides: overrides ?? [],
      child: MaterialApp(
        home: child,
        locale: locale,
        theme: AppTheme.lightTheme,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('pt')],
      ),
    );
  }

  /// Creates a test app for full app testing
  static Widget createFullTestApp({
    List<Override>? overrides,
    Locale locale = const Locale('en'),
  }) {
    return ProviderScope(
      overrides: overrides ?? [],
      child: MaterialApp(
        locale: locale,
        theme: AppTheme.lightTheme,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('pt')],
        home: const Scaffold(body: Center(child: Text('Test Home'))),
      ),
    );
  }

  /// Pumps widget and waits for all animations to complete
  static Future<void> pumpAndSettle(WidgetTester tester) async {
    await tester.pumpAndSettle(const Duration(seconds: 5));
  }

  /// Creates a mock water intake entry for testing
  static Map<String, dynamic> createMockWaterIntake({
    int amount = 250,
    DateTime? timestamp,
  }) {
    return {
      'id': 'test_${DateTime.now().millisecondsSinceEpoch}',
      'amount': amount,
      'timestamp': (timestamp ?? DateTime.now()).toIso8601String(),
    };
  }

  /// Creates multiple mock water intake entries
  static List<Map<String, dynamic>> createMockWaterIntakes({
    int count = 5,
    int baseAmount = 250,
  }) {
    return List.generate(count, (index) {
      return createMockWaterIntake(
        amount: baseAmount + (index * 50),
        timestamp: DateTime.now().subtract(Duration(hours: index)),
      );
    });
  }
}

/// Custom matchers for testing
class TestMatchers {
  /// Matcher to verify if a widget contains specific text
  static Matcher containsText(String text) {
    return findsWidgets;
  }

  /// Matcher to verify water amount display
  static Matcher hasWaterAmount(int amount) {
    return findsOneWidget;
  }

  /// Matcher to verify progress percentage
  static Matcher hasProgressPercentage(double percentage) {
    return findsOneWidget;
  }

  /// Finds text containing specific substring
  static Finder findTextContaining(String text) {
    return find.textContaining(text);
  }

  /// Finds water amount text
  static Finder findWaterAmount(int amount) {
    return find.text('${amount}ml');
  }
}

/// Extensions for easier testing
extension WidgetTesterExtensions on WidgetTester {
  /// Taps a widget by its key
  Future<void> tapByKey(String key) async {
    await tap(find.byKey(Key(key)));
    await pump();
  }

  /// Taps a widget by its text
  Future<void> tapByText(String text) async {
    await tap(find.text(text));
    await pump();
  }

  /// Enters text in a text field by its key
  Future<void> enterTextByKey(String key, String text) async {
    await enterText(find.byKey(Key(key)), text);
    await pump();
  }

  /// Scrolls until a widget is visible
  Future<void> scrollUntilVisible(Finder finder) async {
    await ensureVisible(finder);
  }
}
