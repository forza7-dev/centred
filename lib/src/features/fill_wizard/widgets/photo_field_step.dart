import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/photo_thumbnail.dart';
import '../../../components/secondary_button.dart';
import '../../../models/field_value.dart';
import '../../../models/tool_field.dart';
import '../../../theme/app_colors.dart';
import '../../photo/services/photo_service.dart';
import '../fill_wizard_provider.dart';

/// Ports the prototype's `type === 'photo'` branch: single photo with
/// optional camera capture, gated on `field.allowCamera`.
class PhotoFieldStep extends ConsumerWidget {
  const PhotoFieldStep({required this.entryId, required this.field, super.key});

  final String entryId;
  final ToolField field;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizard = ref.watch(fillWizardProvider(entryId));
    final notifier = ref.read(fillWizardProvider(entryId).notifier);
    final photoService = ref.read(photoServiceProvider);
    final value = wizard.formData[field.id];
    final bytes = value is PhotoValue ? value.bytes : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.hint != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(field.hint!, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          ),
        if (bytes != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: PhotoThumbnail(bytes: bytes, size: 128),
          ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            SecondaryButton(
              label: 'Browse',
              leadingIcon: Icons.photo_library_outlined,
              onPressed: () async {
                final picked = await photoService.pickFromGallery();
                if (picked != null) notifier.setPhoto(field.id, picked);
              },
            ),
            if (field.allowCamera)
              SecondaryButton(
                label: 'Take photo',
                leadingIcon: Icons.photo_camera_outlined,
                onPressed: () async {
                  final picked = await photoService.pickFromCamera();
                  if (picked != null) notifier.setPhoto(field.id, picked);
                },
              ),
          ],
        ),
      ],
    );
  }
}
