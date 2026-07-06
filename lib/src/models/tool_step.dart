import 'tool_field.dart';

class ToolStep {
  const ToolStep({
    required this.id,
    required this.title,
    this.description,
    required this.fields,
  });

  final String id;
  final String title;
  final String? description;
  final List<ToolField> fields;
}
