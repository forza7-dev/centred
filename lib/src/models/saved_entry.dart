import 'field_value.dart';

class SavedEntry {
  const SavedEntry({
    required this.id,
    required this.toolId,
    this.label = '',
    this.data = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String toolId;
  final String label;
  final Map<String, FieldValue> data;
  final DateTime createdAt;
  final DateTime updatedAt;

  SavedEntry copyWith({
    String? label,
    Map<String, FieldValue>? data,
    DateTime? updatedAt,
  }) =>
      SavedEntry(
        id: id,
        toolId: toolId,
        label: label ?? this.label,
        data: data ?? this.data,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
