import 'package:flutter/material.dart';
import 'package:triply/features/splash/presentation/pages/splash_page.dart';
import 'package:triply/features/splash/presentation/pages/splash_placeholder_page.dart';

class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String splashPlaceholder = '/splash-placeholder';
}

class AppRouter {
  const AppRouter._();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    return switch (settings.name) {
      AppRoutes.splash => _pageRoute(settings, const SplashPage()),
      AppRoutes.splashPlaceholder => _pageRoute(
        settings,
        const SplashPlaceholderPage(),
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
