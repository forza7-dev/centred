import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Pure selectable swatch tile — used for the document personalisation
/// backgrounds, accents, and fonts pickers. Pass [colour] for a plain colour
/// circle (backgrounds/accents), or a custom [child] for a richer preview
/// (e.g. font pickers showing sample text in that font).
class PersonaliseSwatch extends StatelessWidget {
  const PersonaliseSwatch({
    required this.label,
    required this.selected,
    required this.onTap,
    this.colour,
    this.child,
    super.key,
  }) : assert(colour != null || child != null, 'Provide colour or child');

  final Color? colour;
  final Widget? child;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final content = child ??
        (selected
            ? Icon(
                Icons.check,
                size: 16,
                color: ThemeData.estimateBrightnessForColor(colour!) == Brightness.dark
                    ? Colors.white
                    : AppColors.navy,
              )
            : null);

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colour,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppColors.navy : Colors.transparent,
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: content,
          ),
        ),
      ),
    );
  }
}
