import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
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
      decoration: const BoxDecoration(color: AppColors.headerBar),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
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
                  Icon(
                    Icons.power_settings_new,
                    color: AppColors.textOnPrimary.withValues(alpha: 0.9),
                    size: 22,
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(color: AppColors.background),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormatter.formatThaiDateTime(now),
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'สวัสดี $greetingName',
                    style: AppTextStyles.headingMedium,
                  ),
                  if (licenseNumber != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'หมายเลขใบขับขี่ $licenseNumber',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  if (deviceId != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Device: $deviceId',
                      style: AppTextStyles.caption,
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
}
