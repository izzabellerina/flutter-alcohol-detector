import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/device_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common/app_buttons.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/app_header.dart';
import '../../widgets/common/app_scaffold.dart';

class TestReadyScreen extends StatefulWidget {
  const TestReadyScreen({super.key});

  @override
  State<TestReadyScreen> createState() => _TestReadyScreenState();
}

class _TestReadyScreenState extends State<TestReadyScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breathController;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

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
        title: 'พร้อมเริ่มการทดสอบ',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.xl),
          Center(
            child: AnimatedBuilder(
              animation: _breathController,
              builder: (context, _) {
                final scale = 1.0 + (_breathController.value * 0.08);
                final glowOpacity = 0.2 + (_breathController.value * 0.3);
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: const RadialGradient(
                        colors: [AppColors.primary500, AppColors.primary700],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary500
                              .withValues(alpha: glowOpacity),
                          blurRadius: 32,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.air,
                      size: 72,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'พร้อมแล้วใช่ไหม?',
            textAlign: TextAlign.center,
            style: AppTextStyles.headingLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'อ่านคำแนะนำให้ครบก่อนกดเริ่ม',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                _ChecklistItem(
                  icon: Icons.air,
                  text: 'เป่ายาวประมาณ 5 วินาที',
                ),
                SizedBox(height: AppSpacing.sm + 2),
                _ChecklistItem(
                  icon: Icons.face_retouching_natural,
                  text: 'อยู่ในกรอบใบหน้าตลอดการทดสอบ',
                ),
                SizedBox(height: AppSpacing.sm + 2),
                _ChecklistItem(
                  icon: Icons.do_not_disturb_alt,
                  text: 'ห้ามถอดตัวเป่าระหว่างทดสอบ',
                ),
                SizedBox(height: AppSpacing.sm + 2),
                _ChecklistItem(
                  icon: Icons.thumb_up_alt_outlined,
                  text: 'หายใจเข้าลึก ๆ ก่อนเริ่ม',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _StartButton(
            enabled: driver != null,
            onPressed: driver == null
                ? null
                : () => context.push(AppRoutes.testInProgress),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton.outline(
            label: 'ยกเลิก',
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary50,
            borderRadius: AppRadius.all(AppRadius.sm),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 18, color: AppColors.primary700),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(text, style: AppTextStyles.bodyMedium),
        ),
      ],
    );
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton({required this.enabled, this.onPressed});

  final bool enabled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: enabled
              ? const LinearGradient(
                  colors: [AppColors.primary500, AppColors.primary700],
                )
              : null,
          color: enabled ? null : AppColors.neutral200,
          borderRadius: AppRadius.all(AppRadius.md),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppColors.primary500.withValues(alpha: 0.3),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
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
                  Icon(
                    Icons.play_arrow_rounded,
                    color: enabled
                        ? AppColors.textOnPrimary
                        : AppColors.textMuted,
                    size: 24,
                  ),
                  const SizedBox(width: AppSpacing.xs + 2),
                  Text(
                    'เริ่มการทดสอบ',
                    style: AppTextStyles.button.copyWith(
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
