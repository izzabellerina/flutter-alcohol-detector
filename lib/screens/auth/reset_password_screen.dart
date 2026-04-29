import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common/app_buttons.dart';
import '../../widgets/common/app_footer.dart';
import '../../widgets/common/auth_background.dart';
import '../../widgets/common/auth_step_indicator.dart';
import '../../widgets/common/password_strength_meter.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _rePasswordController = TextEditingController();

  bool _obscureNew = true;
  bool _obscureRe = true;
  bool _isSubmitting = false;
  String _newPassword = '';
  String _rePassword = '';

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(() {
      setState(() => _newPassword = _newPasswordController.text);
    });
    _rePasswordController.addListener(() {
      setState(() => _rePassword = _rePasswordController.text);
    });
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณาตั้งรหัสผ่านใหม่';
    }
    if (value.length < 8) {
      return 'รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษร';
    }
    return null;
  }

  String? _validateRePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณายืนยันรหัสผ่าน';
    }
    if (value != _newPasswordController.text) {
      return 'รหัสผ่านไม่ตรงกัน';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);
    // TODO: เรียก API บันทึกรหัสผ่านใหม่ใน Phase 2 (API integration)
    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ตั้งรหัสผ่านใหม่เรียบร้อย')),
    );
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final passwordsMatch = _newPassword.isNotEmpty &&
        _newPassword == _rePassword;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text('ตั้งรหัสใหม่', style: AppTextStyles.headingSmall),
      ),
      extendBodyBehindAppBar: true,
      body: AuthBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  const AuthStepIndicator(
                    currentStep: 3,
                    totalSteps: 3,
                    label: 'ตั้งรหัสใหม่',
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.primary50,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.shield_outlined,
                      size: 40,
                      color: AppColors.primary600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'ตั้งรหัสผ่านใหม่',
                    style: AppTextStyles.headingMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'รหัสผ่านควรมีอย่างน้อย 8 ตัวอักษร ผสมตัวพิมพ์ใหญ่ ตัวเลข และอักขระพิเศษ',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: _obscureNew,
                    validator: _validateNewPassword,
                    decoration: InputDecoration(
                      labelText: 'รหัสผ่านใหม่',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: AppColors.textSecondary,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNew
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () =>
                            setState(() => _obscureNew = !_obscureNew),
                      ),
                      floatingLabelStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary700,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  PasswordStrengthMeter(password: _newPassword),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _rePasswordController,
                    obscureText: _obscureRe,
                    validator: _validateRePassword,
                    decoration: InputDecoration(
                      labelText: 'ยืนยันรหัสผ่าน',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: AppColors.textSecondary,
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_rePassword.isNotEmpty)
                            Icon(
                              passwordsMatch
                                  ? Icons.check_circle
                                  : Icons.cancel_outlined,
                              size: 20,
                              color: passwordsMatch
                                  ? AppColors.primary500
                                  : AppColors.danger500,
                            ),
                          IconButton(
                            icon: Icon(
                              _obscureRe
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () =>
                                setState(() => _obscureRe = !_obscureRe),
                          ),
                        ],
                      ),
                      floatingLabelStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary700,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton.primary(
                    label: 'บันทึก',
                    icon: Icons.save_outlined,
                    onPressed: _isSubmitting ? null : _submit,
                    isLoading: _isSubmitting,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const AppFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
