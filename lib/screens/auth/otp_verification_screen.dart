import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/date_formatter.dart';
import '../../models/auth_models.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common/app_buttons.dart';
import '../../widgets/common/app_footer.dart';
import '../../widgets/common/app_logo.dart';
import '../../widgets/common/otp_input_field.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key, required this.request});

  final OtpRequest request;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  Timer? _timer;
  int _secondsLeft = AppConstants.otpExpirySeconds;
  String _otp = '';

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsLeft = AppConstants.otpExpirySeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _resendOtp() {
    // TODO: เรียก API ขอ OTP ใหม่ใน Phase 2 (API integration)
    _startCountdown();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ส่งรหัส OTP ใหม่แล้ว')),
    );
  }

  void _verifyOtp() {
    if (_otp.length != 6) return;
    // TODO: เรียก API ตรวจสอบ OTP ใน Phase 2 (API integration)
    context.push(AppRoutes.resetPassword);
  }

  @override
  Widget build(BuildContext context) {
    final isPhone = widget.request.contactType == ContactType.phone;
    final extraNote = isPhone
        ? null
        : 'หากไม่ได้รับอีเมล์ให้ดูในอีเมล์ขยะ';

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
              const SizedBox(height: 24),
              const AppLogo(),
              const SizedBox(height: 32),
              Text(
                'OTP ถูกส่งไปยัง${widget.request.destinationLabel}',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'รหัส OTP ของคุณมีอายุ 5 นาที หลังจากที่คุณได้รับรหัส',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 4),
              Text(
                'รหัสอ้างอิง: ${widget.request.referenceCode}',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall,
              ),
              if (extraNote != null) ...[
                const SizedBox(height: 8),
                Text(
                  extraNote,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.warning,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Text(
                'กรอก OTP ที่ได้รับจาก ${isPhone ? 'SMS' : 'Email'}',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 12),
              OtpInputField(
                onChanged: (value) => setState(() => _otp = value),
                onCompleted: (_) => _verifyOtp(),
              ),
              const SizedBox(height: 16),
              Text(
                _secondsLeft > 0
                    ? 'ยืนยัน OTP ใน ${DateFormatter.formatCountdown(_secondsLeft)}'
                    : 'รหัส OTP หมดอายุแล้ว',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: _secondsLeft > 0
                      ? AppColors.textPrimary
                      : AppColors.danger,
                ),
              ),
              const SizedBox(height: 16),
              AppButton.primary(
                label: 'ยืนยัน OTP',
                onPressed: _otp.length == 6 && _secondsLeft > 0
                    ? _verifyOtp
                    : null,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _resendOtp,
                child: Text(
                  'ขอรหัสใหม่อีกครั้ง',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
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
