import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

enum PasswordStrength {
  empty,
  weak,
  medium,
  strong,
  veryStrong,
}

class PasswordStrengthMeter extends StatelessWidget {
  const PasswordStrengthMeter({super.key, required this.password});

  final String password;

  static PasswordStrength evaluate(String password) {
    if (password.isEmpty) return PasswordStrength.empty;

    var score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=]').hasMatch(password)) score++;

    if (score <= 1) return PasswordStrength.weak;
    if (score == 2) return PasswordStrength.medium;
    if (score == 3) return PasswordStrength.strong;
    return PasswordStrength.veryStrong;
  }

  @override
  Widget build(BuildContext context) {
    final strength = evaluate(password);

    final config = _config(strength);
    final filledSegments = config.filledSegments;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (index) {
            final isFilled = index < filledSegments;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: index == 3 ? 0 : AppSpacing.xs,
                ),
                height: 4,
                decoration: BoxDecoration(
                  color: isFilled ? config.color : AppColors.neutral200,
                  borderRadius: AppRadius.all(AppRadius.pill),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: AppSpacing.xs + 2),
        Text(
          config.label,
          style: AppTextStyles.bodySmall.copyWith(
            color: config.color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  _Config _config(PasswordStrength s) {
    switch (s) {
      case PasswordStrength.empty:
        return const _Config(
          color: AppColors.neutral400,
          label: 'กรอกรหัสผ่านใหม่',
          filledSegments: 0,
        );
      case PasswordStrength.weak:
        return const _Config(
          color: AppColors.danger500,
          label: 'อ่อน — แนะนำให้เพิ่มความยาวและตัวพิเศษ',
          filledSegments: 1,
        );
      case PasswordStrength.medium:
        return const _Config(
          color: AppColors.warning500,
          label: 'พอใช้',
          filledSegments: 2,
        );
      case PasswordStrength.strong:
        return const _Config(
          color: AppColors.primary500,
          label: 'แข็งแรง',
          filledSegments: 3,
        );
      case PasswordStrength.veryStrong:
        return const _Config(
          color: AppColors.primary700,
          label: 'แข็งแรงมาก',
          filledSegments: 4,
        );
    }
  }
}

class _Config {
  const _Config({
    required this.color,
    required this.label,
    required this.filledSegments,
  });

  final Color color;
  final String label;
  final int filledSegments;
}
