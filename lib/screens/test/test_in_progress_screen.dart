import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/device_controller.dart';
import '../../controllers/test_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
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
        title: 'กำลังทดสอบ',
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.lg),
              FaceFramePreview(faceInFrame: test.faceInFrame),
              const SizedBox(height: AppSpacing.lg),
              _StatusText(phase: test.phase, faceInFrame: test.faceInFrame),
              const SizedBox(height: AppSpacing.md),
              _BreathingProgress(
                progress: test.progress,
                isBlowing: test.phase == TestPhase.blowing,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'รักษาใบหน้าให้อยู่ในกรอบตลอดการทดสอบ',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton.outline(
                label: test.faceInFrame
                    ? 'จำลอง: ใบหน้าออกจากกรอบ'
                    : 'จำลอง: ใบหน้ากลับเข้ากรอบ',
                icon: Icons.face,
                onPressed: () => context
                    .read<TestController>()
                    .setFaceInFrame(!test.faceInFrame),
              ),
            ],
          ),
          if (_countdown != null) _CountdownOverlay(seconds: _countdown!),
        ],
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
        return 'เสร็จสมบูรณ์';
      case TestPhase.cancelled:
        return 'ยกเลิกแล้ว';
      case TestPhase.idle:
        return 'เริ่มการเป่า...';
    }
  }

  IconData get _icon {
    if (!faceInFrame) return Icons.pause_circle_outline;
    switch (phase) {
      case TestPhase.preparingAir:
        return Icons.air;
      case TestPhase.blowing:
        return Icons.bubble_chart;
      case TestPhase.complete:
        return Icons.check_circle_outline;
      default:
        return Icons.hourglass_top;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = faceInFrame ? AppColors.textPrimary : AppColors.danger600;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.2),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: Row(
        key: ValueKey('$phase-$faceInFrame'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_icon, color: color, size: 22),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              _label,
              style: AppTextStyles.headingSmall.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _BreathingProgress extends StatefulWidget {
  const _BreathingProgress({
    required this.progress,
    required this.isBlowing,
  });

  final double progress;
  final bool isBlowing;

  @override
  State<_BreathingProgress> createState() => _BreathingProgressState();
}

class _BreathingProgressState extends State<_BreathingProgress>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    if (widget.isBlowing) _waveController.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _BreathingProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isBlowing && !_waveController.isAnimating) {
      _waveController.repeat(reverse: true);
    } else if (!widget.isBlowing && _waveController.isAnimating) {
      _waveController.stop();
      _waveController.value = 0;
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percent = (widget.progress * 100).round();

    return Center(
      child: SizedBox(
        width: 180,
        height: 180,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Wave/breathing rings
            AnimatedBuilder(
              animation: _waveController,
              builder: (context, _) {
                return Stack(
                  alignment: Alignment.center,
                  children: List.generate(3, (i) {
                    final delay = i * 0.33;
                    final progress = (_waveController.value + delay) % 1.0;
                    return Container(
                      width: 140 + (progress * 60),
                      height: 140 + (progress * 60),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary500
                              .withValues(alpha: 0.2 * (1.0 - progress)),
                          width: 2,
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
            // Main progress ring
            SizedBox(
              width: 140,
              height: 140,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: widget.progress),
                duration: const Duration(milliseconds: 200),
                builder: (context, value, _) {
                  return CircularProgressIndicator(
                    value: value,
                    strokeWidth: 10,
                    strokeCap: StrokeCap.round,
                    backgroundColor: AppColors.neutral100,
                    valueColor: const AlwaysStoppedAnimation(
                      AppColors.primary500,
                    ),
                  );
                },
              ),
            ),
            // Percent text
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary500.withValues(alpha: 0.1),
                    blurRadius: 16,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$percent%',
                    style: AppTextStyles.displayMedium.copyWith(
                      color: AppColors.primary700,
                    ),
                  ),
                  Text(
                    widget.isBlowing ? 'กำลังเป่า' : 'รอเริ่ม',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
