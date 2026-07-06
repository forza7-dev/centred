import 'package:centred/src/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Dashboard -> fill wizard -> generate document end-to-end flow', (tester) async {
    tester.view.physicalSize = const Size(1200, 2600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: CentredApp()));
    await tester.pumpAndSettle();

    // Dashboard: tap "Start new" on the first tool card (About Me).
    await tester.tap(find.text('Start new').first);
    await tester.pumpAndSettle();

    // Fill wizard: first step is "The basics" (name + photo).
    expect(find.text('The basics'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'Jamie');
    await tester.pumpAndSettle();

    // Step through the remaining 3 steps to reach "Generate".
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
      await tester.pumpAndSettle();
    }

    await tester.tap(find.widgetWithText(ElevatedButton, 'Generate'));
    await tester.pumpAndSettle();

    // Document page: About Me layout header + the name we entered.
    expect(find.text('About Me'), findsWidgets);
    expect(find.text('Jamie'), findsOneWidget);
    expect(find.text('Export PDF'), findsOneWidget);
  });
}
