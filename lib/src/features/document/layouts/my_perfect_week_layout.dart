import 'package:flutter/material.dart';

import '../../../models/personalisation_settings.dart';
import '../../../models/saved_entry.dart';
import '../widgets/document_scaffold.dart';
import 'document_layout_helpers.dart';

const _days = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
const _dayLabels = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
const _periods = ['morning', 'afternoon', 'evening'];
const _periodLabels = ['Morning', 'Afternoon', 'Evening'];

/// 7-day grid, ported from the "My Perfect Week" section of
/// `design-reference/app/pages/view/[id].vue`.
class MyPerfectWeekLayout extends StatelessWidget {
  const MyPerfectWeekLayout({required this.entry, required this.personalisation, super.key});

  final SavedEntry entry;
  final PersonalisationSettings personalisation;

  @override
  Widget build(BuildContext context) {
    final data = entry.data;
    final accent = personalisation.accent.colour;

    return DocumentScaffold(
      toolName: 'My Perfect Week',
      personName: DocumentLayoutHelpers.text(data, 'name'),
      accent: accent,
      background: personalisation.background.colour,
      fontStyle: personalisation.font.textStyle,
      child: Table(
        border: TableBorder.all(color: accent.withValues(alpha: 0.15)),
        columnWidths: const {0: FixedColumnWidth(80)},
        children: [
          TableRow(
            decoration: BoxDecoration(color: accent.withValues(alpha: 0.08)),
            children: [
              const SizedBox(),
              for (final label in _dayLabels)
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: accent, fontWeight: FontWeight.w700, fontSize: 11)),
                ),
            ],
          ),
          for (var p = 0; p < _periods.length; p++)
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(_periodLabels[p], style: TextStyle(color: accent, fontWeight: FontWeight.w700, fontSize: 11)),
                ),
                for (final day in _days)
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(
                      DocumentLayoutHelpers.text(data, '$day-${_periods[p]}'),
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
