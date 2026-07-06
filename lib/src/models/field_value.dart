import 'dart:typed_data';

import 'list_with_photo_item.dart';

/// Replaces the prototype's `Record<string, string | string[]>` (plus its
/// `JSON.stringify({text, photo})` hack for list-with-photo) with a proper
/// exhaustive-switch-safe union, since Dart has no `string | string[]` type.
sealed class FieldValue {
  const FieldValue();
}

class TextValue extends FieldValue {
  const TextValue(this.value);
  final String value;
}

class ListValue extends FieldValue {
  const ListValue(this.items);
  final List<String> items;
}

class PhotoValue extends FieldValue {
  const PhotoValue(this.bytes);
  final Uint8List? bytes;
}

class PhotoGalleryValue extends FieldValue {
  const PhotoGalleryValue(this.items);
  final List<Uint8List> items;
}

class ListWithPhotoValue extends FieldValue {
  const ListWithPhotoValue(this.items);
  final List<ListWithPhotoItem> items;
}
