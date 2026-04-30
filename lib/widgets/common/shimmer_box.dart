import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';

/// กรอบ skeleton loading พร้อม shimmer effect
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
  });

  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.neutral200,
      highlightColor: AppColors.neutral100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.neutral200,
          borderRadius: borderRadius ?? AppRadius.all(AppRadius.sm),
        ),
      ),
    );
  }
}
