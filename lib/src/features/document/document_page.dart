import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../components/empty_state.dart';
import '../../components/icon_only_button.dart';
import '../../components/secondary_button.dart';
import '../../providers/saved_entries_provider.dart';
import '../../providers/tool_catalog_provider.dart';
import '../../theme/app_colors.dart';
import 'document_provider.dart';
import 'layouts/about_me_layout.dart';
import 'layouts/best_worst_day_layout.dart';
import 'layouts/generic_layout.dart';
import 'layouts/how_i_communicate_layout.dart';
import 'layouts/my_direction_layout.dart';
import 'layouts/my_people_layout.dart';
import 'layouts/my_perfect_week_layout.dart';
import 'layouts/my_story_layout.dart';
import 'layouts/whats_working_layout.dart';
import 'layouts/what_matters_layout.dart';
import 'widgets/export_pdf_button.dart';
import 'widgets/personalise_panel.dart';

/// Generated document view, ported from
/// `design-reference/app/pages/view/[id].vue`: bespoke per-tool layout,
/// personalisation panel, export/delete/back-to-amend actions.
class DocumentPage extends ConsumerWidget {
  DocumentPage({required this.entryId, super.key});

  final String entryId;
  final GlobalKey _repaintKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    final personalisation = ref.watch(personalisationProvider(entryId));
    final personalisationNotifier = ref.read(personalisationProvider(entryId).notifier);

    final Widget layout = switch (entry.toolId) {
      'about-me' => AboutMeLayout(entry: entry, personalisation: personalisation),
      'what-matters' => WhatMattersLayout(entry: entry, personalisation: personalisation),
      'my-people' => MyPeopleLayout(entry: entry, personalisation: personalisation),
      'best-worst-day' => BestWorstDayLayout(entry: entry, personalisation: personalisation),
      'whats-working' => WhatsWorkingLayout(entry: entry, personalisation: personalisation),
      'how-i-communicate' => HowICommunicateLayout(entry: entry, personalisation: personalisation),
      'my-perfect-week' => MyPerfectWeekLayout(entry: entry, personalisation: personalisation),
      'my-direction' => MyDirectionLayout(entry: entry, personalisation: personalisation),
      'my-story' => MyStoryLayout(entry: entry, personalisation: personalisation),
      _ => GenericLayout(entry: entry, tool: tool, personalisation: personalisation),
    };

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () => context.goNamed('dashboard'),
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: const Text('Back to tools'),
                      style: TextButton.styleFrom(foregroundColor: AppColors.textMuted),
                    ),
                    Row(
                      children: [
                        SecondaryButton(
                          label: 'Back to amend',
                          leadingIcon: Icons.edit_outlined,
                          onPressed: () => context.goNamed(
                            'fillWizard',
                            pathParameters: {'entryId': entryId},
                            queryParameters: const {'step': 'last'},
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconOnlyButton(
                          icon: Icons.delete_outline,
                          tooltip: 'Delete entry',
                          colour: AppColors.coral,
                          onPressed: () {
                            ref.read(savedEntriesProvider.notifier).deleteEntry(entryId);
                            context.goNamed('dashboard');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                RepaintBoundary(key: _repaintKey, child: layout),
                const SizedBox(height: 20),
                PersonalisePanel(
                  settings: personalisation,
                  onFontChanged: personalisationNotifier.setFont,
                  onBackgroundChanged: personalisationNotifier.setBackground,
                  onAccentChanged: personalisationNotifier.setAccent,
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: ExportPdfButton(
                    entryId: entryId,
                    toolId: entry.toolId,
                    filename: '${tool?.name ?? entry.toolId} - ${entry.label}.pdf',
                    repaintBoundaryKey: _repaintKey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
