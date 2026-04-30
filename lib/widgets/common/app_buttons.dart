import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

enum AppButtonVariant {
  primary,
  danger,
  secondary,
  outline,
  outlinePrimary,
  outlineDanger,
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
    this.showChevron = false,
  });

  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
    this.showChevron = false,
  }) : variant = AppButtonVariant.primary;

  const AppButton.danger({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
    this.showChevron = false,
  }) : variant = AppButtonVariant.danger;

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
    this.showChevron = false,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.outline({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
    this.showChevron = false,
  }) : variant = AppButtonVariant.outline;

  const AppButton.outlinePrimary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
    this.showChevron = false,
  }) : variant = AppButtonVariant.outlinePrimary;

  const AppButton.outlineDanger({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
    this.showChevron = false,
  }) : variant = AppButtonVariant.outlineDanger;

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final bool showChevron;

  Color get _backgroundColor {
    switch (variant) {
      case AppButtonVariant.primary:
        return AppColors.primary;
      case AppButtonVariant.danger:
        return AppColors.danger;
      case AppButtonVariant.secondary:
        return AppColors.secondary;
      case AppButtonVariant.outline:
      case AppButtonVariant.outlinePrimary:
      case AppButtonVariant.outlineDanger:
        return AppColors.background;
    }
  }

  Color get _foregroundColor {
    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.danger:
      case AppButtonVariant.secondary:
        return AppColors.textOnPrimary;
      case AppButtonVariant.outline:
        return AppColors.textPrimary;
      case AppButtonVariant.outlinePrimary:
        return AppColors.primary600;
      case AppButtonVariant.outlineDanger:
        return AppColors.danger600;
    }
  }

  BorderSide get _borderSide {
    switch (variant) {
      case AppButtonVariant.outline:
        return const BorderSide(color: AppColors.border);
      case AppButtonVariant.outlinePrimary:
        return const BorderSide(color: AppColors.primary500, width: 1.5);
      case AppButtonVariant.outlineDanger:
        return const BorderSide(color: AppColors.danger500, width: 1.5);
      case AppButtonVariant.primary:
      case AppButtonVariant.danger:
      case AppButtonVariant.secondary:
        return BorderSide.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null || isLoading;

    final button = ElevatedButton(
      onPressed: disabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _backgroundColor,
        foregroundColor: _foregroundColor,
        disabledBackgroundColor: _backgroundColor.withValues(alpha: 0.5),
        disabledForegroundColor: _foregroundColor.withValues(alpha: 0.7),
        elevation: 0,
        minimumSize: const Size.fromHeight(52),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.all(AppRadius.md),
          side: _borderSide,
        ),
        textStyle: AppTextStyles.button.copyWith(color: _foregroundColor),
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: _foregroundColor,
              ),
            )
          : showChevron
              ? _ChevronLayout(
                  label: label,
                  icon: icon,
                  foregroundColor: _foregroundColor,
                )
              : _CompactLayout(label: label, icon: icon),
    );

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// icon ซ้าย + label กลาง + chevron ขวา (ตาม Design Update 2026-04-30)
class _ChevronLayout extends StatelessWidget {
  const _ChevronLayout({
    required this.label,
    required this.icon,
    required this.foregroundColor,
  });

  final String label;
  final IconData? icon;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          child: icon == null
              ? null
              : Icon(icon, size: 20, color: foregroundColor),
        ),
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.button.copyWith(color: foregroundColor),
          ),
        ),
        Icon(Icons.chevron_right, size: 22, color: foregroundColor),
      ],
    );
  }
}

/// icon + label ติดกันตรงกลาง (รูปแบบเดิม)
class _CompactLayout extends StatelessWidget {
  const _CompactLayout({required this.label, required this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(label),
      ],
    );
  }
}
