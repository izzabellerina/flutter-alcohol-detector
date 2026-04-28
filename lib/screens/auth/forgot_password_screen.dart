import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/app_buttons.dart';
import '../../widgets/common/app_footer.dart';
import '../../widgets/common/app_logo.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _contactController = TextEditingController();

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text('ลืมรหัสผ่าน', style: AppTextStyles.headingSmall),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              const AppLogo(),
              const SizedBox(height: 40),
              TextField(
                controller: _contactController,
                decoration: const InputDecoration(
                  hintText: 'หมายเลขโทรศัพท์/อีเมล์',
                ),
              ),
              const SizedBox(height: 16),
              AppButton.primary(
                label: 'รับ OTP',
                onPressed: () {
                  // TODO: implement OTP flow ใน Phase 2
                },
              ),
              const Spacer(),
              const AppFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
