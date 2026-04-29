import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// แสดงขั้นตอน "ขั้นตอนที่ X จาก Y" + แถบสีบ่งชี้
class AuthStepIndicator extends StatelessWidget {
  const AuthStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.label,
  });

  final int currentStep;
  final int totalSteps;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            final isCompleted = index < currentStep - 1;
            final isCurrent = index == currentStep - 1;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: index == totalSteps - 1 ? 0 : AppSpacing.xs + 2,
                ),
                height: 6,
                decoration: BoxDecoration(
                  color: isCompleted || isCurrent
                      ? AppColors.primary500
                      : AppColors.neutral200,
                  borderRadius: AppRadius.all(AppRadius.pill),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ขั้นตอนที่ $currentStep จาก $totalSteps',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary700,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (label != null)
              Text(
                label!,
                style: AppTextStyles.bodySmall,
              ),
          ],
        ),
      ],
    );
  }
}
