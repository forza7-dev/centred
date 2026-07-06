import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Pure "+ Add item" inline text-link-with-icon control, used across
/// list-type fields.
class AddItemLink extends StatelessWidget {
  const AddItemLink({required this.label, required this.onTap, super.key});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add, size: 18, color: AppColors.teal),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
