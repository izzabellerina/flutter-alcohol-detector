import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import 'status_badge.dart';

/// การ์ดแสดงอุปกรณ์ที่เชื่อมต่ออยู่ — ตามดีไซน์: icon + label + ID + status pill
class ConnectedDeviceCard extends StatelessWidget {
  const ConnectedDeviceCard({
    super.key,
    required this.deviceId,
    this.label = 'อุปกรณ์ที่เชื่อมต่อ',
    this.icon = Icons.bluetooth,
    this.connected = true,
  });

  final String deviceId;
  final String label;
  final IconData icon;
  final bool connected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.all(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral900.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.primary500,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 22,
              color: AppColors.textOnPrimary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  deviceId,
                  style: AppTextStyles.headingSmall.copyWith(
                    color: connected
                        ? AppColors.success600
                        : AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          StatusBadge(
            label: connected ? 'เชื่อมต่อแล้ว' : 'ไม่เชื่อมต่อ',
            variant: connected ? StatusVariant.success : StatusVariant.neutral,
          ),
        ],
      ),
    );
  }
}
