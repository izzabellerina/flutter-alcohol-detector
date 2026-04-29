import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// Mock camera preview พร้อมกรอบใบหน้า
/// - Breathing pulse เมื่อ face in frame
/// - Shake + แดงเมื่อ face out of frame
class FaceFramePreview extends StatefulWidget {
  const FaceFramePreview({
    super.key,
    required this.faceInFrame,
    this.aspectRatio = 4 / 5,
  });

  final bool faceInFrame;
  final double aspectRatio;

  @override
  State<FaceFramePreview> createState() => _FaceFramePreviewState();
}

class _FaceFramePreviewState extends State<FaceFramePreview>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void didUpdateWidget(covariant FaceFramePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.faceInFrame && !widget.faceInFrame) {
      _shakeController.repeat(reverse: true);
    } else if (!oldWidget.faceInFrame && widget.faceInFrame) {
      _shakeController.stop();
      _shakeController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor =
        widget.faceInFrame ? AppColors.primary500 : AppColors.danger500;

    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.neutral900,
          borderRadius: AppRadius.all(AppRadius.lg),
          gradient: const RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [AppColors.neutral800, AppColors.neutral950],
          ),
        ),
        child: ClipRRect(
          borderRadius: AppRadius.all(AppRadius.lg),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Mock camera silhouette
              Center(
                child: Icon(
                  Icons.person,
                  size: 160,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
              ),
              // Animated face frame overlay
              AnimatedBuilder(
                animation: Listenable.merge([_pulseController, _shakeController]),
                builder: (context, _) {
                  final pulse = widget.faceInFrame
                      ? 1.0 + (_pulseController.value * 0.04)
                      : 1.0;
                  final shake = widget.faceInFrame
                      ? 0.0
                      : (_shakeController.value - 0.5) * 16;
                  return Transform.translate(
                    offset: Offset(shake, 0),
                    child: Transform.scale(
                      scale: pulse,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          decoration: BoxDecoration(
                            border: Border.all(color: borderColor, width: 4),
                            borderRadius: AppRadius.all(AppRadius.xl * 4),
                            boxShadow: [
                              BoxShadow(
                                color: borderColor.withValues(alpha: 0.3),
                                blurRadius: 24,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              // Warning overlay
              if (!widget.faceInFrame)
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.lg),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: 1.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md + 2,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.danger600,
                          borderRadius: AppRadius.all(AppRadius.pill),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.danger500.withValues(alpha: 0.5),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.warning_amber_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: AppSpacing.xs + 2),
                            Text(
                              'ขยับใบหน้าให้อยู่ในกรอบ',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textOnPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
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
