import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/device_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/device_models.dart';
import '../../routes/app_routes.dart';
import '../../services/card_reader_service.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/app_header.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/shimmer_box.dart';
import '../../widgets/common/status_badge.dart';

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
          const SizedBox(height: AppSpacing.lg),
          _DeviceCard(
            title: 'เครื่องเป่าแอลกอฮอล์',
            description: alcohol.device?.name ?? 'อุปกรณ์ Bluetooth สำหรับวัดระดับแอลกอฮอล์',
            icon: Icons.air,
            iconBg: AppColors.primary500,
            state: alcohol,
            onConnect: controller.connectAlcoholDevice,
            onDisconnect: controller.disconnectAlcoholDevice,
          ).animate().fadeIn(duration: 320.ms).slideY(begin: 0.1, curve: Curves.easeOutCubic),
          const SizedBox(height: AppSpacing.md),
          _DeviceCard(
            title: 'เครื่องอ่านใบขับขี่',
            description: cardReader.device?.name ?? 'เชื่อมต่อเพื่ออ่านข้อมูลผู้ขับขี่',
            icon: Icons.contactless,
            iconBg: AppColors.info600,
            state: cardReader,
            onConnect: controller.connectCardReader,
            onDisconnect: controller.disconnectCardReader,
          ).animate(delay: 80.ms).fadeIn(duration: 320.ms).slideY(begin: 0.1, curve: Curves.easeOutCubic),
          const SizedBox(height: AppSpacing.md),
          _DriverCard(
            isCardReaderConnected: cardReader.isConnected,
            isReadingCard: controller.isReadingCard,
            driver: driver,
            onReadCard: () => _readCard(context),
            onResetDriver: controller.rejectDriver,
          ).animate(delay: 160.ms).fadeIn(duration: 320.ms).slideY(begin: 0.1, curve: Curves.easeOutCubic),
          if (cardError != null) ...[
            const SizedBox(height: AppSpacing.md),
            _CardReadErrorBanner(
              error: cardError,
              onRetry: () => _readCard(context),
              onDismiss: controller.clearCardReadError,
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          _StartTestButton(
            enabled: controller.isReadyForTest,
            onPressed: () => context.push(AppRoutes.testReady),
          ),
          if (alcohol.hasError) ...[
            const SizedBox(height: AppSpacing.lg),
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
        ],
      ),
    );
  }
}

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconBg,
    required this.state,
    required this.onConnect,
    required this.onDisconnect,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color iconBg;
  final DeviceState state;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  StatusVariant get _variant {
    if (state.isConnected) return StatusVariant.success;
    if (state.isConnecting) return StatusVariant.info;
    if (state.hasError) return StatusVariant.danger;
    return StatusVariant.neutral;
  }

  String get _statusLabel {
    if (state.isConnected) return 'เชื่อมต่อแล้ว';
    if (state.isConnecting) return 'กำลังเชื่อมต่อ';
    if (state.hasError) return 'ขัดข้อง';
    return 'ยังไม่เชื่อมต่อ';
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: iconBg.withValues(alpha: state.isConnected ? 1.0 : 0.15),
              borderRadius: AppRadius.all(AppRadius.md),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 28,
              color: state.isConnected ? Colors.white : iconBg,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.headingSmall),
                const SizedBox(height: 2),
                if (state.isConnecting)
                  const ShimmerBox(width: 140, height: 12)
                else
                  Text(
                    state.device?.id ?? description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: AppSpacing.xs + 2),
                StatusBadge(label: _statusLabel, variant: _variant),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _ConnectAction(
            isConnected: state.isConnected,
            isConnecting: state.isConnecting,
            onConnect: onConnect,
            onDisconnect: onDisconnect,
          ),
        ],
      ),
    );
  }
}

class _ConnectAction extends StatelessWidget {
  const _ConnectAction({
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
    if (isConnecting) {
      return const SizedBox(
        width: 36,
        height: 36,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    if (isConnected) {
      return IconButton.filledTonal(
        onPressed: onDisconnect,
        icon: const Icon(Icons.link_off, size: 20),
        color: AppColors.danger600,
        tooltip: 'ตัดการเชื่อมต่อ',
        style: IconButton.styleFrom(
          backgroundColor: AppColors.danger50,
        ),
      );
    }
    return IconButton.filledTonal(
      onPressed: onConnect,
      icon: const Icon(Icons.add_link, size: 20),
      color: AppColors.primary700,
      tooltip: 'เชื่อมต่อ',
      style: IconButton.styleFrom(
        backgroundColor: AppColors.primary50,
      ),
    );
  }
}

class _DriverCard extends StatelessWidget {
  const _DriverCard({
    required this.isCardReaderConnected,
    required this.isReadingCard,
    required this.driver,
    required this.onReadCard,
    required this.onResetDriver,
  });

  final bool isCardReaderConnected;
  final bool isReadingCard;
  final DriverInfo? driver;
  final VoidCallback onReadCard;
  final VoidCallback onResetDriver;

  @override
  Widget build(BuildContext context) {
    if (driver != null) {
      return AppCard(
        child: Row(
          children: [
            _DriverAvatar(name: driver!.fullName),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(driver!.fullName, style: AppTextStyles.headingSmall),
                  const SizedBox(height: 2),
                  Text(
                    'ใบขับขี่ ${driver!.maskedLicenseNumber}',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.xs + 2),
                  const StatusBadge(
                    label: 'ยืนยันแล้ว',
                    variant: StatusVariant.success,
                    icon: Icons.check,
                  ),
                ],
              ),
            ),
            IconButton.filledTonal(
              onPressed: onResetDriver,
              icon: const Icon(Icons.swap_horiz, size: 20),
              tooltip: 'รูดบัตรใหม่',
              style: IconButton.styleFrom(
                backgroundColor: AppColors.surfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    final canRead = isCardReaderConnected && !isReadingCard;
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: AppRadius.all(AppRadius.md),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.person_outline,
              size: 28,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ข้อมูลผู้ขับขี่',
                  style: AppTextStyles.headingSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  isCardReaderConnected
                      ? 'พร้อมรูดใบขับขี่'
                      : 'เชื่อมต่อเครื่องอ่านบัตรก่อน',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          if (isReadingCard)
            const SizedBox(
              width: 36,
              height: 36,
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton.filledTonal(
              onPressed: canRead ? onReadCard : null,
              icon: const Icon(Icons.credit_card, size: 20),
              tooltip: 'รูดใบขับขี่',
              style: IconButton.styleFrom(
                backgroundColor: canRead
                    ? AppColors.primary50
                    : AppColors.neutral100,
                foregroundColor: canRead
                    ? AppColors.primary700
                    : AppColors.neutral400,
              ),
            ),
        ],
      ),
    );
  }
}

class _DriverAvatar extends StatelessWidget {
  const _DriverAvatar({required this.name});

  final String name;

  String _initials() {
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
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary500, AppColors.primary700],
        ),
        borderRadius: AppRadius.all(AppRadius.md),
      ),
      alignment: Alignment.center,
      child: Text(
        _initials(),
        style: AppTextStyles.headingMedium.copyWith(
          color: AppColors.textOnPrimary,
        ),
      ),
    );
  }
}

class _StartTestButton extends StatelessWidget {
  const _StartTestButton({required this.enabled, required this.onPressed});

  final bool enabled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: enabled
              ? const LinearGradient(
                  colors: [AppColors.primary500, AppColors.primary700],
                )
              : null,
          color: enabled ? null : AppColors.neutral200,
          borderRadius: AppRadius.all(AppRadius.lg),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppColors.primary500.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: AppRadius.all(AppRadius.lg),
            onTap: enabled ? onPressed : null,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.air,
                    color: enabled
                        ? AppColors.textOnPrimary
                        : AppColors.textMuted,
                    size: 24,
                  ),
                  const SizedBox(width: AppSpacing.sm + 2),
                  Text(
                    'เริ่มการทดสอบ',
                    style: AppTextStyles.headingSmall.copyWith(
                      color: enabled
                          ? AppColors.textOnPrimary
                          : AppColors.textMuted,
                    ),
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
