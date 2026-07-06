import 'package:centred/src/features/document/document_page.dart';
import 'package:centred/src/providers/saved_entries_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DocumentPage renders the bespoke layout for a known tool', (tester) async {
    final container = ProviderContainer();
    final entryId = container.read(savedEntriesProvider.notifier).createEntry('my-people');

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(home: DocumentPage(entryId: entryId)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('My People'), findsWidgets);
    // MyPeopleLayout's quadrant labels prove the bespoke layout was picked,
    // not the generic fallback.
    expect(find.text('CLOSEST TO ME'), findsOneWidget);

    container.dispose();
  });

  testWidgets('DocumentPage falls back to the generic layout for an unrecognised tool id', (tester) async {
    final container = ProviderContainer();
    // "Start new" always goes through createEntry with a real catalog id,
    // but an entry can end up with a stale/unknown toolId if a tool is
    // ever removed from the catalog — the generic layout must still render.
    final notifier = container.read(savedEntriesProvider.notifier);
    final entryId = notifier.createEntry('some-future-tool');

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(home: DocumentPage(entryId: entryId)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Untitled tool'), findsOneWidget);
    expect(find.text('Export PDF'), findsOneWidget);

    container.dispose();
  });
}
