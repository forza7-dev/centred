import 'package:flutter/material.dart';

import '../../../models/personalisation_settings.dart';
import '../../../models/saved_entry.dart';
import '../widgets/document_scaffold.dart';
import '../widgets/document_section_tile.dart';
import 'document_layout_helpers.dart';

/// Ported from the "My Best Day / My Worst Day" section of
/// `design-reference/app/pages/view/[id].vue`.
class BestWorstDayLayout extends StatelessWidget {
  const BestWorstDayLayout({required this.entry, required this.personalisation, super.key});

  final SavedEntry entry;
  final PersonalisationSettings personalisation;

  @override
  Widget build(BuildContext context) {
    final data = entry.data;
    final accent = personalisation.accent.colour;

    return DocumentScaffold(
      toolName: 'My Best Day / My Worst Day',
      personName: DocumentLayoutHelpers.text(data, 'name'),
      accent: accent,
      background: personalisation.background.colour,
      fontStyle: personalisation.font.textStyle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DocumentSectionTile(
                  title: 'My best day',
                  accent: const Color(0xFF6B9E7D),
                  items: DocumentLayoutHelpers.list(data, 'best'),
                  photos: DocumentLayoutHelpers.photoGallery(data, 'best-photos'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DocumentSectionTile(
                  title: 'My worst day',
                  accent: const Color(0xFFCF8872),
                  items: DocumentLayoutHelpers.list(data, 'worst'),
                  photos: DocumentLayoutHelpers.photoGallery(data, 'worst-photos'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DocumentSectionTile(
            title: 'What will it take to have more good days',
            accent: accent,
            items: DocumentLayoutHelpers.list(data, 'action'),
            photos: DocumentLayoutHelpers.photoGallery(data, 'action-photos'),
          ),
        ],
      ),
    );
  }
}
