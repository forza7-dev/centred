import 'package:flutter/material.dart';

import '../../../models/personalisation_settings.dart';
import '../../../models/saved_entry.dart';
import '../widgets/document_scaffold.dart';
import '../widgets/document_section_tile.dart';
import 'document_layout_helpers.dart';

const _storyQuadrants = [
  (fieldId: 'dreams', label: 'My Dreams', colour: Color(0xFF8B7EC4), isList: false),
  (fieldId: 'nightmares', label: 'My Nightmares', colour: Color(0xFF6B9E7D), isList: false),
  (fieldId: 'about', label: 'About Me', colour: Color(0xFF72B9CF), isList: true),
  (fieldId: 'gifts', label: 'My Gifts', colour: Color(0xFFC1666B), isList: true),
  (fieldId: 'support', label: 'To Support Me', colour: Color(0xFFC97B96), isList: true),
];

/// MAPS-style layout, ported from the "My Story" section of
/// `design-reference/app/pages/view/[id].vue` — a "My Story" narrative at
/// the top, five thematic quadrants, and an action plan at the bottom.
class MyStoryLayout extends StatelessWidget {
  const MyStoryLayout({required this.entry, required this.personalisation, super.key});

  final SavedEntry entry;
  final PersonalisationSettings personalisation;

  @override
  Widget build(BuildContext context) {
    final data = entry.data;
    final accent = personalisation.accent.colour;

    return DocumentScaffold(
      toolName: 'My Story',
      personName: DocumentLayoutHelpers.text(data, 'name'),
      accent: accent,
      background: personalisation.background.colour,
      fontStyle: personalisation.font.textStyle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DocumentSectionTile(
            title: 'My Story',
            accent: const Color(0xFFCF8872),
            items: DocumentLayoutHelpers.list(data, 'story'),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final quadrant in _storyQuadrants)
                SizedBox(
                  width: 220,
                  child: DocumentSectionTile(
                    title: quadrant.label,
                    accent: quadrant.colour,
                    items: quadrant.isList ? DocumentLayoutHelpers.list(data, quadrant.fieldId) : const [],
                    body: quadrant.isList ? null : DocumentLayoutHelpers.text(data, quadrant.fieldId),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          DocumentSectionTile(
            title: 'Action Plan',
            accent: const Color(0xFF161F38),
            items: DocumentLayoutHelpers.list(data, 'action-plan'),
          ),
        ],
      ),
    );
  }
}
