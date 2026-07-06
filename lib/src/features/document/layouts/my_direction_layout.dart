import 'package:flutter/material.dart';

import '../../../models/personalisation_settings.dart';
import '../../../models/saved_entry.dart';
import '../widgets/document_scaffold.dart';
import '../widgets/document_section_tile.dart';
import 'document_layout_helpers.dart';

const _pathSteps = [
  (fieldId: 'goals', label: 'Goals'),
  (fieldId: 'now', label: 'Things now'),
  (fieldId: 'who', label: 'People and services'),
  (fieldId: 'working', label: "Working and not working"),
  (fieldId: 'three-months', label: 'Next three months'),
  (fieldId: 'next-month', label: 'Next month'),
  (fieldId: 'first-steps', label: 'First steps'),
];

/// PATH-style direction plan, ported from the "My Direction" section of
/// `design-reference/app/pages/view/[id].vue` — a highlighted "dream" at
/// the top, followed by the sequential planning steps.
class MyDirectionLayout extends StatelessWidget {
  const MyDirectionLayout({required this.entry, required this.personalisation, super.key});

  final SavedEntry entry;
  final PersonalisationSettings personalisation;

  @override
  Widget build(BuildContext context) {
    final data = entry.data;
    final accent = personalisation.accent.colour;

    return DocumentScaffold(
      toolName: 'My Direction',
      personName: DocumentLayoutHelpers.text(data, 'name'),
      accent: accent,
      background: personalisation.background.colour,
      fontStyle: personalisation.font.textStyle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('MY DREAM', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                const SizedBox(height: 8),
                Text(DocumentLayoutHelpers.text(data, 'dream'), style: const TextStyle(color: Colors.white, fontSize: 15)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (var i = 0; i < _pathSteps.length; i++)
                SizedBox(
                  width: 200,
                  child: DocumentSectionTile(
                    title: '${i + 1}. ${_pathSteps[i].label}',
                    accent: accent,
                    items: DocumentLayoutHelpers.list(data, _pathSteps[i].fieldId),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
