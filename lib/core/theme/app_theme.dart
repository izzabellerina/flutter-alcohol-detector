import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  // ── Light theme ──────────────────────────────────────────────
  static ThemeData get light => _build(
        brightness: Brightness.light,
        scaffoldBackground: AppColors.background,
        surface: AppColors.surface,
        surfaceVariant: AppColors.surfaceVariant,
        onSurface: AppColors.textPrimary,
        border: AppColors.border,
      );

  // ── Dark theme ───────────────────────────────────────────────
  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        scaffoldBackground: AppColors.darkBackground,
        surface: AppColors.darkSurface,
        surfaceVariant: AppColors.darkSurfaceVariant,
        onSurface: AppColors.darkTextPrimary,
        border: AppColors.darkBorder,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color scaffoldBackground,
    required Color surface,
    required Color surfaceVariant,
    required Color onSurface,
    required Color border,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: scaffoldBackground,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textOnPrimary,
        error: AppColors.error,
        onError: AppColors.textOnPrimary,
        surface: surface,
        onSurface: onSurface,
        surfaceContainerHighest: surfaceVariant,
        outline: border,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.headerBar,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.headingSmall.copyWith(
          color: AppColors.textOnPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.all(AppRadius.md),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md + 2,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.all(AppRadius.md),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.all(AppRadius.md),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.all(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.all(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: border,
        thickness: 1,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        headlineLarge: AppTextStyles.headingLarge,
        headlineMedium: AppTextStyles.headingMedium,
        headlineSmall: AppTextStyles.headingSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.button,
        labelMedium: AppTextStyles.label,
      ),
    );
  }
}
