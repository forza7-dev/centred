import 'package:flutter/widgets.dart';

import 'tool_step.dart';

enum ToolCategory { micro, macro }

enum ToolAccentColour { teal, coral, navy }

class ToolDefinition {
  const ToolDefinition({
    required this.id,
    required this.name,
    required this.category,
    required this.tagline,
    required this.description,
    required this.icon,
    required this.colour,
    required this.steps,
  });

  final String id;
  final String name;
  final ToolCategory category;
  final String tagline;
  final String description;
  final IconData icon;
  final ToolAccentColour colour;
  final List<ToolStep> steps;
}
