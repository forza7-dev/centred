import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text.dart';

/// Single, light-only app theme — the prototype has no dark mode.
abstract final class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.scaffoldBackground,
        colorScheme: const ColorScheme.light(
          primary: AppColors.teal,
          secondary: AppColors.coral,
          surface: AppColors.scaffoldBackground,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
        ),
        textTheme: AppText.textTheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.scaffoldBackground,
          foregroundColor: AppColors.navy,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.cardBorder),
          ),
        ),
        dividerTheme: const DividerThemeData(color: AppColors.cardBorder),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.sand,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.teal,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      );
}
