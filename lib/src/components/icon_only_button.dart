import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Pure, tappable icon button with a mandatory tooltip (semantic label)
/// and a minimum 48x48dp tap target, per the org accessibility rules.
class IconOnlyButton extends StatelessWidget {
  const IconOnlyButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.colour = AppColors.navy,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 48,
        height: 48,
        child: IconButton(
          icon: Icon(icon, color: colour),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
