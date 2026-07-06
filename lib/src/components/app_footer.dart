import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Static "Built by Forza7" footer, ported from
/// `design-reference/app/layouts/default.vue`.
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        'Built by Forza7',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textMuted),
      ),
    );
  }
}
