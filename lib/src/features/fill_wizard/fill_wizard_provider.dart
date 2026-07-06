import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/field_type.dart';
import '../../models/field_value.dart';
import '../../models/list_with_photo_item.dart';
import '../../models/tool_definition.dart';
import '../../providers/saved_entries_provider.dart';
import '../../providers/tool_catalog_provider.dart';
import 'models/fill_wizard_state.dart';

/// One draft-in-progress wizard per entry. `autoDispose` so leaving the
/// wizard mid-fill doesn't leak state; the draft only commits back to
/// [savedEntriesProvider] on step transitions (`saveCurrentStep`), not on
/// every keystroke — mirrors the prototype's `saveCurrentStep()`.
final fillWizardProvider = StateNotifierProvider.autoDispose
    .family<FillWizardNotifier, FillWizardState, String>((ref, entryId) {
  final entry = ref.read(savedEntryProvider(entryId));
  final tool = entry == null ? null : ref.read(toolByIdProvider(entry.toolId));
  return FillWizardNotifier(
    ref: ref,
    entryId: entryId,
    tool: tool,
    initialData: entry?.data ?? const {},
  );
});

FieldValue _defaultValue(FieldType type) => switch (type) {
      FieldType.text || FieldType.textarea => const TextValue(''),
      FieldType.list => const ListValue([]),
      FieldType.photo => const PhotoValue(null),
      FieldType.photoGallery => const PhotoGalleryValue([]),
      FieldType.listWithPhoto => const ListWithPhotoValue([]),
    };

class FillWizardNotifier extends StateNotifier<FillWizardState> {
  FillWizardNotifier({
    required Ref ref,
    required this.entryId,
    required this.tool,
    required Map<String, FieldValue> initialData,
    int initialStepIndex = 0,
  })  : _ref = ref,
        super(FillWizardState(
          toolId: tool?.id ?? '',
          currentStepIndex: tool == null
              ? 0
              : initialStepIndex.clamp(0, tool.steps.length - 1),
          formData: {
            if (tool != null)
              for (final step in tool.steps)
                for (final field in step.fields)
                  field.id: initialData[field.id] ?? _defaultValue(field.type),
          },
        ));

  final Ref _ref;
  final String entryId;
  final ToolDefinition? tool;

  int get totalSteps => tool?.steps.length ?? 0;

  void setValue(String fieldId, FieldValue value) {
    state = state.copyWith(formData: {...state.formData, fieldId: value});
  }

  void setText(String fieldId, String text) => setValue(fieldId, TextValue(text));

  void addListItem(String fieldId) {
    final current = state.formData[fieldId];
    final items = current is ListValue ? current.items : <String>[];
    setValue(fieldId, ListValue([...items, '']));
  }

  void updateListItem(String fieldId, int index, String value) {
    final current = state.formData[fieldId];
    if (current is! ListValue) return;
    final items = [...current.items];
    items[index] = value;
    setValue(fieldId, ListValue(items));
  }

  void removeListItem(String fieldId, int index) {
    final current = state.formData[fieldId];
    if (current is! ListValue) return;
    final items = [...current.items]..removeAt(index);
    setValue(fieldId, ListValue(items));
  }

  /// Unconditionally appends — used by voice dictation (`listenAndAdd`),
  /// unlike [addSuggestion] which dedupes chip taps.
  void appendListItem(String fieldId, String text) {
    final current = state.formData[fieldId];
    final items = current is ListValue ? current.items : <String>[];
    setValue(fieldId, ListValue([...items, text]));
  }

  void addSuggestion(String fieldId, String suggestion) {
    final current = state.formData[fieldId];
    final items = current is ListValue ? current.items : <String>[];
    if (items.contains(suggestion)) return;
    setValue(fieldId, ListValue([...items, suggestion]));
  }

  bool isSuggestionSelected(String fieldId, String suggestion) {
    final current = state.formData[fieldId];
    return current is ListValue && current.items.contains(suggestion);
  }

  void setPhoto(String fieldId, Uint8List bytes) {
    setValue(fieldId, PhotoValue(bytes));
  }

  void addGalleryPhoto(String fieldId, Uint8List bytes) {
    final current = state.formData[fieldId];
    final items = current is PhotoGalleryValue ? current.items : <Uint8List>[];
    setValue(fieldId, PhotoGalleryValue([...items, bytes]));
  }

  void removeGalleryPhoto(String fieldId, int index) {
    final current = state.formData[fieldId];
    if (current is! PhotoGalleryValue) return;
    final items = [...current.items]..removeAt(index);
    setValue(fieldId, PhotoGalleryValue(items));
  }

  void addListWithPhotoItem(String fieldId) {
    final current = state.formData[fieldId];
    final items = current is ListWithPhotoValue ? current.items : <ListWithPhotoItem>[];
    setValue(fieldId, ListWithPhotoValue([...items, const ListWithPhotoItem()]));
  }

  void removeListWithPhotoItem(String fieldId, int index) {
    final current = state.formData[fieldId];
    if (current is! ListWithPhotoValue) return;
    final items = [...current.items]..removeAt(index);
    setValue(fieldId, ListWithPhotoValue(items));
  }

  void updateListWithPhotoText(String fieldId, int index, String text) {
    final current = state.formData[fieldId];
    if (current is! ListWithPhotoValue) return;
    final items = [...current.items];
    items[index] = items[index].copyWith(text: text);
    setValue(fieldId, ListWithPhotoValue(items));
  }

  void updateListWithPhotoPhoto(String fieldId, int index, Uint8List? bytes) {
    final current = state.formData[fieldId];
    if (current is! ListWithPhotoValue) return;
    final items = [...current.items];
    items[index] = items[index].copyWith(photoBytes: bytes);
    setValue(fieldId, ListWithPhotoValue(items));
  }

  /// Writes only the current step's fields back into the ephemeral entry
  /// store — ports the prototype's `saveCurrentStep()`.
  void saveCurrentStep() {
    final currentTool = tool;
    if (currentTool == null) return;
    final step = currentTool.steps[state.currentStepIndex];
    final notifier = _ref.read(savedEntriesProvider.notifier);
    for (final field in step.fields) {
      final value = state.formData[field.id];
      if (value != null) notifier.saveField(entryId, field.id, value);
    }
  }

  /// Jumps directly to a step — ports the prototype's `?step=last` deep
  /// link used by "Back to amend".
  void jumpToStep(int index) {
    state = state.copyWith(currentStepIndex: index.clamp(0, totalSteps - 1));
  }

  void nextStep() {
    saveCurrentStep();
    if (state.currentStepIndex < totalSteps - 1) {
      state = state.copyWith(currentStepIndex: state.currentStepIndex + 1);
    }
  }

  void prevStep() {
    saveCurrentStep();
    if (state.currentStepIndex > 0) {
      state = state.copyWith(currentStepIndex: state.currentStepIndex - 1);
    }
  }
}
