import 'package:flutter/material.dart';

import '../models/tool_definition.dart';
import '../theme/app_colors.dart';

/// Pure rounded-square coloured icon badge, ported from the prototype's
/// `w-12 h-12 rounded-xl ... border` tool card icon.
class ToolIconBadge extends StatelessWidget {
  const ToolIconBadge({
    required this.icon,
    required this.colour,
    this.size = 48,
    super.key,
  });

  final IconData icon;
  final ToolAccentColour colour;
  final double size;

  Color get _resolved => switch (colour) {
        ToolAccentColour.teal => AppColors.teal,
        ToolAccentColour.coral => AppColors.coral,
        ToolAccentColour.navy => AppColors.navy,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _resolved.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(size / 4),
        border: Border.all(color: _resolved.withValues(alpha: 0.2)),
      ),
      child: Icon(icon, color: _resolved, size: size / 2),
    );
  }
}
