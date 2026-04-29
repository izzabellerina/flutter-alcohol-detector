class AppConstants {
  AppConstants._();

  static const String appName = 'ระบบบันทึกการวัดระดับแอลกอฮอล์';

  // Threshold ระดับการแจ้งเตือนแอลกอฮอล์ (mg%)
  static const double alcoholThreshold = 3.0;

  // OTP มีอายุ 5 นาที
  static const int otpExpirySeconds = 5 * 60;
}
