import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../components/photo_thumbnail.dart';

/// Feature-specific composite widget (accent `Color` in — not a pure enum
/// or primitive alone, but still just data/callbacks, no provider reads):
/// a bordered rounded section used throughout every document layout,
/// ported from the many `p-4 rounded-xl border` blocks in the prototype's
/// `pages/view/[id].vue`.
class DocumentSectionTile extends StatelessWidget {
  const DocumentSectionTile({
    required this.title,
    required this.accent,
    this.items = const [],
    this.body,
    this.photos = const [],
    super.key,
  });

  final String title;
  final Color accent;
  final List<String> items;
  final String? body;
  final List<Uint8List> photos;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: accent,
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          if (body != null) Text(body!),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6, right: 8),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
                    ),
                  ),
                  Expanded(child: Text(item)),
                ],
              ),
            ),
          if (photos.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [for (final p in photos) PhotoThumbnail(bytes: p, size: 64)],
            ),
          ],
        ],
      ),
    );
  }
}
