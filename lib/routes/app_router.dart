import 'package:flutter/material.dart';
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

/// Slide จากขวา + fade — สำหรับการกด "next/forward"
CustomTransitionPage<T> _slidePage<T>({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slide = Tween<Offset>(
        begin: const Offset(0.06, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}

/// Fade + scale เบา ๆ — สำหรับ result/destination
CustomTransitionPage<T> _fadeScalePage<T>({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 320),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final scale = Tween<double>(begin: 0.97, end: 1.0).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
      );
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(scale: scale, child: child),
      );
    },
  );
}

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        pageBuilder: (context, state) => _fadeScalePage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        pageBuilder: (context, state) => _slidePage(
          key: state.pageKey,
          child: const ForgotPasswordScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.otpPhone,
        name: 'otpPhone',
        pageBuilder: (context, state) {
          final request = state.extra as OtpRequest?;
          return _slidePage(
            key: state.pageKey,
            child: OtpVerificationScreen(
              request: request ??
                  const OtpRequest(
                    contactType: ContactType.phone,
                    maskedContact: '',
                    referenceCode: '',
                  ),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.otpEmail,
        name: 'otpEmail',
        pageBuilder: (context, state) {
          final request = state.extra as OtpRequest?;
          return _slidePage(
            key: state.pageKey,
            child: OtpVerificationScreen(
              request: request ??
                  const OtpRequest(
                    contactType: ContactType.email,
                    maskedContact: '',
                    referenceCode: '',
                  ),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        name: 'resetPassword',
        pageBuilder: (context, state) => _slidePage(
          key: state.pageKey,
          child: const ResetPasswordScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => _fadeScalePage(
          key: state.pageKey,
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.driverConfirm,
        name: 'driverConfirm',
        pageBuilder: (context, state) {
          final driver = state.extra as DriverInfo?;
          return _slidePage(
            key: state.pageKey,
            child: driver == null
                ? const HomeScreen()
                : DriverConfirmationScreen(driver: driver),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.testReady,
        name: 'testReady',
        pageBuilder: (context, state) => _slidePage(
          key: state.pageKey,
          child: const TestReadyScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.testInProgress,
        name: 'testInProgress',
        pageBuilder: (context, state) => _fadeScalePage(
          key: state.pageKey,
          child: const TestInProgressScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.testComplete,
        name: 'testComplete',
        pageBuilder: (context, state) => _fadeScalePage(
          key: state.pageKey,
          child: const TestResultScreen(),
        ),
      ),
    ],
  );
}
