import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/device_controller.dart';
import '../../controllers/test_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/test_models.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common/app_footer.dart';
import '../../widgets/common/face_frame_preview.dart';

class TestInProgressScreen extends StatefulWidget {
  const TestInProgressScreen({super.key});

  @override
  State<TestInProgressScreen> createState() => _TestInProgressScreenState();
}

class _TestInProgressScreenState extends State<TestInProgressScreen> {
  bool _navigatedToResult = false;
  int? _countdown = 3;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startPreCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startPreCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_countdown! > 1) {
          _countdown = _countdown! - 1;
        } else {
          _countdown = null;
          timer.cancel();
          _begin();
        }
      });
    });
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

    if (!_navigatedToResult && test.phase == TestPhase.complete) {
      _navigatedToResult = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.pushReplacement(AppRoutes.testComplete);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            SingleChildScrollView(
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
                        _StatusTitle(
                          phase: test.phase,
                          faceInFrame: test.faceInFrame,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Center(
                          child: _ProgressRing(progress: test.progress),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        FaceFramePreview(faceInFrame: test.faceInFrame),
                        const SizedBox(height: AppSpacing.lg),
                        const _InstructionPill(),
                        const SizedBox(height: AppSpacing.lg),
                        if (kDebugMode) const _DebugFaceToggle(),
                        const SizedBox(height: AppSpacing.md),
                        const AppFooter(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_countdown != null) _CountdownOverlay(seconds: _countdown!),
          ],
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
                  'เริ่มการทดสอบ',
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
                  context.go(AppRoutes.home);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusTitle extends StatelessWidget {
  const _StatusTitle({required this.phase, required this.faceInFrame});

  final TestPhase phase;
  final bool faceInFrame;

  String get _label {
    if (!faceInFrame) return 'หยุดชั่วคราว...';
    switch (phase) {
      case TestPhase.preparingAir:
      case TestPhase.idle:
        return 'เริ่มการเป่า...';
      case TestPhase.blowing:
        return 'กำลังเป่า...';
      case TestPhase.complete:
        return 'เสร็จสมบูรณ์';
      case TestPhase.cancelled:
        return 'ยกเลิกแล้ว';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color =
        faceInFrame ? AppColors.textPrimary : AppColors.danger600;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: Text(
        _label,
        key: ValueKey('$phase-$faceInFrame'),
        textAlign: TextAlign.center,
        style: AppTextStyles.headingLarge.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).round();
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 200),
              builder: (context, value, _) {
                return CircularProgressIndicator(
                  value: value,
                  strokeWidth: 14,
                  strokeCap: StrokeCap.round,
                  backgroundColor: AppColors.neutral100,
                  valueColor: const AlwaysStoppedAnimation(
                    AppColors.success500,
                  ),
                );
              },
            ),
          ),
          Text(
            '$percent%',
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _InstructionPill extends StatelessWidget {
  const _InstructionPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: AppRadius.all(AppRadius.pill),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary100,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.info_outline,
              size: 16,
              color: AppColors.primary600,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'ให้นั่งอยู่ในกรอบ ตลอดเวลาทดสอบ',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ปุ่มสำหรับสลับ face-in-frame เพื่อทดสอบ — แสดงเฉพาะ debug build
class _DebugFaceToggle extends StatelessWidget {
  const _DebugFaceToggle();

  @override
  Widget build(BuildContext context) {
    final test = context.watch<TestController>();
    return Center(
      child: TextButton.icon(
        onPressed: () => context
            .read<TestController>()
            .setFaceInFrame(!test.faceInFrame),
        icon: const Icon(Icons.face, size: 16),
        label: Text(
          test.faceInFrame
              ? 'DEBUG: จำลองใบหน้าออกจากกรอบ'
              : 'DEBUG: ใบหน้ากลับเข้ากรอบ',
          style: AppTextStyles.bodySmall,
        ),
      ),
    );
  }
}

class _CountdownOverlay extends StatelessWidget {
  const _CountdownOverlay({required this.seconds});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: AppColors.background.withValues(alpha: 0.95),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'เตรียมพร้อม...',
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TweenAnimationBuilder<double>(
                key: ValueKey(seconds),
                tween: Tween(begin: 1.4, end: 1.0),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutBack,
                builder: (context, scale, child) {
                  return Transform.scale(scale: scale, child: child);
                },
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary500, AppColors.primary700],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary500.withValues(alpha: 0.4),
                        blurRadius: 32,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$seconds',
                    style: AppTextStyles.displayLarge.copyWith(
                      color: AppColors.textOnPrimary,
                      fontSize: 80,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
