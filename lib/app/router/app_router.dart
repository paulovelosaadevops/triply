import 'package:flutter/material.dart';
import 'package:triply/features/onboarding/presentation/pages/authentication_placeholder_page.dart';
import 'package:triply/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:triply/features/splash/presentation/pages/splash_page.dart';

class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String authenticationPlaceholder = '/authentication-placeholder';
}

class AppRouter {
  const AppRouter._();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    return switch (settings.name) {
      AppRoutes.splash => _pageRoute(settings, const SplashPage()),
      AppRoutes.onboarding => _pageRoute(settings, const OnboardingPage()),
      AppRoutes.authenticationPlaceholder => _pageRoute(
        settings,
        const AuthenticationPlaceholderPage(),
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
