import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

enum StatusVariant { success, warning, danger, neutral, info }

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    this.variant = StatusVariant.neutral,
    this.dot = true,
    this.icon,
  });

  final String label;
  final StatusVariant variant;
  final bool dot;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = _colors(variant);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs + 1,
      ),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: AppRadius.all(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: colors.fg),
            const SizedBox(width: AppSpacing.xs + 2),
          ] else if (dot) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: colors.fg,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.xs + 2),
          ],
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: colors.fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  _BadgeColors _colors(StatusVariant v) {
    switch (v) {
      case StatusVariant.success:
        return const _BadgeColors(
          bg: AppColors.success100,
          fg: AppColors.success700,
        );
      case StatusVariant.warning:
        return const _BadgeColors(
          bg: AppColors.warning50,
          fg: AppColors.warning700,
        );
      case StatusVariant.danger:
        return const _BadgeColors(
          bg: AppColors.danger50,
          fg: AppColors.danger700,
        );
      case StatusVariant.info:
        return const _BadgeColors(
          bg: AppColors.info50,
          fg: AppColors.info700,
        );
      case StatusVariant.neutral:
        return const _BadgeColors(
          bg: AppColors.neutral100,
          fg: AppColors.neutral600,
        );
    }
  }
}

class _BadgeColors {
  const _BadgeColors({required this.bg, required this.fg});
  final Color bg;
  final Color fg;
}
