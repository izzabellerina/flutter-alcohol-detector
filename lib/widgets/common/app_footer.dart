import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/date_formatter.dart';
import '../../services/app_info.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key, this.versionOverride, this.updatedAtOverride});

  /// ใช้สำหรับทดสอบ — ปกติจะอ่านจาก [AppInfo] ใน Provider
  final String? versionOverride;
  final DateTime? updatedAtOverride;

  @override
  Widget build(BuildContext context) {
    final appInfo = versionOverride == null || updatedAtOverride == null
        ? context.watch<AppInfo>()
        : null;

    final version = versionOverride ?? appInfo!.displayVersion;
    final updatedAt = updatedAtOverride ?? appInfo!.versionUpdatedAt;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Version $version',
            style: AppTextStyles.version,
          ),
          const SizedBox(height: 2),
          Text(
            'อัปเดตเมื่อ ${DateFormatter.formatThaiDateTime(updatedAt)}',
            style: AppTextStyles.version.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
