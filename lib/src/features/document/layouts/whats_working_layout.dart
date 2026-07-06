import 'package:flutter/material.dart';

import '../../../models/personalisation_settings.dart';
import '../../../models/saved_entry.dart';
import '../widgets/document_scaffold.dart';
import '../widgets/document_section_tile.dart';
import 'document_layout_helpers.dart';

/// Ported from the "What's Working" (3-perspective) section of
/// `design-reference/app/pages/view/[id].vue`.
class WhatsWorkingLayout extends StatelessWidget {
  const WhatsWorkingLayout({required this.entry, required this.personalisation, super.key});

  final SavedEntry entry;
  final PersonalisationSettings personalisation;

  @override
  Widget build(BuildContext context) {
    final data = entry.data;
    final accent = personalisation.accent.colour;

    Widget perspective(String title, String workingId, String notWorkingId) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title.toUpperCase(), style: TextStyle(color: accent, fontWeight: FontWeight.w700, fontSize: 12)),
            const SizedBox(height: 8),
            DocumentSectionTile(title: "What's working", accent: accent, items: DocumentLayoutHelpers.list(data, workingId)),
            const SizedBox(height: 8),
            DocumentSectionTile(title: "What's not working", accent: accent, items: DocumentLayoutHelpers.list(data, notWorkingId)),
          ],
        ),
      );
    }

    return DocumentScaffold(
      toolName: "What's Working",
      personName: DocumentLayoutHelpers.text(data, 'name'),
      accent: accent,
      background: personalisation.background.colour,
      fontStyle: personalisation.font.textStyle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                perspective('Me', 'person-working', 'person-not-working'),
                const SizedBox(width: 12),
                perspective('Family & Friends', 'family-working', 'family-not-working'),
                const SizedBox(width: 12),
                perspective('Staff', 'staff-working', 'staff-not-working'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          DocumentSectionTile(
            title: 'What needs to happen next?',
            accent: accent,
            items: DocumentLayoutHelpers.list(data, 'next-steps'),
          ),
        ],
      ),
    );
  }
}
