import 'dart:typed_data';

import '../../../models/field_value.dart';
import '../../../models/list_with_photo_item.dart';

/// Shared, static value-reading helpers used by every document layout —
/// keeps each of the 9 bespoke layouts from repeating `FieldValue` unwrap
/// boilerplate.
abstract final class DocumentLayoutHelpers {
  static String text(Map<String, FieldValue> data, String fieldId) {
    final value = data[fieldId];
    return value is TextValue ? value.value : '';
  }

  static List<String> list(Map<String, FieldValue> data, String fieldId) {
    final value = data[fieldId];
    return value is ListValue ? value.items : const [];
  }

  static Uint8List? photo(Map<String, FieldValue> data, String fieldId) {
    final value = data[fieldId];
    return value is PhotoValue ? value.bytes : null;
  }

  static List<Uint8List> photoGallery(Map<String, FieldValue> data, String fieldId) {
    final value = data[fieldId];
    return value is PhotoGalleryValue ? value.items : const [];
  }

  static List<ListWithPhotoItem> listWithPhoto(Map<String, FieldValue> data, String fieldId) {
    final value = data[fieldId];
    return value is ListWithPhotoValue ? value.items : const [];
  }
}
