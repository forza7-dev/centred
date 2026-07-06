import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/add_item_link.dart';
import '../../../components/app_text_field.dart';
import '../../../components/icon_only_button.dart';
import '../../../components/photo_thumbnail.dart';
import '../../../models/field_value.dart';
import '../../../models/tool_field.dart';
import '../../../theme/app_colors.dart';
import '../../photo/services/photo_service.dart';
import '../fill_wizard_provider.dart';

/// Ports the prototype's `type === 'list-with-photo'` branch — the most
/// complex field type: per-item circular photo (browse or camera) + delete
/// + name text field + remove-item button.
class ListWithPhotoFieldStep extends ConsumerWidget {
  const ListWithPhotoFieldStep({required this.entryId, required this.field, super.key});

  final String entryId;
  final ToolField field;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizard = ref.watch(fillWizardProvider(entryId));
    final notifier = ref.read(fillWizardProvider(entryId).notifier);
    final photoService = ref.read(photoServiceProvider);
    final value = wizard.formData[field.id];
    final items = value is ListWithPhotoValue ? value.items : const [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                _PersonPhotoPicker(
                  bytes: items[i].photoBytes,
                  onBrowse: () async {
                    final picked = await photoService.pickFromGallery();
                    if (picked != null) notifier.updateListWithPhotoPhoto(field.id, i, picked);
                  },
                  onCamera: () async {
                    final picked = await photoService.pickFromCamera();
                    if (picked != null) notifier.updateListWithPhotoPhoto(field.id, i, picked);
                  },
                  onRemove: () => notifier.updateListWithPhotoPhoto(field.id, i, null),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    value: items[i].text,
                    placeholder: field.placeholder,
                    onChanged: (v) => notifier.updateListWithPhotoText(field.id, i, v),
                  ),
                ),
                IconOnlyButton(
                  icon: Icons.close,
                  tooltip: 'Remove person',
                  colour: AppColors.textMuted,
                  onPressed: () => notifier.removeListWithPhotoItem(field.id, i),
                ),
              ],
            ),
          ),
        AddItemLink(label: 'Add person', onTap: () => notifier.addListWithPhotoItem(field.id)),
      ],
    );
  }
}

class _PersonPhotoPicker extends StatelessWidget {
  const _PersonPhotoPicker({
    required this.bytes,
    required this.onBrowse,
    required this.onCamera,
    required this.onRemove,
  });

  final Uint8List? bytes;
  final VoidCallback onBrowse;
  final VoidCallback onCamera;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: onBrowse,
          borderRadius: BorderRadius.circular(24),
          child: bytes != null
              ? PhotoThumbnail(bytes: bytes!, circular: true, size: 48)
              : Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.cardBorder, width: 2),
                  ),
                  child: const Icon(Icons.person_add_alt_outlined, color: AppColors.textMuted, size: 20),
                ),
        ),
        Positioned(
          bottom: -2,
          right: -2,
          child: Semantics(
            button: true,
            label: 'Take photo',
            child: InkWell(
              onTap: onCamera,
              borderRadius: BorderRadius.circular(999),
              child: const CircleAvatar(
                radius: 10,
                backgroundColor: AppColors.teal,
                child: Icon(Icons.photo_camera, size: 12, color: Colors.white),
              ),
            ),
          ),
        ),
        if (bytes != null)
          Positioned(
            top: -2,
            right: -2,
            child: Semantics(
              button: true,
              label: 'Remove photo',
              child: InkWell(
                onTap: onRemove,
                borderRadius: BorderRadius.circular(999),
                child: const CircleAvatar(
                  radius: 10,
                  backgroundColor: AppColors.coral,
                  child: Icon(Icons.close, size: 12, color: Colors.white),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
