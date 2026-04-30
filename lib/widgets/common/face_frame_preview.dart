import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// "ภาพ" ของผู้ทดสอบขณะเป่า — กรอบรูปสไตล์ photo frame
/// (Phase 5+ จะเปลี่ยนเป็น `CameraPreview` จริงพร้อม google_mlkit_face_detection)
///
/// - In-frame: กรอบบางสีน้ำเงินอ่อน (ตาม Design Update 2026-04-30)
/// - Out-of-frame: กรอบแดง + warning badge + shake animation
class FaceFramePreview extends StatefulWidget {
  const FaceFramePreview({
    super.key,
    required this.faceInFrame,
    this.aspectRatio = 4 / 3,
  });

  final bool faceInFrame;
  final double aspectRatio;

  @override
  State<FaceFramePreview> createState() => _FaceFramePreviewState();
}

class _FaceFramePreviewState extends State<FaceFramePreview>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
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
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final outOfFrame = !widget.faceInFrame;
    final borderColor =
        outOfFrame ? AppColors.danger500 : AppColors.primary200;
    final borderWidth = outOfFrame ? 3.0 : 2.0;

    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: AnimatedBuilder(
        animation: _shakeController,
        builder: (context, child) {
          final shake = outOfFrame
              ? (_shakeController.value - 0.5) * 12
              : 0.0;
          return Transform.translate(
            offset: Offset(shake, 0),
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: AppColors.neutral200,
            borderRadius: AppRadius.all(AppRadius.lg),
            border: Border.all(color: borderColor, width: borderWidth),
            boxShadow: outOfFrame
                ? [
                    BoxShadow(
                      color: AppColors.danger500.withValues(alpha: 0.2),
                      blurRadius: 16,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: AppRadius.all(AppRadius.lg - 2),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Photo placeholder (mock — รอกล้องจริง)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.neutral200,
                        AppColors.neutral300,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.person,
                    size: 140,
                    color: AppColors.neutral400.withValues(alpha: 0.5),
                  ),
                ),
                // Warning overlay
                if (outOfFrame)
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.md),
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
                              color: AppColors.danger500
                                  .withValues(alpha: 0.5),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
