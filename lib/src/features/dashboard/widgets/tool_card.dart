import 'package:flutter/material.dart';

import '../../../components/primary_button.dart';
import '../../../components/section_card.dart';
import '../../../components/tool_icon_badge.dart';
import '../../../models/tool_definition.dart';
import '../../../theme/app_colors.dart';

/// Feature-specific composite widget (not "pure" — takes a domain model,
/// `ToolDefinition`), ported from the tool card markup in
/// `design-reference/app/pages/index.vue`.
class ToolCard extends StatelessWidget {
  const ToolCard({required this.tool, required this.onStartNew, super.key});

  final ToolDefinition tool;
  final VoidCallback onStartNew;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ToolIconBadge(icon: tool.icon, colour: tool.colour),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tool.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tool.tagline,
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Text(
              tool.description,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              label: 'Start new',
              leadingIcon: Icons.add,
              onPressed: onStartNew,
            ),
          ),
        ],
      ),
    );
  }
}
