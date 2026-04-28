import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_text_styles.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key, this.version});

  final String? version;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Text(
          'Version ${version ?? AppConstants.appVersion}',
          style: AppTextStyles.version,
        ),
      ),
    );
  }
}
