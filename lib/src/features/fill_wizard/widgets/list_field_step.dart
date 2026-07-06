import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/add_item_link.dart';
import '../../../components/app_text_field.dart';
import '../../../components/icon_only_button.dart';
import '../../../components/speech_mic_button.dart';
import '../../../components/suggestion_chip.dart';
import '../../../models/field_value.dart';
import '../../../models/tool_field.dart';
import '../../../theme/app_colors.dart';
import '../../speech/speech_provider.dart';
import '../fill_wizard_provider.dart';

/// Ports the prototype's `type === 'list'` branch: optional suggestion
/// chips, editable list items, "Add item", and "Speak to add".
class ListFieldStep extends ConsumerWidget {
  const ListFieldStep({required this.entryId, required this.field, super.key});

  final String entryId;
  final ToolField field;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizard = ref.watch(fillWizardProvider(entryId));
    final speech = ref.watch(speechProvider);
    final notifier = ref.read(fillWizardProvider(entryId).notifier);
    final value = wizard.formData[field.id];
    final items = value is ListValue ? value.items : const <String>[];
    final listeningKey = 'voice-list-${field.id}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.suggestions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final suggestion in field.suggestions)
                  SuggestionChip(
                    label: suggestion,
                    selected: notifier.isSuggestionSelected(field.id, suggestion),
                    onTap: () => notifier.addSuggestion(field.id, suggestion),
                  ),
              ],
            ),
          ),
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    '${i + 1}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppTextField(
                    value: items[i],
                    placeholder: field.placeholder,
                    onChanged: (v) => notifier.updateListItem(field.id, i, v),
                  ),
                ),
                IconOnlyButton(
                  icon: Icons.close,
                  tooltip: 'Remove item',
                  colour: AppColors.textMuted,
                  onPressed: () => notifier.removeListItem(field.id, i),
                ),
              ],
            ),
          ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          children: [
            AddItemLink(label: 'Add item', onTap: () => notifier.addListItem(field.id)),
            if (speech.isSupported)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpeechMicButton(
                    isListening: speech.listeningFieldId == listeningKey,
                    onTap: () => ref.read(speechProvider.notifier).listenAndAdd(
                          field.id,
                          onAppend: (text) => notifier.appendListItem(field.id, text),
                        ),
                  ),
                  Text(
                    speech.listeningFieldId == listeningKey ? 'Listening...' : 'Speak to add',
                    style: const TextStyle(color: AppColors.textMuted),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
