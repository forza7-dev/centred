import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../components/app_header.dart';
import '../../providers/saved_entries_provider.dart';
import '../../providers/tool_catalog_provider.dart';
import '../../theme/app_colors.dart';
import 'widgets/tool_card.dart';

/// Dashboard — grid of tool cards, ported from
/// `design-reference/app/pages/index.vue`. The prototype has no saved-
/// entries list: "Start new" always creates a fresh entry and pushes
/// straight into the fill wizard.
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tools = ref.watch(toolCatalogProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: AppHeader()),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your planning tools',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pick a tool, fill in each section, and export a completed '
                      'PDF. For your privacy, nothing is stored in the app.',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 360,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  mainAxisExtent: 320,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final tool = tools[index];
                    return ToolCard(
                      tool: tool,
                      onStartNew: () {
                        final entryId =
                            ref.read(savedEntriesProvider.notifier).createEntry(tool.id);
                        context.goNamed('fillWizard', pathParameters: {'entryId': entryId});
                      },
                    );
                  },
                  childCount: tools.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
