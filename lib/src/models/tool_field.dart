import 'field_type.dart';

class ToolField {
  const ToolField({
    required this.id,
    required this.label,
    required this.type,
    this.placeholder,
    this.hint,
    this.suggestions = const [],
    this.allowCamera = false,
  });

  final String id;
  final String label;
  final FieldType type;
  final String? placeholder;
  final String? hint;
  final List<String> suggestions;
  final bool allowCamera;
}
