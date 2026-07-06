import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/field_value.dart';
import '../models/saved_entry.dart';

final _random = Random();

/// The ephemeral, in-memory "database" of entries — this provider's
/// container lifetime *is* the storage, replacing the prototype's
/// module-level `memoryStore` array (`useToolData.ts`). Nothing here ever
/// touches disk or network.
final savedEntriesProvider =
    StateNotifierProvider<SavedEntriesNotifier, List<SavedEntry>>(
  (ref) => SavedEntriesNotifier(),
);

final savedEntryProvider = Provider.family<SavedEntry?, String>((ref, entryId) {
  final entries = ref.watch(savedEntriesProvider);
  for (final entry in entries) {
    if (entry.id == entryId) return entry;
  }
  return null;
});

class SavedEntriesNotifier extends StateNotifier<List<SavedEntry>> {
  SavedEntriesNotifier() : super(const []);

  String createEntry(String toolId) {
    final id = _generateId();
    final now = DateTime.now();
    state = [
      ...state,
      SavedEntry(id: id, toolId: toolId, createdAt: now, updatedAt: now),
    ];
    return id;
  }

  SavedEntry? getEntry(String entryId) {
    for (final entry in state) {
      if (entry.id == entryId) return entry;
    }
    return null;
  }

  /// Writes a single field's value into an entry's data map. Mirrors the
  /// prototype's special case: setting the `name` field also updates the
  /// entry's display `label` on the dashboard.
  void saveField(String entryId, String fieldId, FieldValue value) {
    state = [
      for (final entry in state)
        if (entry.id == entryId)
          entry.copyWith(
            data: {...entry.data, fieldId: value},
            updatedAt: DateTime.now(),
            label: fieldId == 'name' && value is TextValue && value.value.trim().isNotEmpty
                ? value.value.trim()
                : null,
          )
        else
          entry,
    ];
  }

  void deleteEntry(String entryId) {
    state = state.where((entry) => entry.id != entryId).toList();
  }

  String _generateId() {
    final timestamp = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
    final suffix = _random.nextInt(0xFFFFFFFF).toRadixString(36);
    return '$timestamp$suffix';
  }
}
