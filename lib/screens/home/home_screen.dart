import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/device_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/device_models.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common/app_buttons.dart';
import '../../widgets/common/app_header.dart';
import '../../widgets/common/app_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DeviceController>();
    final alcohol = controller.alcoholState;
    final cardReader = controller.cardReaderState;

    return AppScaffold(
      header: AppHeader(
        greetingName: 'DEMO',
        licenseNumber: cardReader.isConnected ? '59xxx00' : null,
        deviceId: alcohol.device?.id,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          _AlcoholDeviceButton(state: alcohol),
          const SizedBox(height: 12),
          _CardReaderButton(state: cardReader),
          const SizedBox(height: 12),
          AppButton.primary(
            label: 'เริ่มการทดสอบ',
            onPressed: controller.isReadyForTest
                ? () => context.push(AppRoutes.testReady)
                : null,
          ),
          if (alcohol.hasError || cardReader.hasError) ...[
            const SizedBox(height: 16),
            _ErrorBanner(
              message: alcohol.errorMessage ?? cardReader.errorMessage ?? '',
            ),
          ],
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => context.go(AppRoutes.login),
            child: const Text('ออกจากระบบ'),
          ),
        ],
      ),
    );
  }
}

class _AlcoholDeviceButton extends StatelessWidget {
  const _AlcoholDeviceButton({required this.state});

  final DeviceState state;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<DeviceController>();

    if (state.isConnected) {
      return AppButton.danger(
        label: 'เลิกเชื่อมต่ออุปกรณ์',
        icon: Icons.bluetooth_disabled,
        onPressed: controller.disconnectAlcoholDevice,
      );
    }
    return AppButton.secondary(
      label: state.isConnecting
          ? 'กำลังเชื่อมต่อ...'
          : 'เชื่อมต่ออุปกรณ์',
      icon: Icons.bluetooth,
      isLoading: state.isConnecting,
      onPressed: state.isConnecting
          ? null
          : controller.connectAlcoholDevice,
    );
  }
}

class _CardReaderButton extends StatelessWidget {
  const _CardReaderButton({required this.state});

  final DeviceState state;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<DeviceController>();

    if (state.isConnected) {
      return AppButton.danger(
        label: 'เลิกเชื่อมต่อเครื่องอ่านใบขับขี่',
        icon: Icons.usb_off,
        onPressed: controller.disconnectCardReader,
      );
    }
    return AppButton.secondary(
      label: state.isConnecting
          ? 'กำลังเชื่อมต่อ...'
          : 'ดึงข้อมูลเครื่องอ่านใบขับขี่',
      icon: Icons.usb,
      isLoading: state.isConnecting,
      onPressed: state.isConnecting
          ? null
          : controller.connectCardReader,
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.08),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.danger, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }
}
