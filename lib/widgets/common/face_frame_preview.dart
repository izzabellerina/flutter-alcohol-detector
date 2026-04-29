import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Mock camera preview พร้อมกรอบใบหน้า — ตอน Phase 5+ จะเปลี่ยนเป็น
/// `CameraPreview` จริงพร้อม google_mlkit_face_detection
class FaceFramePreview extends StatelessWidget {
  const FaceFramePreview({
    super.key,
    required this.faceInFrame,
    this.aspectRatio = 3 / 4,
  });

  final bool faceInFrame;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        faceInFrame ? AppColors.success : AppColors.danger;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.textPrimary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Mock camera view
            Center(
              child: Icon(
                Icons.person,
                size: 120,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
            // Face frame overlay
            Padding(
              padding: const EdgeInsets.all(24),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor, width: 4),
                  borderRadius: BorderRadius.circular(120),
                ),
              ),
            ),
            if (!faceInFrame)
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.danger,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'ขยับใบหน้าให้อยู่ในกรอบ',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
