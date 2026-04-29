import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// โลโก้ของแอป — ใช้ gradient + icon แทน placeholder เดิม
/// (Phase UI-1+ จะเปลี่ยนเป็น asset SVG เมื่อมี logo จริง)
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.showSubtitle = true,
    this.size = 96,
  });

  final bool showSubtitle;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary500, AppColors.primary700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: AppRadius.all(AppRadius.lg + 4),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary500.withValues(alpha: 0.3),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.air,
            size: size * 0.5,
            color: Colors.white,
          ),
        ),
        if (showSubtitle) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            AppConstants.appName,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
