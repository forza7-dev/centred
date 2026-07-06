import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../components/photo_thumbnail.dart';
import '../../../models/field_type.dart';
import '../../../models/personalisation_settings.dart';
import '../../../models/saved_entry.dart';
import '../../../models/tool_definition.dart';
import '../widgets/document_scaffold.dart';
import '../widgets/document_section_tile.dart';
import 'document_layout_helpers.dart';

/// Fallback layout for any tool without a bespoke one — generically
/// iterates the tool's steps/fields. Ensures a future 10th tool always
/// renders something reasonable.
class GenericLayout extends StatelessWidget {
  const GenericLayout({required this.entry, required this.tool, required this.personalisation, super.key});

  final SavedEntry entry;
  final ToolDefinition? tool;
  final PersonalisationSettings personalisation;

  @override
  Widget build(BuildContext context) {
    final data = entry.data;
    final accent = personalisation.accent.colour;
    final steps = tool?.steps ?? const [];

    return DocumentScaffold(
      toolName: tool?.name ?? 'Untitled tool',
      personName: DocumentLayoutHelpers.text(data, 'name'),
      accent: accent,
      background: personalisation.background.colour,
      fontStyle: personalisation.font.textStyle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final step in steps)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(step.title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  for (final field in step.fields)
                    if (field.id != 'name')
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: switch (field.type) {
                          FieldType.text || FieldType.textarea => DocumentSectionTile(
                              title: field.label,
                              accent: accent,
                              body: DocumentLayoutHelpers.text(data, field.id),
                            ),
                          FieldType.list => DocumentSectionTile(
                              title: field.label,
                              accent: accent,
                              items: DocumentLayoutHelpers.list(data, field.id),
                            ),
                          FieldType.photo => _PhotoField(
                              label: field.label,
                              accent: accent,
                              photo: DocumentLayoutHelpers.photo(data, field.id),
                            ),
                          FieldType.photoGallery => DocumentSectionTile(
                              title: field.label,
                              accent: accent,
                              photos: DocumentLayoutHelpers.photoGallery(data, field.id),
                            ),
                          FieldType.listWithPhoto => DocumentSectionTile(
                              title: field.label,
                              accent: accent,
                              items: [
                                for (final item in DocumentLayoutHelpers.listWithPhoto(data, field.id))
                                  item.text,
                              ],
                            ),
                        },
                      ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PhotoField extends StatelessWidget {
  const _PhotoField({required this.label, required this.accent, required this.photo});

  final String label;
  final Color accent;
  final Uint8List? photo;

  @override
  Widget build(BuildContext context) {
    final bytes = photo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: TextStyle(color: accent, fontWeight: FontWeight.w700, fontSize: 12)),
        const SizedBox(height: 8),
        if (bytes != null) PhotoThumbnail(bytes: bytes, size: 96),
      ],
    );
  }
}
