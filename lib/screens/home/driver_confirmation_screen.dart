import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/device_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../services/card_reader_service.dart';
import '../../widgets/common/app_buttons.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/app_header.dart';
import '../../widgets/common/app_scaffold.dart';

class DriverConfirmationScreen extends StatelessWidget {
  const DriverConfirmationScreen({super.key, required this.driver});

  final DriverInfo driver;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<DeviceController>();

    return AppScaffold(
      header: const AppHeader(greetingName: 'DEMO', title: 'ผลการเรียกข้อมูล'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs + 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary50,
                    borderRadius: AppRadius.all(AppRadius.pill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: AppColors.primary600,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'อ่านบัตรสำเร็จ',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _LicensePlate(
                  plate: driver.vehiclePlate,
                  province: driver.province,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _DriverDetailCard(driver: driver),
          const SizedBox(height: AppSpacing.xxl),
          _ConfirmButton(
            onPressed: () {
              controller.confirmDriver(driver);
              context.go(AppRoutes.home);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton.outline(
            label: 'ข้อมูลไม่ถูกต้อง',
            icon: Icons.close,
            onPressed: () {
              controller.rejectDriver();
              context.go(AppRoutes.home);
            },
          ),
        ],
      ),
    );
  }
}

/// ป้ายทะเบียนรถสไตล์ไทย — กรอบขาว ตัวเลขดำใหญ่
class _LicensePlate extends StatelessWidget {
  const _LicensePlate({required this.plate, required this.province});

  final String plate;
  final String province;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.all(AppRadius.md),
        border: Border.all(color: AppColors.neutral800, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral900.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            plate,
            style: AppTextStyles.displayLarge.copyWith(
              color: AppColors.neutral900,
              letterSpacing: 4,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.xs),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Text(
              province,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.neutral800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DriverDetailCard extends StatelessWidget {
  const _DriverDetailCard({required this.driver});

  final DriverInfo driver;

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.characters.take(1).toString().toUpperCase();
    }
    return ('${parts.first.characters.take(1)}'
            '${parts.last.characters.take(1)}')
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ข้อมูลผู้ขับขี่',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary500, AppColors.primary700],
                  ),
                  borderRadius: AppRadius.all(AppRadius.lg),
                ),
                alignment: Alignment.center,
                child: Text(
                  _initials(driver.fullName),
                  style: AppTextStyles.headingLarge.copyWith(
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(driver.fullName, style: AppTextStyles.headingMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        const Icon(
                          Icons.badge_outlined,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'ใบขับขี่ ${driver.licenseNumber}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary500, AppColors.primary700],
          ),
          borderRadius: AppRadius.all(AppRadius.md),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary500.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: AppRadius.all(AppRadius.md),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'ยืนยันข้อมูล',
                    style: AppTextStyles.button,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
