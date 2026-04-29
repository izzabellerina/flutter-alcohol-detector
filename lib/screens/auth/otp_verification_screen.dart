import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/auth_models.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common/app_buttons.dart';
import '../../widgets/common/app_footer.dart';
import '../../widgets/common/auth_background.dart';
import '../../widgets/common/auth_step_indicator.dart';
import '../../widgets/common/countdown_ring.dart';
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
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text('ยืนยัน OTP', style: AppTextStyles.headingSmall),
      ),
      extendBodyBehindAppBar: true,
      body: AuthBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.lg),
                const AuthStepIndicator(
                  currentStep: 2,
                  totalSteps: 3,
                  label: 'ยืนยัน OTP',
                ),
                const SizedBox(height: AppSpacing.xl),
                CountdownRing(
                  secondsLeft: _secondsLeft,
                  totalSeconds: AppConstants.otpExpirySeconds,
                  size: 110,
                ),
                const SizedBox(height: AppSpacing.lg),
                _DestinationCard(
                  isPhone: isPhone,
                  destinationLabel: widget.request.destinationLabel,
                  referenceCode: widget.request.referenceCode,
                  extraNote: extraNote,
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'กรอก OTP ที่ได้รับจาก ${isPhone ? 'SMS' : 'Email'}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                OtpInputField(
                  onChanged: (value) => setState(() => _otp = value),
                  onCompleted: (_) => _verifyOtp(),
                ),
                const SizedBox(height: AppSpacing.xl),
                AppButton.primary(
                  label: 'ยืนยัน OTP',
                  icon: Icons.verified_outlined,
                  onPressed: _otp.length == 6 && _secondsLeft > 0
                      ? _verifyOtp
                      : null,
                ),
                const SizedBox(height: AppSpacing.xs),
                TextButton.icon(
                  onPressed: _resendOtp,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: Text(
                    'ขอรหัสใหม่อีกครั้ง',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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

class _DestinationCard extends StatelessWidget {
  const _DestinationCard({
    required this.isPhone,
    required this.destinationLabel,
    required this.referenceCode,
    this.extraNote,
  });

  final bool isPhone;
  final String destinationLabel;
  final String referenceCode;
  final String? extraNote;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.all(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isPhone ? Icons.sms_outlined : Icons.email_outlined,
                size: 18,
                color: AppColors.primary600,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'ส่ง OTP ไปยัง$destinationLabel',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text('รหัสอ้างอิง: ', style: AppTextStyles.bodySmall),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: AppRadius.all(AppRadius.sm),
                ),
                child: Text(
                  referenceCode,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary700,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          if (extraNote != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 14,
                  color: AppColors.warning500,
                ),
                const SizedBox(width: AppSpacing.xs + 2),
                Expanded(
                  child: Text(
                    extraNote!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.warning700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
