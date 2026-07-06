import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Pure pill-shaped suggestion chip — selected state in, tap out.
class SuggestionChip extends StatelessWidget {
  const SuggestionChip({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.teal : AppColors.teal.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected ? AppColors.teal : AppColors.teal.withValues(alpha: 0.3),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(color: selected ? Colors.white : AppColors.navy),
          ),
        ),
      ),
    );
  }
}
