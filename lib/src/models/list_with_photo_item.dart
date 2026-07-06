import 'dart:typed_data';

class ListWithPhotoItem {
  const ListWithPhotoItem({this.text = '', this.photoBytes});

  final String text;
  final Uint8List? photoBytes;

  ListWithPhotoItem copyWith({String? text, Uint8List? photoBytes}) =>
      ListWithPhotoItem(
        text: text ?? this.text,
        photoBytes: photoBytes ?? this.photoBytes,
      );
}
