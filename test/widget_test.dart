// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:h2o_simple/main.dart';

void main() {
  testWidgets('H2O Simple app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: H2OSimpleApp()));

    // Verify that the app starts with correct title
    expect(find.text('H2O Simple'), findsOneWidget);

    // Verify that we have progress indicator
    expect(find.text('0ml'), findsOneWidget);
  });
}
