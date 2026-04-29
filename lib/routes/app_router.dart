import 'package:go_router/go_router.dart';
import '../models/auth_models.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/otp_verification_screen.dart';
import '../screens/auth/reset_password_screen.dart';
import '../screens/home/driver_confirmation_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/test/test_in_progress_screen.dart';
import '../screens/test/test_ready_screen.dart';
import '../screens/test/test_result_screen.dart';
import '../services/card_reader_service.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.otpPhone,
        name: 'otpPhone',
        builder: (context, state) {
          final request = state.extra as OtpRequest?;
          return OtpVerificationScreen(
            request: request ??
                const OtpRequest(
                  contactType: ContactType.phone,
                  maskedContact: '',
                  referenceCode: '',
                ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.otpEmail,
        name: 'otpEmail',
        builder: (context, state) {
          final request = state.extra as OtpRequest?;
          return OtpVerificationScreen(
            request: request ??
                const OtpRequest(
                  contactType: ContactType.email,
                  maskedContact: '',
                  referenceCode: '',
                ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        name: 'resetPassword',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.driverConfirm,
        name: 'driverConfirm',
        builder: (context, state) {
          final driver = state.extra as DriverInfo?;
          if (driver == null) {
            return const HomeScreen();
          }
          return DriverConfirmationScreen(driver: driver);
        },
      ),
      GoRoute(
        path: AppRoutes.testReady,
        name: 'testReady',
        builder: (context, state) => const TestReadyScreen(),
      ),
      GoRoute(
        path: AppRoutes.testInProgress,
        name: 'testInProgress',
        builder: (context, state) => const TestInProgressScreen(),
      ),
      GoRoute(
        path: AppRoutes.testComplete,
        name: 'testComplete',
        builder: (context, state) => const TestResultScreen(),
      ),
    ],
  );
}
