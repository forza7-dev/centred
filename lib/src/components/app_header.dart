import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Static app-chrome header — teal mark + "centred" wordmark + tagline,
/// ported from `design-reference/app/layouts/default.vue`.
class AppHeader extends StatelessWidget {
  const AppHeader({this.leading, super.key});

  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 12)],
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.teal,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.spa_outlined, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.titleLarge,
                  children: const [
                    TextSpan(text: 'cen'),
                    TextSpan(text: 't', style: TextStyle(color: AppColors.teal)),
                    TextSpan(text: 'red'),
                  ],
                ),
              ),
              Text(
                'Person-Centred Planning',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
