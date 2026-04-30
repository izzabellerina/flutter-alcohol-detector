import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// Header สำหรับหน้าที่แสดงผลลัพธ์/สถานะ — gradient พื้นหลัง + วงกลมไอคอน + title + subtitle
/// ใช้เป็น top section ของ HomeScreen ตาม Design Update 2026-04-30
class SuccessHeader extends StatelessWidget {
  const SuccessHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.check_rounded,
    this.iconColor,
    this.gradient,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final Gradient? gradient;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient ??
            const LinearGradient(
              colors: [AppColors.primary500, AppColors.primary800],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.xl),
          bottomRight: Radius.circular(AppRadius.xl),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IconBubble(icon: icon, iconColor: iconColor),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      title,
                      style: AppTextStyles.headingLarge.copyWith(
                        color: AppColors.textOnPrimary,
                        height: 1.2,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        subtitle!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textOnPrimary.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.sm),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({required this.icon, this.iconColor});

  final IconData icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.background,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary900.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: 40,
        color: iconColor ?? AppColors.success500,
      ),
    );
  }
}

/// Bluetooth indicator มุมขวา (ตามใน design) — วงกลมน้ำเงินอ่อน + icon + check badge
class BluetoothStatusIndicator extends StatelessWidget {
  const BluetoothStatusIndicator({
    super.key,
    required this.connected,
    this.size = 48,
  });

  final bool connected;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.primary100,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(
            connected ? Icons.bluetooth : Icons.bluetooth_disabled,
            size: size * 0.5,
            color: AppColors.primary600,
          ),
        ),
        if (connected)
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: size * 0.4,
              height: size * 0.4,
              decoration: BoxDecoration(
                color: AppColors.success500,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 2),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.check,
                size: size * 0.22,
                color: AppColors.textOnPrimary,
              ),
            ),
          ),
      ],
    );
  }
}
