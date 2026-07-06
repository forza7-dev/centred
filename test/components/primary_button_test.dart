import 'package:centred/src/components/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PrimaryButton invokes onPressed exactly once per tap', (tester) async {
    var tapCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(label: 'Go', onPressed: () => tapCount++),
        ),
      ),
    );

    await tester.tap(find.text('Go'));
    await tester.pump();

    expect(tapCount, 1);
  });

  testWidgets('PrimaryButton shows a spinner and disables tapping when isLoading', (tester) async {
    var tapCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(label: 'Go', isLoading: true, onPressed: () => tapCount++),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Go'), findsNothing);

    await tester.tap(find.byType(ElevatedButton), warnIfMissed: false);
    await tester.pump();
    expect(tapCount, 0);
  });
}
