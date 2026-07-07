import 'package:flutter/material.dart';
import 'package:triply/features/authentication/presentation/pages/forgot_password_page.dart';
import 'package:triply/features/authentication/presentation/pages/login_page.dart';
import 'package:triply/features/authentication/presentation/pages/sign_up_page.dart';
import 'package:triply/features/home/presentation/pages/home_dashboard_page.dart';
import 'package:triply/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:triply/features/splash/presentation/pages/splash_page.dart';

class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';
  static const String homeDashboard = '/home';
}

class AppRouter {
  const AppRouter._();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    return switch (settings.name) {
      AppRoutes.splash => _pageRoute(settings, const SplashPage()),
      AppRoutes.onboarding => _pageRoute(settings, const OnboardingPage()),
      AppRoutes.login => _pageRoute(settings, const LoginPage()),
      AppRoutes.signUp => _pageRoute(settings, const SignUpPage()),
      AppRoutes.forgotPassword => _pageRoute(
        settings,
        const ForgotPasswordPage(),
      ),
      AppRoutes.homeDashboard => _pageRoute(
        settings,
        const HomeDashboardPage(),
      ),
      _ => null,
    };
  }

  static MaterialPageRoute<void> _pageRoute(
    RouteSettings settings,
    Widget page,
  ) {
    return MaterialPageRoute<void>(builder: (_) => page, settings: settings);
  }
}
