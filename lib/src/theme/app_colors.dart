import 'package:flutter/material.dart';

/// Centred brand palette, ported from `design-reference/tailwind.config.ts`.
abstract final class AppColors {
  static const Color teal = Color(0xFF72B9CF);
  static const Color coral = Color(0xFFCF8872);
  static const Color navy = Color(0xFF161F38);
  static const Color sand = Color(0xFFFAF6F0);

  static const Color scaffoldBackground = Colors.white;
  static const Color cardBorder = Color(0x1A161F38); // navy at 10% opacity
  static const Color textPrimary = navy;
  static const Color textMuted = Color(0xFF515F84); // navy-300

  /// Document personalisation backgrounds (`bgOptions` in the prototype).
  static const Color bgWhite = Colors.white;
  static const Color bgSand = sand;
  static const Color bgSky = Color(0xFFEFF8FA);
  static const Color bgBlush = Color(0xFFFAF3F0);
  static const Color bgLavender = Color(0xFFF0EFF8);

  /// Document personalisation accents (`accentOptions` in the prototype).
  static const Color accentTeal = teal;
  static const Color accentCoral = coral;
  static const Color accentNavy = navy;
  static const Color accentForest = Color(0xFF6B9E7D);
  static const Color accentPurple = Color(0xFF8B7EC4);
}
