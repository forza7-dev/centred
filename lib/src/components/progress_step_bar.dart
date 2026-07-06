import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Pure "Step N of M" label + animated fill bar.
class ProgressStepBar extends StatelessWidget {
  const ProgressStepBar({
    required this.currentStep,
    required this.totalSteps,
    super.key,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final fraction = totalSteps == 0 ? 0.0 : (currentStep + 1) / totalSteps;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step ${currentStep + 1} of $totalSteps',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: fraction),
            duration: const Duration(milliseconds: 250),
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 8,
              backgroundColor: AppColors.navy.withValues(alpha: 0.05),
              valueColor: const AlwaysStoppedAnimation(AppColors.teal),
            ),
          ),
        ),
      ],
    );
  }
}
