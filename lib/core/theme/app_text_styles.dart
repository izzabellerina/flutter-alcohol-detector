import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// ใช้ GoogleFonts.sarabun() — รองรับน้ำหนัก 100-800
/// ครั้งแรกจะดาวน์โหลด font แล้ว cache ไว้ใน device
class AppTextStyles {
  AppTextStyles._();

  static TextStyle _base(
    double size,
    FontWeight weight, {
    Color color = AppColors.textPrimary,
    double? height,
    double letterSpacing = 0,
  }) {
    return GoogleFonts.sarabun(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // ── Display ──────────────────────────────────────────────────
  static TextStyle get displayLarge =>
      _base(40, FontWeight.bold, height: 1.2);
  static TextStyle get displayMedium =>
      _base(32, FontWeight.bold, height: 1.2);

  // ── Heading ──────────────────────────────────────────────────
  static TextStyle get headingLarge =>
      _base(24, FontWeight.bold, height: 1.3);
  static TextStyle get headingMedium =>
      _base(20, FontWeight.w600, height: 1.3);
  static TextStyle get headingSmall =>
      _base(18, FontWeight.w600, height: 1.4);

  // ── Body ─────────────────────────────────────────────────────
  static TextStyle get bodyLarge =>
      _base(16, FontWeight.normal, height: 1.5);
  static TextStyle get bodyMedium =>
      _base(14, FontWeight.normal, height: 1.5);
  static TextStyle get bodySmall => _base(
        12,
        FontWeight.normal,
        height: 1.5,
        color: AppColors.textSecondary,
      );

  // ── Label / Button ───────────────────────────────────────────
  static TextStyle get button => _base(
        16,
        FontWeight.w600,
        color: AppColors.textOnPrimary,
        letterSpacing: 0.2,
      );
  static TextStyle get label =>
      _base(13, FontWeight.w500, height: 1.4);

  // ── Misc ─────────────────────────────────────────────────────
  static TextStyle get caption =>
      _base(12, FontWeight.normal, color: AppColors.textMuted);
  static TextStyle get version =>
      _base(11, FontWeight.normal, color: AppColors.textMuted);

  // ── Result / Measurement ─────────────────────────────────────
  static TextStyle get resultLarge => _base(
        40,
        FontWeight.bold,
        color: AppColors.textOnPrimary,
        letterSpacing: 1,
      );
  static TextStyle get measurement =>
      _base(28, FontWeight.bold, height: 1.1);
}
