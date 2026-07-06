import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/photo_gallery_grid.dart';
import '../../../components/secondary_button.dart';
import '../../../models/field_value.dart';
import '../../../models/tool_field.dart';
import '../../../theme/app_colors.dart';
import '../../photo/services/photo_service.dart';
import '../fill_wizard_provider.dart';

/// Ports the prototype's `type === 'photo-gallery'` branch: multi-photo,
/// both Browse and Take-photo always available.
class PhotoGalleryFieldStep extends ConsumerWidget {
  const PhotoGalleryFieldStep({required this.entryId, required this.field, super.key});

  final String entryId;
  final ToolField field;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizard = ref.watch(fillWizardProvider(entryId));
    final notifier = ref.read(fillWizardProvider(entryId).notifier);
    final photoService = ref.read(photoServiceProvider);
    final value = wizard.formData[field.id];
    final photos = value is PhotoGalleryValue ? value.items : const <Uint8List>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.hint != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(field.hint!, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: PhotoGalleryGrid(
            photos: photos,
            onAdd: () async {
              final picked = await photoService.pickFromGallery();
              if (picked != null) notifier.addGalleryPhoto(field.id, picked);
            },
            onRemove: (index) => notifier.removeGalleryPhoto(field.id, index),
          ),
        ),
        SecondaryButton(
          label: 'Take photo',
          leadingIcon: Icons.photo_camera_outlined,
          onPressed: () async {
            final picked = await photoService.pickFromCamera();
            if (picked != null) notifier.addGalleryPhoto(field.id, picked);
          },
        ),
      ],
    );
  }
}
