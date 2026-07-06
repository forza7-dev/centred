import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'photo_thumbnail.dart';

/// Pure grid of [PhotoThumbnail]s plus an "add" tile. Add/remove callbacks
/// out, no business logic — the caller decides how to pick a photo.
class PhotoGalleryGrid extends StatelessWidget {
  const PhotoGalleryGrid({
    required this.photos,
    required this.onAdd,
    required this.onRemove,
    super.key,
  });

  final List<Uint8List> photos;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (var i = 0; i < photos.length; i++)
          PhotoThumbnail(bytes: photos[i], onRemove: () => onRemove(i)),
        Semantics(
          button: true,
          label: 'Add photo',
          child: InkWell(
            onTap: onAdd,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.sand,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const Icon(Icons.add_a_photo_outlined, color: AppColors.textMuted),
            ),
          ),
        ),
      ],
    );
  }
}
