import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Pure single-photo renderer. `Uint8List` in (never a file path — see the
/// ephemeral-data note on `photo_service.dart`), optional remove callback.
class PhotoThumbnail extends StatelessWidget {
  const PhotoThumbnail({
    required this.bytes,
    this.onRemove,
    this.circular = false,
    this.size = 96,
    super.key,
  });

  final Uint8List bytes;
  final VoidCallback? onRemove;
  final bool circular;
  final double size;

  @override
  Widget build(BuildContext context) {
    final image = ClipRRect(
      borderRadius: circular ? BorderRadius.circular(size) : BorderRadius.circular(12),
      child: Image.memory(bytes, width: size, height: size, fit: BoxFit.cover),
    );

    if (onRemove == null) return image;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        image,
        Positioned(
          top: -8,
          right: -8,
          child: Semantics(
            button: true,
            label: 'Remove photo',
            child: InkWell(
              onTap: onRemove,
              borderRadius: BorderRadius.circular(999),
              child: const CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.navy,
                child: Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
