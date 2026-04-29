import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common/app_buttons.dart';
import '../../widgets/common/app_footer.dart';
import '../../widgets/common/app_logo.dart';

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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text('ตั้งรหัสใหม่', style: AppTextStyles.headingSmall),
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
                  controller: _newPasswordController,
                  obscureText: _obscureNew,
                  validator: _validateNewPassword,
                  decoration: InputDecoration(
                    hintText: 'New Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNew ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () =>
                          setState(() => _obscureNew = !_obscureNew),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _rePasswordController,
                  obscureText: _obscureRe,
                  validator: _validateRePassword,
                  decoration: InputDecoration(
                    hintText: 'Re Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureRe ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () =>
                          setState(() => _obscureRe = !_obscureRe),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                AppButton.primary(
                  label: 'บันทึก',
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
