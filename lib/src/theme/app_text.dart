import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// App-chrome text theme, ported from `design-reference/tailwind.config.ts`
/// (`font-heading` -> Quicksand, `font-content` -> DM Sans). Document
/// personalisation fonts (Marcellus, Caveat) are applied separately, only
/// inside the generated document view — see `PersonalisationSettings`.
abstract final class AppText {
  static TextTheme get textTheme {
    final base = GoogleFonts.dmSansTextTheme().apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    );
    final heading = GoogleFonts.quicksandTextTheme();

    return base.copyWith(
      displayLarge: heading.displayLarge,
      displayMedium: heading.displayMedium,
      displaySmall: heading.displaySmall,
      headlineLarge: heading.headlineLarge,
      headlineMedium: heading.headlineMedium,
      headlineSmall: heading.headlineSmall,
      titleLarge: heading.titleLarge,
      titleMedium: heading.titleMedium,
      titleSmall: heading.titleSmall,
    );
  }

  static TextStyle get documentClean => GoogleFonts.dmSans();
  static TextStyle get documentElegant => GoogleFonts.marcellus();
  static TextStyle get documentHandwritten => GoogleFonts.caveat();
}
