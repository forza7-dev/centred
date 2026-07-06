import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../components/empty_state.dart';
import '../../components/primary_button.dart';
import '../../components/progress_step_bar.dart';
import '../../components/secondary_button.dart';
import '../../components/section_card.dart';
import '../../providers/saved_entries_provider.dart';
import '../../providers/tool_catalog_provider.dart';
import '../../theme/app_colors.dart';
import 'fill_wizard_provider.dart';
import 'widgets/field_renderer.dart';

/// Step wizard, ported from `design-reference/app/pages/fill/[id].vue`.
class FillWizardPage extends ConsumerStatefulWidget {
  const FillWizardPage({required this.entryId, this.initialStep, super.key});

  final String entryId;

  /// Ports the prototype's `?step=last` query param, used by "Back to
  /// amend" to jump straight to the final step. Either `'last'` or a step
  /// index as a string.
  final String? initialStep;

  @override
  ConsumerState<FillWizardPage> createState() => _FillWizardPageState();
}

class _FillWizardPageState extends ConsumerState<FillWizardPage> {
  @override
  void initState() {
    super.initState();
    final initialStep = widget.initialStep;
    if (initialStep == null) return;
    final notifier = ref.read(fillWizardProvider(widget.entryId).notifier);
    if (initialStep == 'last') {
      notifier.jumpToStep(notifier.totalSteps - 1);
    } else {
      final index = int.tryParse(initialStep);
      if (index != null) notifier.jumpToStep(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final entryId = widget.entryId;
    final entry = ref.watch(savedEntryProvider(entryId));
    if (entry == null) {
      return Scaffold(
        body: EmptyState(
          icon: Icons.search_off,
          message: 'This entry could not be found.',
          actionLabel: 'Back to tools',
          onAction: () => context.goNamed('dashboard'),
        ),
      );
    }

    final tool = ref.watch(toolByIdProvider(entry.toolId));
    if (tool == null) {
      return Scaffold(
        body: EmptyState(
          icon: Icons.error_outline,
          message: 'This tool is no longer available.',
          actionLabel: 'Back to tools',
          onAction: () => context.goNamed('dashboard'),
        ),
      );
    }

    final wizard = ref.watch(fillWizardProvider(entryId));
    final notifier = ref.read(fillWizardProvider(entryId).notifier);
    final step = tool.steps[wizard.currentStepIndex];
    final isLastStep = wizard.currentStepIndex == tool.steps.length - 1;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () => context.goNamed('dashboard'),
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: const Text('Back to tools'),
                  style: TextButton.styleFrom(foregroundColor: AppColors.textMuted),
                ),
                const SizedBox(height: 8),
                Text(tool.name, style: Theme.of(context).textTheme.headlineMedium),
                Text(tool.tagline, style: const TextStyle(color: AppColors.textMuted)),
                const SizedBox(height: 24),
                ProgressStepBar(currentStep: wizard.currentStepIndex, totalSteps: tool.steps.length),
                const SizedBox(height: 24),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(step.title, style: Theme.of(context).textTheme.titleLarge),
                      if (step.description != null) ...[
                        const SizedBox(height: 4),
                        Text(step.description!, style: const TextStyle(color: AppColors.textMuted)),
                      ],
                      const SizedBox(height: 24),
                      for (final field in step.fields)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                field.label,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(height: 8),
                              FieldRenderer(entryId: entryId, field: field),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (wizard.currentStepIndex > 0)
                      SecondaryButton(
                        label: 'Back',
                        leadingIcon: Icons.arrow_back,
                        onPressed: notifier.prevStep,
                      )
                    else
                      const SizedBox.shrink(),
                    PrimaryButton(
                      label: isLastStep ? 'Generate' : 'Next',
                      leadingIcon: isLastStep ? Icons.check_circle_outline : Icons.arrow_forward,
                      onPressed: () {
                        if (isLastStep) {
                          notifier.saveCurrentStep();
                          context.goNamed('document', pathParameters: {'entryId': entryId});
                        } else {
                          notifier.nextStep();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
