import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// Document personalisation, ported from the prototype's `fontOptions` /
/// `bgOptions` / `accentOptions` in `pages/view/[id].vue`. Scoped to the
/// generated document view only — never touches the global `ThemeData`.
enum DocumentFont { clean, elegant, handwritten } // DM Sans / Marcellus / Caveat

extension DocumentFontStyle on DocumentFont {
  TextStyle get textStyle => switch (this) {
        DocumentFont.clean => AppText.documentClean,
        DocumentFont.elegant => AppText.documentElegant,
        DocumentFont.handwritten => AppText.documentHandwritten,
      };

  String get label => switch (this) {
        DocumentFont.clean => 'Clean',
        DocumentFont.elegant => 'Elegant',
        DocumentFont.handwritten => 'Handwritten',
      };
}

enum DocumentBackground { white, sand, sky, blush, lavender }

extension DocumentBackgroundColour on DocumentBackground {
  Color get colour => switch (this) {
        DocumentBackground.white => AppColors.bgWhite,
        DocumentBackground.sand => AppColors.bgSand,
        DocumentBackground.sky => AppColors.bgSky,
        DocumentBackground.blush => AppColors.bgBlush,
        DocumentBackground.lavender => AppColors.bgLavender,
      };

  String get label => switch (this) {
        DocumentBackground.white => 'White',
        DocumentBackground.sand => 'Sand',
        DocumentBackground.sky => 'Sky',
        DocumentBackground.blush => 'Blush',
        DocumentBackground.lavender => 'Lavender',
      };
}

enum DocumentAccent { teal, coral, navy, forest, purple }

extension DocumentAccentColour on DocumentAccent {
  Color get colour => switch (this) {
        DocumentAccent.teal => AppColors.accentTeal,
        DocumentAccent.coral => AppColors.accentCoral,
        DocumentAccent.navy => AppColors.accentNavy,
        DocumentAccent.forest => AppColors.accentForest,
        DocumentAccent.purple => AppColors.accentPurple,
      };

  String get label => switch (this) {
        DocumentAccent.teal => 'Teal',
        DocumentAccent.coral => 'Coral',
        DocumentAccent.navy => 'Navy',
        DocumentAccent.forest => 'Forest',
        DocumentAccent.purple => 'Purple',
      };
}

class PersonalisationSettings {
  const PersonalisationSettings({
    this.font = DocumentFont.clean,
    this.background = DocumentBackground.white,
    this.accent = DocumentAccent.teal,
  });

  final DocumentFont font;
  final DocumentBackground background;
  final DocumentAccent accent;

  PersonalisationSettings copyWith({
    DocumentFont? font,
    DocumentBackground? background,
    DocumentAccent? accent,
  }) =>
      PersonalisationSettings(
        font: font ?? this.font,
        background: background ?? this.background,
        accent: accent ?? this.accent,
      );
}
