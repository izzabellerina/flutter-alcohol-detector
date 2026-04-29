import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/date_formatter.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.greetingName,
    this.licenseNumber,
    this.deviceId,
    this.dateTime,
    this.title = 'เริ่มการทดสอบ',
  });

  final String greetingName;
  final String? licenseNumber;
  final String? deviceId;
  final DateTime? dateTime;
  final String title;

  @override
  Widget build(BuildContext context) {
    final now = dateTime ?? DateTime.now();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.info700, AppColors.info900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.headingSmall.copyWith(
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: AppRadius.all(AppRadius.pill),
                    ),
                    child: Icon(
                      Icons.power_settings_new,
                      color: AppColors.textOnPrimary.withValues(alpha: 0.9),
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.xl),
                  topRight: Radius.circular(AppRadius.xl),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.primary500,
                              AppColors.primary700,
                            ],
                          ),
                          borderRadius: AppRadius.all(AppRadius.md),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _initials(greetingName),
                          style: AppTextStyles.headingSmall.copyWith(
                            color: AppColors.textOnPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormatter.formatThaiDateTime(now),
                              style: AppTextStyles.bodySmall,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'สวัสดี $greetingName',
                              style: AppTextStyles.headingMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (licenseNumber != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    _Chip(
                      icon: Icons.badge_outlined,
                      label: 'ใบขับขี่ $licenseNumber',
                    ),
                  ],
                  if (deviceId != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    _Chip(
                      icon: Icons.bluetooth_connected,
                      label: 'Device: $deviceId',
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.take(1).toString();
    return '${parts.first.characters.take(1)}${parts.last.characters.take(1)}'
        .toUpperCase();
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: AppRadius.all(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.xs + 2),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
