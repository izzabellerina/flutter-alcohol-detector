import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/auth_models.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common/app_buttons.dart';
import '../../widgets/common/app_footer.dart';
import '../../widgets/common/app_logo.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contactController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  String? _validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'กรุณากรอกหมายเลขโทรศัพท์หรืออีเมล์';
    }
    if (ContactValidator.detect(value) == null) {
      return 'รูปแบบไม่ถูกต้อง';
    }
    return null;
  }

  String _generateReferenceCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ123456789';
    final random = Random();
    return List.generate(5, (_) => chars[random.nextInt(chars.length)]).join();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final input = _contactController.text.trim();
    final type = ContactValidator.detect(input)!;
    setState(() => _isSubmitting = true);

    // TODO: เรียก API ส่ง OTP ใน Phase 2 (API integration)
    await Future<void>.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    final request = OtpRequest(
      contactType: type,
      maskedContact: type == ContactType.phone
          ? ContactValidator.maskPhone(input)
          : ContactValidator.maskEmail(input),
      referenceCode: _generateReferenceCode(),
    );

    setState(() => _isSubmitting = false);

    final route = type == ContactType.phone
        ? AppRoutes.otpPhone
        : AppRoutes.otpEmail;
    context.push(route, extra: request);
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Spacer(),
                const AppLogo(),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _contactController,
                  validator: _validate,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'หมายเลขโทรศัพท์/อีเมล์',
                  ),
                ),
                const SizedBox(height: 16),
                AppButton.primary(
                  label: 'รับ OTP',
                  onPressed: _isSubmitting ? null : _submit,
                  isLoading: _isSubmitting,
                ),
                const Spacer(),
                const AppFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
