import 'package:centred/src/models/field_value.dart';
import 'package:centred/src/providers/saved_entries_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SavedEntriesNotifier', () {
    late ProviderContainer container;

    setUp(() => container = ProviderContainer());
    tearDown(() => container.dispose());

    test('createEntry generates a unique id with empty data', () {
      final notifier = container.read(savedEntriesProvider.notifier);
      final idA = notifier.createEntry('about-me');
      final idB = notifier.createEntry('about-me');

      expect(idA, isNot(equals(idB)));
      final entries = container.read(savedEntriesProvider);
      expect(entries, hasLength(2));
      expect(entries.first.data, isEmpty);
    });

    test('saveField mirrors the name field into label', () {
      final notifier = container.read(savedEntriesProvider.notifier);
      final id = notifier.createEntry('about-me');

      notifier.saveField(id, 'name', const TextValue('Jamie'));

      final entry = notifier.getEntry(id);
      expect(entry!.label, 'Jamie');
      expect((entry.data['name'] as TextValue).value, 'Jamie');
    });

    test('saveField on a non-name field does not change the label', () {
      final notifier = container.read(savedEntriesProvider.notifier);
      final id = notifier.createEntry('about-me');
      notifier.saveField(id, 'name', const TextValue('Jamie'));

      notifier.saveField(id, 'admire', const ListValue(['Kind']));

      expect(notifier.getEntry(id)!.label, 'Jamie');
    });

    test('deleteEntry removes only the targeted entry', () {
      final notifier = container.read(savedEntriesProvider.notifier);
      final idA = notifier.createEntry('about-me');
      final idB = notifier.createEntry('my-people');

      notifier.deleteEntry(idA);

      final entries = container.read(savedEntriesProvider);
      expect(entries, hasLength(1));
      expect(entries.single.id, idB);
    });
  });
}
