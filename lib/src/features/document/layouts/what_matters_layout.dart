import 'package:flutter/material.dart';

import '../../../models/personalisation_settings.dart';
import '../../../models/saved_entry.dart';
import '../widgets/document_scaffold.dart';
import '../widgets/document_section_tile.dart';
import 'document_layout_helpers.dart';

/// Ported from the "What Matters & What Helps" section of
/// `design-reference/app/pages/view/[id].vue`.
class WhatMattersLayout extends StatelessWidget {
  const WhatMattersLayout({required this.entry, required this.personalisation, super.key});

  final SavedEntry entry;
  final PersonalisationSettings personalisation;

  @override
  Widget build(BuildContext context) {
    final data = entry.data;
    final accent = personalisation.accent.colour;

    return DocumentScaffold(
      toolName: 'What Matters & What Helps',
      personName: DocumentLayoutHelpers.text(data, 'name'),
      accent: accent,
      background: personalisation.background.colour,
      fontStyle: personalisation.font.textStyle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DocumentSectionTile(
            title: 'What matters to me',
            accent: accent,
            items: DocumentLayoutHelpers.list(data, 'matters'),
            photos: DocumentLayoutHelpers.photoGallery(data, 'matters-photos'),
          ),
          const SizedBox(height: 16),
          DocumentSectionTile(
            title: 'What helps me stay well',
            accent: accent,
            items: DocumentLayoutHelpers.list(data, 'helps'),
            photos: DocumentLayoutHelpers.photoGallery(data, 'helps-photos'),
          ),
        ],
      ),
    );
  }
}
