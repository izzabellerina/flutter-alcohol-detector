import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/device_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common/app_buttons.dart';
import '../../widgets/common/app_header.dart';
import '../../widgets/common/app_scaffold.dart';

class TestReadyScreen extends StatelessWidget {
  const TestReadyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DeviceController>();
    final driver = controller.confirmedDriver;
    final alcoholDevice = controller.alcoholState.device;

    return AppScaffold(
      header: AppHeader(
        greetingName: 'DEMO',
        licenseNumber: driver?.maskedLicenseNumber,
        deviceId: alcoholDevice?.id,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          Icon(
            Icons.air,
            size: 96,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'พร้อมเริ่มการทดสอบ',
            textAlign: TextAlign.center,
            style: AppTextStyles.headingMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'เมื่อพร้อม กดปุ่มด้านล่างเพื่อเริ่มเป่าแอลกอฮอล์',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          AppButton.primary(
            label: 'เริ่มการทดสอบ',
            icon: Icons.play_arrow,
            onPressed: driver == null
                ? null
                : () => context.push(AppRoutes.testInProgress),
          ),
          const SizedBox(height: 12),
          AppButton.outline(
            label: 'ยกเลิก',
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }
}
