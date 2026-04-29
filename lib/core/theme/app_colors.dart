import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Primary (Green) ──────────────────────────────────────────
  static const Color primary50 = Color(0xFFEFFDF4);
  static const Color primary100 = Color(0xFFD1FADF);
  static const Color primary200 = Color(0xFFA7F3C5);
  static const Color primary500 = Color(0xFF22C55E);
  static const Color primary600 = Color(0xFF16A34A);
  static const Color primary700 = Color(0xFF15803D);
  static const Color primary900 = Color(0xFF14532D);

  // ── Danger (Red) ─────────────────────────────────────────────
  static const Color danger50 = Color(0xFFFEF2F2);
  static const Color danger100 = Color(0xFFFEE2E2);
  static const Color danger500 = Color(0xFFEF4444);
  static const Color danger600 = Color(0xFFDC2626);
  static const Color danger700 = Color(0xFFB91C1C);

  // ── Info (Blue) — Header bar ─────────────────────────────────
  static const Color info50 = Color(0xFFEFF6FF);
  static const Color info100 = Color(0xFFDBEAFE);
  static const Color info500 = Color(0xFF3B82F6);
  static const Color info600 = Color(0xFF2563EB);
  static const Color info700 = Color(0xFF1D4ED8);
  static const Color info800 = Color(0xFF1E40AF);
  static const Color info900 = Color(0xFF1E3A8A);

  // ── Warning (Amber) ──────────────────────────────────────────
  static const Color warning50 = Color(0xFFFFFBEB);
  static const Color warning500 = Color(0xFFF59E0B);
  static const Color warning700 = Color(0xFFB45309);

  // ── Neutral (Gray) ───────────────────────────────────────────
  static const Color neutral0 = Color(0xFFFFFFFF);
  static const Color neutral50 = Color(0xFFF9FAFB);
  static const Color neutral100 = Color(0xFFF3F4F6);
  static const Color neutral200 = Color(0xFFE5E7EB);
  static const Color neutral300 = Color(0xFFD1D5DB);
  static const Color neutral400 = Color(0xFF9CA3AF);
  static const Color neutral500 = Color(0xFF6B7280);
  static const Color neutral600 = Color(0xFF4B5563);
  static const Color neutral700 = Color(0xFF374151);
  static const Color neutral800 = Color(0xFF1F2937);
  static const Color neutral900 = Color(0xFF111827);
  static const Color neutral950 = Color(0xFF030712);

  // ── Aliases (เก็บไว้ให้ backward-compat กับโค้ดเดิม) ──────────
  static const Color primary = primary500;
  static const Color primaryDark = primary700;

  static const Color danger = danger500;
  static const Color dangerDark = danger600;

  static const Color secondary = neutral500;
  static const Color secondaryDark = neutral600;

  static const Color headerBar = info800;
  static const Color headerBarDark = info900;

  static const Color background = neutral0;
  static const Color surface = neutral50;
  static const Color surfaceVariant = neutral100;

  static const Color textPrimary = neutral900;
  static const Color textSecondary = neutral500;
  static const Color textOnPrimary = neutral0;
  static const Color textMuted = neutral400;

  static const Color border = neutral200;
  static const Color divider = neutral200;

  static const Color success = primary500;
  static const Color warning = warning500;
  static const Color error = danger500;

  static const Color resultPass = primary500;
  static const Color resultFail = danger500;

  // ── Dark mode tokens ─────────────────────────────────────────
  static const Color darkBackground = neutral950;
  static const Color darkSurface = neutral900;
  static const Color darkSurfaceVariant = neutral800;
  static const Color darkBorder = neutral700;
  static const Color darkTextPrimary = neutral50;
  static const Color darkTextSecondary = neutral400;
  static const Color darkTextMuted = neutral500;
}
