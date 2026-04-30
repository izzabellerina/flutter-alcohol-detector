import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
import '../../widgets/common/app_footer.dart';
import '../../widgets/common/connected_device_card.dart';
import '../../widgets/common/success_header.dart';
import '../../widgets/common/user_card.dart';

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

    final headerState = _resolveHeaderState(
      alcoholConnected: alcohol.isConnected,
      cardReaderConnected: cardReader.isConnected,
      driverConfirmed: driver != null,
    );

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SuccessHeader(
                title: headerState.title,
                subtitle: headerState.subtitle,
                icon: headerState.icon,
                iconColor: headerState.iconColor,
                trailing: BluetoothStatusIndicator(
                  connected: alcohol.isConnected,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    UserCard(
                      greetingName: 'DEMO',
                      licenseNumber:
                          driver?.maskedLicenseNumber,
                    ).animate().fadeIn(duration: 320.ms).slideY(
                          begin: 0.08,
                          curve: Curves.easeOutCubic,
                        ),
                    const SizedBox(height: AppSpacing.xl),
                    AppButton.primary(
                      label: 'เริ่มการทดสอบ',
                      icon: Icons.assignment_outlined,
                      showChevron: true,
                      onPressed: controller.isReadyForTest
                          ? () => context.push(AppRoutes.testReady)
                          : null,
                    ).animate(delay: 80.ms).fadeIn(duration: 320.ms).slideY(
                          begin: 0.08,
                          curve: Curves.easeOutCubic,
                        ),
                    const SizedBox(height: AppSpacing.md),
                    _CardReaderActionButton(
                      isCardReaderConnected: cardReader.isConnected,
                      isReadingCard: controller.isReadingCard,
                      isConnecting: cardReader.isConnecting,
                      onConnect: controller.connectCardReader,
                      onDisconnect: controller.disconnectCardReader,
                      onRead: () => _readCard(context),
                    ).animate(delay: 160.ms).fadeIn(duration: 320.ms).slideY(
                          begin: 0.08,
                          curve: Curves.easeOutCubic,
                        ),
                    const SizedBox(height: AppSpacing.md),
                    _AlcoholDeviceButton(
                      isConnected: alcohol.isConnected,
                      isConnecting: alcohol.isConnecting,
                      onConnect: controller.connectAlcoholDevice,
                      onDisconnect: controller.disconnectAlcoholDevice,
                    ).animate(delay: 240.ms).fadeIn(duration: 320.ms).slideY(
                          begin: 0.08,
                          curve: Curves.easeOutCubic,
                        ),
                    if (alcohol.isConnected &&
                        alcohol.device != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      ConnectedDeviceCard(
                        deviceId: alcohol.device!.id,
                        connected: true,
                      ).animate(delay: 320.ms)
                          .fadeIn(duration: 320.ms)
                          .slideY(
                            begin: 0.08,
                            curve: Curves.easeOutCubic,
                          ),
                    ],
                    if (cardError != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      _CardReadErrorBanner(
                        error: cardError,
                        onRetry: () => _readCard(context),
                        onDismiss: controller.clearCardReadError,
                      ),
                    ],
                    if (alcohol.hasError) ...[
                      const SizedBox(height: AppSpacing.md),
                      _ErrorBanner(message: alcohol.errorMessage ?? ''),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    Center(
                      child: TextButton.icon(
                        onPressed: () => context.go(AppRoutes.login),
                        icon: const Icon(Icons.logout, size: 18),
                        label: Text(
                          'ออกจากระบบ',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const AppFooter(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _HeaderState _resolveHeaderState({
    required bool alcoholConnected,
    required bool cardReaderConnected,
    required bool driverConfirmed,
  }) {
    if (driverConfirmed && alcoholConnected) {
      return const _HeaderState(
        title: 'พร้อมเริ่มการทดสอบ',
        subtitle: 'อุปกรณ์ทั้งหมดพร้อมใช้งาน',
        icon: Icons.check_rounded,
      );
    }
    if (alcoholConnected || cardReaderConnected) {
      return const _HeaderState(
        title: 'เชื่อมต่ออุปกรณ์สำเร็จ',
        subtitle: 'พร้อมใช้งานเครื่องอ่านใบขับขี่',
        icon: Icons.check_rounded,
      );
    }
    return const _HeaderState(
      title: 'ยินดีต้อนรับ',
      subtitle: 'เริ่มต้นด้วยการเชื่อมต่ออุปกรณ์',
      icon: Icons.bluetooth_searching,
      iconColor: AppColors.primary600,
    );
  }
}

class _HeaderState {
  const _HeaderState({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconColor,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color? iconColor;
}

/// ปุ่มจัดการเครื่องอ่านใบขับขี่ — เปลี่ยนตาม state:
/// - ไม่เชื่อมต่อ: เชื่อมต่อ
/// - เชื่อมต่อแล้ว ยังไม่ยืนยัน driver: รูดใบขับขี่ (primary)
/// - เชื่อมต่อแล้ว: เลิกเชื่อมต่อเครื่องอ่านใบขับขี่
class _CardReaderActionButton extends StatelessWidget {
  const _CardReaderActionButton({
    required this.isCardReaderConnected,
    required this.isReadingCard,
    required this.isConnecting,
    required this.onConnect,
    required this.onDisconnect,
    required this.onRead,
  });

  final bool isCardReaderConnected;
  final bool isReadingCard;
  final bool isConnecting;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;
  final VoidCallback onRead;

  @override
  Widget build(BuildContext context) {
    if (!isCardReaderConnected) {
      return AppButton.outlinePrimary(
        label: isConnecting ? 'กำลังเชื่อมต่อ...' : 'เชื่อมต่อเครื่องอ่านใบขับขี่',
        icon: Icons.usb,
        showChevron: !isConnecting,
        isLoading: isConnecting,
        onPressed: isConnecting ? null : onConnect,
      );
    }
    return AppButton.outlinePrimary(
      label: isReadingCard ? 'กำลังอ่านบัตร...' : 'ดึงข้อมูลเครื่องอ่านใบขับขี่',
      icon: Icons.download_rounded,
      showChevron: !isReadingCard,
      isLoading: isReadingCard,
      onPressed: isReadingCard ? null : onRead,
    );
  }
}

class _AlcoholDeviceButton extends StatelessWidget {
  const _AlcoholDeviceButton({
    required this.isConnected,
    required this.isConnecting,
    required this.onConnect,
    required this.onDisconnect,
  });

  final bool isConnected;
  final bool isConnecting;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  @override
  Widget build(BuildContext context) {
    if (isConnected) {
      return AppButton.outlineDanger(
        label: 'เลิกเชื่อมต่ออุปกรณ์',
        icon: Icons.bluetooth_disabled,
        showChevron: true,
        onPressed: onDisconnect,
      );
    }
    return AppButton.outlinePrimary(
      label: isConnecting ? 'กำลังเชื่อมต่อ...' : 'เชื่อมต่ออุปกรณ์เป่าแอลกอฮอล์',
      icon: Icons.bluetooth,
      showChevron: !isConnecting,
      isLoading: isConnecting,
      onPressed: isConnecting ? null : onConnect,
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
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.danger50,
        border: Border.all(color: AppColors.danger100),
        borderRadius: AppRadius.all(AppRadius.md),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: AppColors.danger600,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  '${error.message}$detailLine',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.danger700,
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
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.danger50,
        border: Border.all(color: AppColors.danger100),
        borderRadius: AppRadius.all(AppRadius.md),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.danger600,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.danger700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
