// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app_from_vs/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final Finder clickerButton = find.byKey(const ValueKey('clickerButton'));
    final Finder startButton = find.byKey(const ValueKey('startTimerButton'));

    expect(find.byKey(const ValueKey('counterText')), findsOneWidget);
    expect(find.byKey(const ValueKey('topScoreText')), findsOneWidget);
    expect(find.text('0'), findsOneWidget);

    ElevatedButton disabledClicker =
        tester.widget<ElevatedButton>(clickerButton);
    expect(disabledClicker.onPressed, isNull);

    await tester.tap(startButton);
    await tester.pump();

    ElevatedButton enabledClicker =
        tester.widget<ElevatedButton>(clickerButton);
    expect(enabledClicker.onPressed, isNotNull);

    await tester.tap(clickerButton);
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Timer counts down and disables clicker at zero', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final Finder startButton = find.byKey(const ValueKey('startTimerButton'));
    final Finder clickerButton = find.byKey(const ValueKey('clickerButton'));

    expect(find.text('Timer: 00:10'), findsOneWidget);

    await tester.tap(startButton);
    await tester.pump();

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Timer: 00:09'), findsOneWidget);

    await tester.pump(const Duration(seconds: 9));
    expect(find.text('Timer: 00:00'), findsOneWidget);

    final ElevatedButton disabledClicker = tester.widget<ElevatedButton>(clickerButton);
    expect(disabledClicker.onPressed, isNull);

    await tester.tap(startButton);
    await tester.pump();

    expect(find.text('Timer: 00:10'), findsOneWidget);

    final ElevatedButton reenabledClicker = tester.widget<ElevatedButton>(clickerButton);
    expect(reenabledClicker.onPressed, isNotNull);
  });

  testWidgets('Top score updates when timer ends', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final Finder startButton = find.byKey(const ValueKey('startTimerButton'));
    final Finder clickerButton = find.byKey(const ValueKey('clickerButton'));
    final Finder topScoreText = find.byKey(const ValueKey('topScoreText'));

    expect(find.text('Top Score: 0'), findsOneWidget);

    await tester.tap(startButton);
    await tester.pump();

    for (int i = 0; i < 3; i++) {
      await tester.tap(clickerButton);
      await tester.pump();
    }

    await tester.pump(const Duration(seconds: 10));

    expect(find.text('Top Score: 3'), findsOneWidget);

    await tester.tap(startButton);
    await tester.pump();

    for (int i = 0; i < 2; i++) {
      await tester.tap(clickerButton);
      await tester.pump();
    }

    await tester.pump(const Duration(seconds: 10));

    expect(topScoreText, findsOneWidget);
    expect(find.text('Top Score: 3'), findsOneWidget);
  });
}
