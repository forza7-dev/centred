import 'package:flutter/material.dart';

import '../../../models/personalisation_settings.dart';
import '../../../models/saved_entry.dart';
import '../widgets/document_scaffold.dart';
import 'document_layout_helpers.dart';

/// Ported from the "How I Communicate" section of
/// `design-reference/app/pages/view/[id].vue` — three states (happy,
/// unhappy, needs), each with "what happens" / "what it means" / "how to
/// respond".
class HowICommunicateLayout extends StatelessWidget {
  const HowICommunicateLayout({required this.entry, required this.personalisation, super.key});

  final SavedEntry entry;
  final PersonalisationSettings personalisation;

  @override
  Widget build(BuildContext context) {
    final data = entry.data;
    final accent = personalisation.accent.colour;

    Widget state(String title, String signsId, String meaningId, String responseId) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: accent.withValues(alpha: 0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title.toUpperCase(), style: TextStyle(color: accent, fontWeight: FontWeight.w700, fontSize: 12)),
              const SizedBox(height: 10),
              const Text('What happens', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              for (final item in DocumentLayoutHelpers.list(data, signsId)) Text('• $item', style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 8),
              const Text('What it means', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              Text(DocumentLayoutHelpers.text(data, meaningId), style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 8),
              const Text('How to respond', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              Text(DocumentLayoutHelpers.text(data, responseId), style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
      );
    }

    return DocumentScaffold(
      toolName: 'How I Communicate',
      personName: DocumentLayoutHelpers.text(data, 'name'),
      accent: accent,
      background: personalisation.background.colour,
      fontStyle: personalisation.font.textStyle,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            state('When happy or comfortable', 'happy-signs', 'happy-meaning', 'happy-response'),
            const SizedBox(width: 12),
            state('When unhappy or uncomfortable', 'unhappy-signs', 'unhappy-meaning', 'unhappy-response'),
            const SizedBox(width: 12),
            state('When I need something', 'needs-signs', 'needs-meaning', 'needs-response'),
          ],
        ),
      ),
    );
  }
}
