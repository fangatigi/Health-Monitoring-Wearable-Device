import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_monitor/app_shell.dart';

void main() {
  testWidgets('App launches', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppShell(),
      ),
    );

    expect(find.text('Connecting to ESP32...'), findsOneWidget);
  });
}
