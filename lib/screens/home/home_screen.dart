import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/device_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/device_models.dart';
import '../../routes/app_routes.dart';
import '../../services/card_reader_service.dart';
import '../../widgets/common/app_buttons.dart';
import '../../widgets/common/app_header.dart';
import '../../widgets/common/app_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _readCard(BuildContext context) async {
    final controller = context.read<DeviceController>();
    final result = await controller.readDriverCard();
    if (!context.mounted) return;
    if (result != null) {
      context.push(AppRoutes.driverConfirm, extra: result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DeviceController>();
    final alcohol = controller.alcoholState;
    final cardReader = controller.cardReaderState;
    final driver = controller.confirmedDriver;
    final cardError = controller.cardReadError;

    return AppScaffold(
      header: AppHeader(
        greetingName: 'DEMO',
        licenseNumber: driver?.maskedLicenseNumber,
        deviceId: alcohol.device?.id,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          _AlcoholDeviceButton(state: alcohol),
          const SizedBox(height: 12),
          _CardReaderButton(state: cardReader),
          if (cardReader.isConnected && driver == null) ...[
            const SizedBox(height: 12),
            AppButton.secondary(
              label: controller.isReadingCard
                  ? 'กำลังอ่านบัตร...'
                  : 'รูดใบขับขี่',
              icon: Icons.credit_card,
              isLoading: controller.isReadingCard,
              onPressed: controller.isReadingCard
                  ? null
                  : () => _readCard(context),
            ),
          ],
          if (cardError != null) ...[
            const SizedBox(height: 12),
            _CardReadErrorBanner(
              error: cardError,
              onRetry: () => _readCard(context),
              onDismiss: controller.clearCardReadError,
            ),
          ],
          if (driver != null) ...[
            const SizedBox(height: 12),
            _DriverInfoBanner(driver: driver),
          ],
          const SizedBox(height: 12),
          AppButton.primary(
            label: 'เริ่มการทดสอบ',
            onPressed: controller.isReadyForTest
                ? () => context.push(AppRoutes.testReady)
                : null,
          ),
          if (alcohol.hasError) ...[
            const SizedBox(height: 16),
            _ErrorBanner(message: alcohol.errorMessage ?? ''),
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
      label: state.isConnecting ? 'กำลังเชื่อมต่อ...' : 'เชื่อมต่ออุปกรณ์',
      icon: Icons.bluetooth,
      isLoading: state.isConnecting,
      onPressed: state.isConnecting ? null : controller.connectAlcoholDevice,
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
          : 'เชื่อมต่อเครื่องอ่านใบขับขี่',
      icon: Icons.usb,
      isLoading: state.isConnecting,
      onPressed: state.isConnecting ? null : controller.connectCardReader,
    );
  }
}

class _DriverInfoBanner extends StatelessWidget {
  const _DriverInfoBanner({required this.driver});

  final DriverInfo driver;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppColors.success,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'หมายเลขใบขับขี่ ${driver.maskedLicenseNumber}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            color: AppColors.textSecondary,
            tooltip: 'รูดบัตรใหม่',
            onPressed: () {
              context.read<DeviceController>().rejectDriver();
            },
          ),
        ],
      ),
    );
  }
}

class _CardReadErrorBanner extends StatelessWidget {
  const _CardReadErrorBanner({
    required this.error,
    required this.onRetry,
    required this.onDismiss,
  });

  final CardReadException error;
  final VoidCallback onRetry;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final detailLine = error.detail != null ? ' ${error.detail}' : '';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.08),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: AppColors.danger,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${error.message}$detailLine',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.danger,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                color: AppColors.textSecondary,
                onPressed: onDismiss,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('ลองอีกครั้ง'),
              onPressed: onRetry,
            ),
          ),
        ],
      ),
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
