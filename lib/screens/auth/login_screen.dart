import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common/app_footer.dart';
import '../../widgets/common/app_logo.dart';
import '../../widgets/common/auth_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'กรุณากรอก Username';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอก Password';
    }
    return null;
  }

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);
    // TODO: เรียก API ยืนยันตัวตนใน Phase 2 (API integration)
    await Future<void>.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;
    setState(() => _isSubmitting = false);
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AuthBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: AppSpacing.xxl),
                    const AppLogo(showSubtitle: false),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'ระบบบันทึกการวัดระดับแอลกอฮอล์',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headingMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'เข้าสู่ระบบเพื่อเริ่มต้นการทดสอบ',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    TextFormField(
                      controller: _usernameController,
                      validator: _validateUsername,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: AppColors.textSecondary,
                        ),
                        floatingLabelStyle: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary700,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      validator: _validatePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.textSecondary,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () {
                            setState(
                              () => _obscurePassword = !_obscurePassword,
                            );
                          },
                        ),
                        floatingLabelStyle: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary700,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () =>
                            context.push(AppRoutes.forgotPassword),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                          ),
                        ),
                        child: Text(
                          'ลืมรหัสผ่าน?',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary700,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _GradientLoginButton(
                      isLoading: _isSubmitting,
                      onPressed: _isSubmitting ? null : _login,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const AppFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ปุ่ม "เข้าสู่ระบบ" สี gradient + arrow icon
class _GradientLoginButton extends StatelessWidget {
  const _GradientLoginButton({required this.isLoading, this.onPressed});

  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary500, AppColors.primary700],
          ),
          borderRadius: AppRadius.all(AppRadius.md),
          boxShadow: onPressed == null
              ? null
              : [
                  BoxShadow(
                    color: AppColors.primary500.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: AppRadius.all(AppRadius.md),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'เข้าสู่ระบบ',
                          style: AppTextStyles.button,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
