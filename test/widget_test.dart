import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zubimovie/main.dart';

void main() {
  testWidgets('MyApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MaterialApp), findsOneWidget);
    // SplashScreen schedules a 3s navigation timer; advance it so the test exits cleanly.
    await tester.pump(const Duration(seconds: 4));
  });
}
