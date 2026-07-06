import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../components/primary_button.dart';
import '../../theme/app_colors.dart';

/// Static confirmation shown after a successful PDF export, ported
/// verbatim from the `showGdprNotice` block in
/// `design-reference/app/pages/view/[id].vue`.
class GdprConfirmationPage extends StatelessWidget {
  const GdprConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.teal.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_outline, color: AppColors.teal, size: 32),
              ),
              const SizedBox(height: 24),
              Text('PDF downloaded', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              const Text(
                'For your privacy, all data has been deleted from Centred. '
                'Nothing is stored in the app.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Back to tools',
                leadingIcon: Icons.home_outlined,
                onPressed: () => context.goNamed('dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
