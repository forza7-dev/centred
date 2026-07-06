import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/app_textarea_field.dart';
import '../../../components/speech_mic_button.dart';
import '../../../models/field_value.dart';
import '../../../models/tool_field.dart';
import '../../speech/speech_provider.dart';
import '../fill_wizard_provider.dart';

/// Ports the prototype's `type === 'textarea'` branch.
class TextareaFieldStep extends ConsumerWidget {
  const TextareaFieldStep({required this.entryId, required this.field, super.key});

  final String entryId;
  final ToolField field;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizard = ref.watch(fillWizardProvider(entryId));
    final speech = ref.watch(speechProvider);
    final value = wizard.formData[field.id];
    final text = value is TextValue ? value.value : '';

    return AppTextareaField(
      value: text,
      placeholder: field.placeholder,
      onChanged: (v) => ref.read(fillWizardProvider(entryId).notifier).setText(field.id, v),
      trailing: SpeechMicButton(
        enabled: speech.isSupported,
        isListening: speech.listeningFieldId == field.id,
        onTap: () => ref.read(speechProvider.notifier).listen(
              field.id,
              onResult: (result) =>
                  ref.read(fillWizardProvider(entryId).notifier).setText(field.id, result),
            ),
      ),
    );
  }
}
