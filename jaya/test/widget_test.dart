import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jaya/main.dart';
import 'package:jaya/services/driver_app_controller.dart';

void main() {
  testWidgets('shows branded splash screen on launch', (WidgetTester tester) async {
    await tester.pumpWidget(const UberDriverApp());

    await tester.pump();
    expect(find.text('DRIVER PARTNER'), findsOneWidget);
    expect(find.text('Go live. Accept trips. Track earnings.'), findsOneWidget);
  });
}
