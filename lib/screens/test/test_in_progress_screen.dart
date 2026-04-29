import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/device_controller.dart';
import '../../controllers/test_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/test_models.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common/app_buttons.dart';
import '../../widgets/common/app_header.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/face_frame_preview.dart';

class TestInProgressScreen extends StatefulWidget {
  const TestInProgressScreen({super.key});

  @override
  State<TestInProgressScreen> createState() => _TestInProgressScreenState();
}

class _TestInProgressScreenState extends State<TestInProgressScreen> {
  bool _navigatedToResult = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _begin());
  }

  Future<void> _begin() async {
    final device = context.read<DeviceController>();
    final test = context.read<TestController>();
    final driver = device.confirmedDriver;
    if (driver == null) return;
    await test.startTest(driver: driver);
  }

  @override
  Widget build(BuildContext context) {
    final test = context.watch<TestController>();
    final device = context.watch<DeviceController>();

    if (!_navigatedToResult && test.phase == TestPhase.complete) {
      _navigatedToResult = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.pushReplacement(AppRoutes.testComplete);
      });
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
          FaceFramePreview(faceInFrame: test.faceInFrame),
          const SizedBox(height: 24),
          _StatusText(phase: test.phase, faceInFrame: test.faceInFrame),
          const SizedBox(height: 16),
          _ProgressIndicator(progress: test.progress),
          const SizedBox(height: 16),
          Text(
            'ใบหน้าอยู่ในกรอบตลอดเวลาทดสอบ',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 24),
          // ปุ่ม dev สำหรับสลับสถานะใบหน้า (ไว้เทสไม่มีกล้องจริง)
          AppButton.outline(
            label: test.faceInFrame
                ? 'จำลอง: ใบหน้าออกจากกรอบ'
                : 'จำลอง: ใบหน้ากลับเข้ากรอบ',
            icon: Icons.face,
            onPressed: () =>
                context.read<TestController>().setFaceInFrame(!test.faceInFrame),
          ),
        ],
      ),
    );
  }
}

class _StatusText extends StatelessWidget {
  const _StatusText({required this.phase, required this.faceInFrame});

  final TestPhase phase;
  final bool faceInFrame;

  String get _label {
    if (!faceInFrame) return 'หยุดชั่วคราว — ขยับใบหน้าให้อยู่ในกรอบ';
    switch (phase) {
      case TestPhase.preparingAir:
        return 'กำลังวัดอากาศ...';
      case TestPhase.blowing:
        return 'กำลังเป่า...';
      case TestPhase.complete:
        return 'การทดสอบเสร็จสมบูรณ์';
      case TestPhase.cancelled:
        return 'ยกเลิกแล้ว';
      case TestPhase.idle:
        return 'เริ่มการเป่า...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _label,
      textAlign: TextAlign.center,
      style: AppTextStyles.headingSmall.copyWith(
        color: faceInFrame ? AppColors.textPrimary : AppColors.danger,
      ),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).round();
    return Column(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.expand(
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: AppColors.surfaceVariant,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
              Text(
                '$percent%',
                style: AppTextStyles.headingLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
