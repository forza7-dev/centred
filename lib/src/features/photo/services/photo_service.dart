import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final photoServiceProvider = Provider<PhotoService>((ref) => PhotoService());

/// Thin wrapper around `image_picker`. Reads the picked file's bytes
/// immediately and returns only the in-memory `Uint8List` — the prototype
/// keeps photos as in-memory base64 data URLs (`FileReader.readAsDataURL`)
/// with nothing written to disk, and this mirrors that as closely as
/// `image_picker`'s OS-managed temp-cache file allows: the app itself never
/// persists the file path, only the bytes.
class PhotoService {
  final ImagePicker _picker = ImagePicker();

  Future<Uint8List?> pickFromGallery() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    return file?.readAsBytes();
  }

  Future<Uint8List?> pickFromCamera() async {
    final file = await _picker.pickImage(source: ImageSource.camera);
    return file?.readAsBytes();
  }
}
