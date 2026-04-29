import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// พื้นหลัง gradient อ่อน ๆ สำหรับหน้า Auth ทั้งหมด
class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary50,
            AppColors.background,
            AppColors.background,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.4, 1.0],
        ),
      ),
      child: child,
    );
  }
}
