import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

/// Shared document chrome — accent-coloured header bar (tool name + the
/// entry's "name" field, if present) wrapping a personalised background
/// and font, ported from the header block in
/// `design-reference/app/pages/view/[id].vue`.
class DocumentScaffold extends StatelessWidget {
  const DocumentScaffold({
    required this.toolName,
    required this.personName,
    required this.accent,
    required this.background,
    required this.fontStyle,
    required this.child,
    super.key,
  });

  final String toolName;
  final String? personName;
  final Color accent;
  final Color background;
  final TextStyle fontStyle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: fontStyle.copyWith(color: AppColors.textPrimary),
      child: Container(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              color: accent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    toolName,
                    style: fontStyle.copyWith(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (personName != null && personName!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        personName!,
                        style: fontStyle.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 18,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(padding: const EdgeInsets.all(20), child: child),
          ],
        ),
      ),
    );
  }
}
