import 'package:flutter/material.dart';

import '../../../components/personalise_swatch.dart';
import '../../../models/personalisation_settings.dart';
import '../../../theme/app_colors.dart';

/// Font / background / accent picker, ported from the "Personalise" panel
/// in `design-reference/app/pages/view/[id].vue`.
class PersonalisePanel extends StatelessWidget {
  const PersonalisePanel({
    required this.settings,
    required this.onFontChanged,
    required this.onBackgroundChanged,
    required this.onAccentChanged,
    super.key,
  });

  final PersonalisationSettings settings;
  final ValueChanged<DocumentFont> onFontChanged;
  final ValueChanged<DocumentBackground> onBackgroundChanged;
  final ValueChanged<DocumentAccent> onAccentChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Personalise', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          const Text('Font', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            children: [
              for (final font in DocumentFont.values)
                PersonaliseSwatch(
                  label: font.label,
                  selected: settings.font == font,
                  onTap: () => onFontChanged(font),
                  child: Text('Aa', style: font.textStyle.copyWith(fontSize: 16, color: AppColors.navy)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Background', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            children: [
              for (final bg in DocumentBackground.values)
                PersonaliseSwatch(
                  label: bg.label,
                  colour: bg.colour,
                  selected: settings.background == bg,
                  onTap: () => onBackgroundChanged(bg),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Accent colour', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            children: [
              for (final accent in DocumentAccent.values)
                PersonaliseSwatch(
                  label: accent.label,
                  colour: accent.colour,
                  selected: settings.accent == accent,
                  onTap: () => onAccentChanged(accent),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
