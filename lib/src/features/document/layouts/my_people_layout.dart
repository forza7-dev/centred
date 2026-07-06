import 'package:flutter/material.dart';

import '../../../components/photo_thumbnail.dart';
import '../../../models/personalisation_settings.dart';
import '../../../models/saved_entry.dart';
import '../widgets/document_scaffold.dart';
import 'document_layout_helpers.dart';
import 'people_quadrant_tile.dart';

const _quadrants = [
  (fieldId: 'closest', label: 'Closest to me', colour: Color(0xFFCF8872)),
  (fieldId: 'important', label: 'Important to me', colour: Color(0xFFD99A5B)),
  (fieldId: 'wider', label: 'Other people in my life', colour: Color(0xFF6B9E7D)),
  (fieldId: 'paid', label: 'Paid support', colour: Color(0xFF9B8AB8)),
];

/// Concentric people-diagram layout, ported from the `isMyPeople` section
/// of `design-reference/app/pages/view/[id].vue` (a 2x2 quadrant grid with
/// "Me" overlaid in the centre).
class MyPeopleLayout extends StatelessWidget {
  const MyPeopleLayout({required this.entry, required this.personalisation, super.key});

  final SavedEntry entry;
  final PersonalisationSettings personalisation;

  @override
  Widget build(BuildContext context) {
    final data = entry.data;
    final mePhoto = DocumentLayoutHelpers.photo(data, 'me-photo');

    return DocumentScaffold(
      toolName: 'My People',
      personName: DocumentLayoutHelpers.text(data, 'name'),
      accent: personalisation.accent.colour,
      background: personalisation.background.colour,
      fontStyle: personalisation.font.textStyle,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                for (final quadrant in _quadrants)
                  PeopleQuadrantTile(
                    label: quadrant.label,
                    colour: quadrant.colour,
                    people: DocumentLayoutHelpers.listWithPhoto(data, quadrant.fieldId),
                  ),
              ],
            ),
          ),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF72B9CF), width: 2.5),
            ),
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            child: mePhoto != null
                ? PhotoThumbnail(bytes: mePhoto, circular: true, size: 56)
                : const Text('Me', style: TextStyle(color: Color(0xFF72B9CF), fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
