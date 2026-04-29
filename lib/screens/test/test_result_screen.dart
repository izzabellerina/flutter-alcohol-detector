import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/device_controller.dart';
import '../../controllers/test_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/date_formatter.dart';
import '../../models/test_models.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common/app_buttons.dart';
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
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Center(
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          _ResultBadge(outcome: result.outcome),
          const SizedBox(height: 16),
          if (result.failedFaceMismatch)
            _FaceMismatchNote()
          else
            _MeasurementSummary(result: result),
          const SizedBox(height: 16),
          _SaveStatusBanner(isSaving: test.isSaving),
          const SizedBox(height: 8),
          Text(
            'ระดับการแจ้งเตือน ${result.threshold.toStringAsFixed(0)} mg%',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 24),
          AppButton.primary(
            label: 'จบการทดสอบ',
            icon: Icons.check_circle_outline,
            onPressed: () => _finish(context),
          ),
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
    final color = passed ? AppColors.resultPass : AppColors.resultFail;
    final label = passed ? 'ผ่าน' : 'ไม่ผ่าน';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          label,
          style: AppTextStyles.resultLarge,
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
      children: [
        Expanded(
          child: _MeasurementCard(
            label: 'อากาศ',
            measurement: result.airMeasurement,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MeasurementCard(
            label: 'ผู้เป่า',
            measurement: result.userMeasurement,
            highlightAlcohol:
                result.userMeasurement.value >= result.threshold,
          ),
        ),
      ],
    );
  }
}

class _MeasurementCard extends StatelessWidget {
  const _MeasurementCard({
    required this.label,
    required this.measurement,
    this.highlightAlcohol = false,
  });

  final String label;
  final TestMeasurement measurement;
  final bool highlightAlcohol;

  @override
  Widget build(BuildContext context) {
    final color =
        highlightAlcohol ? AppColors.danger : AppColors.textPrimary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.bodySmall),
          const SizedBox(height: 4),
          Text(
            DateFormatter.formatThaiDateTimeFull(measurement.timestamp),
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'mg%',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(width: 4),
              Text(
                measurement.value.toStringAsFixed(0),
                style: AppTextStyles.measurement.copyWith(color: color),
              ),
            ],
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.08),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.face_retouching_off, color: AppColors.danger),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'ใบหน้าไม่ตรงกับฐานข้อมูล',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.danger,
                fontWeight: FontWeight.w600,
              ),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isSaving) ...[
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 8),
          Text('กำลังบันทึกผลทดสอบ...', style: AppTextStyles.bodySmall),
        ] else ...[
          const Icon(
            Icons.cloud_done_outlined,
            color: AppColors.success,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            'บันทึกผลทดสอบเรียบร้อย',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.success,
            ),
          ),
        ],
      ],
    );
  }
}
