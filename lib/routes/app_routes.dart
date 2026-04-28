class AppRoutes {
  AppRoutes._();

  // Authentication
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String otpPhone = '/otp/phone';
  static const String otpEmail = '/otp/email';
  static const String resetPassword = '/reset-password';

  // Main
  static const String home = '/home';
  static const String driverConfirm = '/driver-confirm';

  // Test
  static const String testReady = '/test/ready';
  static const String testInProgress = '/test/in-progress';
  static const String testComplete = '/test/complete';

  // Result
  static const String resultPass = '/result/pass';
  static const String resultFailAlcohol = '/result/fail-alcohol';
  static const String resultFailFace = '/result/fail-face';
}
