import 'package:flutter/material.dart';

import '../../../components/photo_thumbnail.dart';
import '../../../models/personalisation_settings.dart';
import '../../../models/saved_entry.dart';
import '../widgets/document_scaffold.dart';
import '../widgets/document_section_tile.dart';
import 'document_layout_helpers.dart';

/// Ported from the "About Me: Grid layout" section of
/// `design-reference/app/pages/view/[id].vue`.
class AboutMeLayout extends StatelessWidget {
  const AboutMeLayout({required this.entry, required this.personalisation, super.key});

  final SavedEntry entry;
  final PersonalisationSettings personalisation;

  @override
  Widget build(BuildContext context) {
    final data = entry.data;
    final accent = personalisation.accent.colour;
    final photo = DocumentLayoutHelpers.photo(data, 'photo');

    return DocumentScaffold(
      toolName: 'About Me',
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
              if (photo != null)
                PhotoThumbnail(bytes: photo, size: 140)
              else
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.person_outline, size: 56, color: accent.withValues(alpha: 0.2)),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: DocumentSectionTile(
                  title: 'What people like and admire about me',
                  accent: accent,
                  items: DocumentLayoutHelpers.list(data, 'admire'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DocumentSectionTile(
            title: 'What is important to me',
            accent: accent,
            items: DocumentLayoutHelpers.list(data, 'important'),
            photos: DocumentLayoutHelpers.photoGallery(data, 'important-photos'),
          ),
          const SizedBox(height: 16),
          DocumentSectionTile(
            title: 'How to support me well',
            accent: accent,
            items: DocumentLayoutHelpers.list(data, 'support'),
            photos: DocumentLayoutHelpers.photoGallery(data, 'support-photos'),
          ),
        ],
      ),
    );
  }
}
