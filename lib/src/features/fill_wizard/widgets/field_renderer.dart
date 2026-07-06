import 'package:flutter/material.dart';

import '../../../models/field_type.dart';
import '../../../models/tool_field.dart';
import 'list_field_step.dart';
import 'list_with_photo_field_step.dart';
import 'photo_field_step.dart';
import 'photo_gallery_field_step.dart';
import 'text_field_step.dart';
import 'textarea_field_step.dart';

/// Dispatches to the field-type-specific step widget via an inline switch
/// expression (not an extracted `_buildX()` method, per the "no functions
/// that return widgets" rule).
class FieldRenderer extends StatelessWidget {
  const FieldRenderer({required this.entryId, required this.field, super.key});

  final String entryId;
  final ToolField field;

  @override
  Widget build(BuildContext context) {
    return switch (field.type) {
      FieldType.text => TextFieldStep(entryId: entryId, field: field),
      FieldType.textarea => TextareaFieldStep(entryId: entryId, field: field),
      FieldType.list => ListFieldStep(entryId: entryId, field: field),
      FieldType.photo => PhotoFieldStep(entryId: entryId, field: field),
      FieldType.photoGallery => PhotoGalleryFieldStep(entryId: entryId, field: field),
      FieldType.listWithPhoto => ListWithPhotoFieldStep(entryId: entryId, field: field),
    };
  }
}
