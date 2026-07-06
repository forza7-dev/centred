import 'package:flutter/material.dart';

import '../../../models/list_with_photo_item.dart';
import '../../../components/photo_thumbnail.dart';

/// One quadrant of the [MyPeopleLayout] diagram — its own class widget per
/// the "no functions that return widgets" rule.
class PeopleQuadrantTile extends StatelessWidget {
  const PeopleQuadrantTile({
    required this.label,
    required this.colour,
    required this.people,
    super.key,
  });

  final String label;
  final Color colour;
  final List<ListWithPhotoItem> people;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 170),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colour.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colour, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(color: colour, fontWeight: FontWeight.w700, fontSize: 12),
          ),
          const SizedBox(height: 12),
          if (people.isEmpty)
            const Text('Not filled in', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black26))
          else
            for (final person in people)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    if (person.photoBytes != null)
                      PhotoThumbnail(bytes: person.photoBytes!, circular: true, size: 32)
                    else
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: colour,
                        child: Text(
                          person.text.isNotEmpty ? person.text[0].toUpperCase() : '?',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(person.text, style: const TextStyle(fontSize: 13))),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
