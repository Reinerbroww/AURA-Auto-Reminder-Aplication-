import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aura/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app dan trigger frame.
    await tester.pumpWidget(const MyApp(isDarkMode: true));

    // Verify bahwa counter starts di angka 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap ikon "+" dan trigger frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify bahwa counter naik jadi 1.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
