import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/test_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/date_formatter.dart';
import '../../models/test_models.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common/app_buttons.dart';
import '../../widgets/common/app_footer.dart';
import '../../widgets/common/wave_divider.dart';

class TestResultScreen extends StatelessWidget {
  const TestResultScreen({super.key});

  void _retry(BuildContext context) {
    context.read<TestController>().reset();
    context.pushReplacement(AppRoutes.testReady);
  }

  void _logout(BuildContext context) {
    context.read<TestController>().reset();
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final test = context.watch<TestController>();
    final result = test.result;

    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: Text('ผลการทดสอบ', style: AppTextStyles.headingSmall)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Text('ไม่พบผลการทดสอบ', style: AppTextStyles.bodyMedium),
          ),
        ),
      );
    }

    final passed = result.passed;
    final faceMismatch = result.failedFaceMismatch;
    final exceedThreshold = result.userMeasurement.value >= result.threshold;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Header(),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.xl,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _StatusIndicator(
                      passed: passed,
                      exceedThreshold: exceedThreshold,
                      faceMismatch: faceMismatch,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _BigNumber(
                      value: result.userMeasurement.value,
                      isFail: !passed,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _ResultPhoto(passed: passed),
                    const SizedBox(height: AppSpacing.lg),
                    if (faceMismatch) ...[
                      const _InfoPill(
                        icon: Icons.badge_outlined,
                        iconBg: AppColors.danger100,
                        iconColor: AppColors.danger600,
                        bg: AppColors.danger50,
                        text: 'ใบหน้าไม่ตรงกับฐานข้อมูล',
                        textColor: AppColors.danger700,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                    _InfoPill(
                      icon: Icons.edit_outlined,
                      iconBg: AppColors.primary100,
                      iconColor: AppColors.primary600,
                      bg: AppColors.primary50,
                      text:
                          'ระดับการแจ้งเตือน ${result.threshold.toStringAsFixed(0)} mg%',
                      textColor: AppColors.primary700,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _MeasurementColumns(result: result),
                    const SizedBox(height: AppSpacing.lg),
                    WaveDivider(
                      color: passed
                          ? AppColors.success500
                          : AppColors.danger500,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _SaveStatusBanner(isSaving: test.isSaving),
                    const SizedBox(height: AppSpacing.md),
                    AppButton.primary(
                      label: 'ลองใหม่อีกครั้ง',
                      icon: Icons.refresh,
                      onPressed: () => _retry(context),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppButton.outlinePrimary(
                      label: 'ออกจากระบบ',
                      icon: Icons.logout,
                      onPressed: () => _logout(context),
                    ),
                    const SizedBox(height: AppSpacing.lg),
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
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary500, AppColors.primary700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              const SizedBox(width: 40),
              Expanded(
                child: Text(
                  'ผลการทดสอบ',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headingSmall.copyWith(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.logout, size: 22),
                color: AppColors.textOnPrimary,
                onPressed: () {
                  context.read<TestController>().reset();
                  context.go(AppRoutes.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  const _StatusIndicator({
    required this.passed,
    required this.exceedThreshold,
    required this.faceMismatch,
  });

  final bool passed;
  final bool exceedThreshold;
  final bool faceMismatch;

  String get _label {
    if (passed) return 'ผ่าน';
    if (exceedThreshold) return 'แอลกอฮอล์เกินกำหนด';
    if (faceMismatch) return 'ใบหน้าไม่ตรงกับระบบ';
    return 'ไม่ผ่าน';
  }

  @override
  Widget build(BuildContext context) {
    final color = passed ? AppColors.success500 : AppColors.danger500;
    final icon = passed ? Icons.check : Icons.close;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 22, color: AppColors.textOnPrimary),
        ),
        const SizedBox(width: AppSpacing.sm + 2),
        Flexible(
          child: Text(
            _label,
            style: AppTextStyles.headingMedium.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _BigNumber extends StatelessWidget {
  const _BigNumber({required this.value, required this.isFail});

  final double value;
  final bool isFail;

  @override
  Widget build(BuildContext context) {
    final color = isFail ? AppColors.danger500 : AppColors.success500;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.6, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value.toStringAsFixed(0),
              style: TextStyle(
                fontSize: 96,
                fontWeight: FontWeight.bold,
                color: color,
                height: 1,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Text(
                'mg%',
                style: AppTextStyles.headingLarge.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultPhoto extends StatelessWidget {
  const _ResultPhoto({required this.passed});

  final bool passed;

  @override
  Widget build(BuildContext context) {
    final color = passed ? AppColors.success500 : AppColors.danger500;
    final label = passed ? 'ผ่าน' : 'ไม่ผ่าน';
    final icon = passed ? Icons.check : Icons.close;

    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppRadius.all(AppRadius.lg),
          border: Border.all(color: color, width: 4),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: AppRadius.all(AppRadius.md),
              child: Container(
                color: AppColors.neutral200,
                child: Center(
                  child: Icon(
                    Icons.person,
                    size: 120,
                    color: AppColors.neutral400,
                  ),
                ),
              ),
            ),
            Positioned(
              right: AppSpacing.md,
              bottom: AppSpacing.md,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs + 2,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: AppRadius.all(AppRadius.pill),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: AppColors.background,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(icon, size: 16, color: color),
                    ),
                    const SizedBox(width: AppSpacing.xs + 2),
                    Text(
                      label,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.bg,
    required this.text,
    required this.textColor,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color bg;
  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.all(AppRadius.pill),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MeasurementColumns extends StatelessWidget {
  const _MeasurementColumns({required this.result});

  final TestResult result;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: _MeasurementColumn(
              label: 'อากาศ',
              measurement: result.airMeasurement,
              isFail: false,
              threshold: result.threshold,
            ),
          ),
          const VerticalDivider(
            color: AppColors.divider,
            thickness: 1,
            width: 1,
          ),
          Expanded(
            child: _MeasurementColumn(
              label: 'ผู้เป่า',
              measurement: result.userMeasurement,
              isFail: result.userMeasurement.value >= result.threshold,
              threshold: result.threshold,
            ),
          ),
        ],
      ),
    );
  }
}

class _MeasurementColumn extends StatelessWidget {
  const _MeasurementColumn({
    required this.label,
    required this.measurement,
    required this.isFail,
    required this.threshold,
  });

  final String label;
  final TestMeasurement measurement;
  final bool isFail;
  final double threshold;

  @override
  Widget build(BuildContext context) {
    final color = isFail ? AppColors.danger500 : AppColors.textPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.headingSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            DateFormatter.formatThaiDateTimeFull(measurement.timestamp),
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: AppSpacing.sm + 2),
          Text(
            measurement.value.toStringAsFixed(0),
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'mg%',
            style: AppTextStyles.bodyMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SaveStatusBanner extends StatelessWidget {
  const _SaveStatusBanner({required this.isSaving});

  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Row(
        key: ValueKey(isSaving),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isSaving) ...[
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text('กำลังบันทึกผลทดสอบ...', style: AppTextStyles.bodySmall),
          ] else ...[
            const Icon(
              Icons.cloud_done_outlined,
              color: AppColors.success600,
              size: 16,
            ),
            const SizedBox(width: AppSpacing.xs + 2),
            Text(
              'บันทึกผลทดสอบเรียบร้อย',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.success700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

