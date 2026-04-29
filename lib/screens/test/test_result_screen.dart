import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/device_controller.dart';
import '../../controllers/test_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/date_formatter.dart';
import '../../models/test_models.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/app_header.dart';
import '../../widgets/common/app_scaffold.dart';

class TestResultScreen extends StatelessWidget {
  const TestResultScreen({super.key});

  void _finish(BuildContext context) {
    context.read<TestController>().reset();
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final test = context.watch<TestController>();
    final device = context.watch<DeviceController>();
    final result = test.result;

    if (result == null) {
      return AppScaffold(
        header: const AppHeader(greetingName: 'DEMO'),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
            child: Text(
              'ไม่พบผลการทดสอบ',
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ),
      );
    }

    return AppScaffold(
      header: AppHeader(
        greetingName: 'DEMO',
        licenseNumber: device.confirmedDriver?.maskedLicenseNumber,
        deviceId: device.alcoholState.device?.id,
        title: 'ผลการทดสอบ',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.lg),
          _ResultBadge(outcome: result.outcome),
          const SizedBox(height: AppSpacing.lg),
          if (result.failedFaceMismatch)
            _FaceMismatchNote()
          else
            _MeasurementSummary(result: result),
          const SizedBox(height: AppSpacing.md),
          _ThresholdNote(threshold: result.threshold),
          const SizedBox(height: AppSpacing.md),
          _SaveStatusBanner(isSaving: test.isSaving),
          const SizedBox(height: AppSpacing.xl),
          _FinishButton(onPressed: () => _finish(context)),
        ],
      ),
    );
  }
}

class _ResultBadge extends StatelessWidget {
  const _ResultBadge({required this.outcome});

  final TestOutcome outcome;

  @override
  Widget build(BuildContext context) {
    final passed = outcome == TestOutcome.passed;
    final color = passed ? AppColors.primary500 : AppColors.danger500;
    final label = passed ? 'ผ่าน' : 'ไม่ผ่าน';
    final icon = passed ? Icons.check_circle : Icons.cancel;
    final caption = passed
        ? 'พร้อมขับขี่ได้ — ขอให้เดินทางปลอดภัย'
        : 'ไม่อนุญาตให้ขับขี่ — กรุณาพักรถ';

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.6, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.xl,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: passed
                ? [AppColors.primary500, AppColors.primary700]
                : [AppColors.danger500, AppColors.danger700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: AppRadius.all(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 56, color: Colors.white),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              label,
              style: AppTextStyles.resultLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              caption,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MeasurementSummary extends StatelessWidget {
  const _MeasurementSummary({required this.result});

  final TestResult result;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: _MeasurementCard(
            label: 'อากาศ',
            icon: Icons.air,
            measurement: result.airMeasurement,
            threshold: result.threshold,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _MeasurementCard(
            label: 'ผู้เป่า',
            icon: Icons.face,
            measurement: result.userMeasurement,
            threshold: result.threshold,
          ),
        ),
      ],
    );
  }
}

class _MeasurementCard extends StatelessWidget {
  const _MeasurementCard({
    required this.label,
    required this.icon,
    required this.measurement,
    required this.threshold,
  });

  final String label;
  final IconData icon;
  final TestMeasurement measurement;
  final double threshold;

  @override
  Widget build(BuildContext context) {
    final exceed = measurement.value >= threshold;
    final color = exceed ? AppColors.danger600 : AppColors.primary700;
    // bar value: relative to 2x threshold (full bar = 2 * threshold)
    final barValue = (measurement.value / (threshold * 2)).clamp(0.0, 1.0);
    // threshold line position (0.5 if 2x scale)
    const thresholdPosition = 0.5;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: AppRadius.all(AppRadius.sm),
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 18, color: AppColors.textSecondary),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            DateFormatter.formatThaiDateTimeFull(measurement.timestamp),
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                measurement.value.toStringAsFixed(0),
                style: AppTextStyles.measurement.copyWith(color: color),
              ),
              const SizedBox(width: 4),
              Text(
                'mg%',
                style: AppTextStyles.bodySmall.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Mini bar with threshold line
          SizedBox(
            height: 8,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.neutral100,
                    borderRadius: AppRadius.all(AppRadius.pill),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: barValue,
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: AppRadius.all(AppRadius.pill),
                    ),
                  ),
                ),
                // Threshold marker
                Align(
                  alignment: const Alignment(thresholdPosition * 2 - 1, 0),
                  child: Container(
                    width: 2,
                    height: 14,
                    color: AppColors.warning700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThresholdNote extends StatelessWidget {
  const _ThresholdNote({required this.threshold});

  final double threshold;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.warning50,
        borderRadius: AppRadius.all(AppRadius.md),
        border: Border.all(color: AppColors.warning500.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            size: 16,
            color: AppColors.warning700,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'ระดับการแจ้งเตือน ${threshold.toStringAsFixed(0)} mg%',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.warning700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaceMismatchNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.danger50,
        border: Border.all(color: AppColors.danger100),
        borderRadius: AppRadius.all(AppRadius.md),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.danger100,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.face_retouching_off,
              color: AppColors.danger600,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ใบหน้าไม่ตรงกับฐานข้อมูล',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.danger700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'ไม่สามารถยืนยันตัวตนผู้เป่า กรุณาทดสอบใหม่',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.danger600,
                  ),
                ),
              ],
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
              color: AppColors.primary600,
              size: 16,
            ),
            const SizedBox(width: AppSpacing.xs + 2),
            Text(
              'บันทึกผลทดสอบเรียบร้อย',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FinishButton extends StatelessWidget {
  const _FinishButton({required this.onPressed});

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
                    Icons.home_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'จบการทดสอบ',
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
