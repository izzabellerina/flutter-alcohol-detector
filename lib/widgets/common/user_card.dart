import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/date_formatter.dart';

/// การ์ดข้อมูลผู้ใช้ — avatar + greeting + divider + info rows (ไอคอนน้ำเงินซ้าย)
/// อ้างอิงจาก Design Update 2026-04-30
class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.greetingName,
    this.dateTime,
    this.licenseNumber,
    this.deviceId,
  });

  final String greetingName;
  final DateTime? dateTime;
  final String? licenseNumber;
  final String? deviceId;

  @override
  Widget build(BuildContext context) {
    final now = dateTime ?? DateTime.now();
    final hasInfo = licenseNumber != null || deviceId != null;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary100,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.person,
                  size: 32,
                  color: AppColors.primary600,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'สวัสดี $greetingName',
                  style: AppTextStyles.headingLarge,
                ),
              ),
            ],
          ),
          if (hasInfo) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Divider(height: 1, color: AppColors.divider),
            ),
            _InfoRow(
              icon: Icons.calendar_today_outlined,
              text: DateFormatter.formatThaiDateTime(now),
            ),
            if (licenseNumber != null) ...[
              const SizedBox(height: AppSpacing.sm + 2),
              _InfoRow(
                icon: Icons.badge_outlined,
                text: 'หมายเลขใบขับขี่ $licenseNumber',
              ),
            ],
            if (deviceId != null) ...[
              const SizedBox(height: AppSpacing.sm + 2),
              _InfoRow(
                icon: Icons.bluetooth_connected,
                text: 'Device: $deviceId',
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primary50,
            borderRadius: AppRadius.all(AppRadius.sm),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 16, color: AppColors.primary600),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
