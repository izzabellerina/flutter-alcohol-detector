import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/date_formatter.dart';

/// Circular progress ring + เวลานับถอยหลังตรงกลาง
/// เปลี่ยนเป็นสีแดงเมื่อใกล้หมดเวลา (< [warningThresholdSeconds])
class CountdownRing extends StatelessWidget {
  const CountdownRing({
    super.key,
    required this.secondsLeft,
    required this.totalSeconds,
    this.size = 96,
    this.warningThresholdSeconds = 30,
  });

  final int secondsLeft;
  final int totalSeconds;
  final double size;
  final int warningThresholdSeconds;

  @override
  Widget build(BuildContext context) {
    final progress = totalSeconds == 0 ? 0.0 : secondsLeft / totalSeconds;
    final isWarning =
        secondsLeft <= warningThresholdSeconds && secondsLeft > 0;
    final isExpired = secondsLeft <= 0;

    final ringColor = isExpired
        ? AppColors.danger500
        : isWarning
            ? AppColors.warning500
            : AppColors.primary500;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: progress, end: progress),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, _) {
                return CircularProgressIndicator(
                  value: value,
                  strokeWidth: 6,
                  backgroundColor: AppColors.neutral200,
                  valueColor: AlwaysStoppedAnimation(ringColor),
                  strokeCap: StrokeCap.round,
                );
              },
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isExpired
                    ? '0:00'
                    : DateFormatter.formatCountdown(secondsLeft),
                style: AppTextStyles.headingMedium.copyWith(
                  color: ringColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                isExpired ? 'หมดอายุ' : 'นาที',
                style: AppTextStyles.caption.copyWith(color: ringColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
