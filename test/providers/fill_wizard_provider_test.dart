import 'package:centred/src/features/fill_wizard/fill_wizard_provider.dart';
import 'package:centred/src/models/field_value.dart';
import 'package:centred/src/providers/saved_entries_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FillWizardNotifier', () {
    late ProviderContainer container;
    late String entryId;

    setUp(() {
      container = ProviderContainer();
      entryId = container.read(savedEntriesProvider.notifier).createEntry('about-me');
    });

    tearDown(() => container.dispose());

    test('nextStep does not advance past the last step', () {
      final notifier = container.read(fillWizardProvider(entryId).notifier);
      final total = notifier.totalSteps;

      for (var i = 0; i < total + 3; i++) {
        notifier.nextStep();
      }

      expect(container.read(fillWizardProvider(entryId)).currentStepIndex, total - 1);
    });

    test('prevStep does not go below the first step', () {
      final notifier = container.read(fillWizardProvider(entryId).notifier);
      notifier.prevStep();
      notifier.prevStep();

      expect(container.read(fillWizardProvider(entryId)).currentStepIndex, 0);
    });

    test('saveCurrentStep only commits the current step\'s fields', () {
      final notifier = container.read(fillWizardProvider(entryId).notifier);
      // Step 0 ("The basics") has fields: name, photo.
      notifier.setText('name', 'Jamie');
      // Field from a later step shouldn't exist as a draft key collision
      // issue, but saveCurrentStep should only push step-0 fields.
      notifier.saveCurrentStep();

      final saved = container.read(savedEntriesProvider.notifier).getEntry(entryId)!;
      expect((saved.data['name'] as TextValue).value, 'Jamie');
      expect(saved.data.containsKey('admire'), isFalse);
    });

    test('addListItem / updateListItem / removeListItem mutate only the targeted field', () {
      final notifier = container.read(fillWizardProvider(entryId).notifier);
      notifier.nextStep(); // move to the "admire" (list) step
      notifier.addListItem('admire');
      notifier.addListItem('admire');
      notifier.updateListItem('admire', 1, 'Funny');

      final value = container.read(fillWizardProvider(entryId)).formData['admire'] as ListValue;
      expect(value.items, ['', 'Funny']);

      notifier.removeListItem('admire', 0);
      final afterRemove = container.read(fillWizardProvider(entryId)).formData['admire'] as ListValue;
      expect(afterRemove.items, ['Funny']);
    });
  });
}
