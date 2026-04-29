import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/device_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../services/card_reader_service.dart';
import '../../widgets/common/app_buttons.dart';
import '../../widgets/common/app_header.dart';
import '../../widgets/common/app_scaffold.dart';

class DriverConfirmationScreen extends StatelessWidget {
  const DriverConfirmationScreen({super.key, required this.driver});

  final DriverInfo driver;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<DeviceController>();

    return AppScaffold(
      header: const AppHeader(greetingName: 'DEMO'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Text(
            'ผลการเรียกข้อมูล',
            textAlign: TextAlign.center,
            style: AppTextStyles.headingMedium,
          ),
          const SizedBox(height: 16),
          _LicensePlateBox(
            plate: driver.vehiclePlate,
            province: driver.province,
          ),
          const SizedBox(height: 24),
          Text('ข้อมูลผู้ขับขี่', style: AppTextStyles.bodySmall),
          const SizedBox(height: 4),
          Text(driver.fullName, style: AppTextStyles.headingSmall),
          const SizedBox(height: 4),
          Text(
            'หมายเลขใบขับขี่ ${driver.licenseNumber}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          AppButton.primary(
            label: 'ยืนยันข้อมูล',
            icon: Icons.check_circle_outline,
            onPressed: () {
              controller.confirmDriver(driver);
              context.go(AppRoutes.home);
            },
          ),
          const SizedBox(height: 12),
          AppButton.secondary(
            label: 'ข้อมูลไม่ถูกต้อง',
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

class _LicensePlateBox extends StatelessWidget {
  const _LicensePlateBox({required this.plate, required this.province});

  final String plate;
  final String province;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 2),
        ),
        child: Column(
          children: [
            Text(
              plate,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              province,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
