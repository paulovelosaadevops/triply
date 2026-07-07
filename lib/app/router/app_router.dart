import 'package:flutter/material.dart';
import 'package:triply/features/authentication/presentation/pages/forgot_password_page.dart';
import 'package:triply/features/authentication/presentation/pages/login_page.dart';
import 'package:triply/features/authentication/presentation/pages/sign_up_page.dart';
import 'package:triply/features/home/presentation/pages/home_dashboard_page.dart';
import 'package:triply/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:triply/features/splash/presentation/pages/splash_page.dart';
import 'package:triply/features/trips/domain/trip.dart';
import 'package:triply/features/trips/presentation/modules/pages/checklist_module_page.dart';
import 'package:triply/features/trips/presentation/modules/pages/documents_module_page.dart';
import 'package:triply/features/trips/presentation/modules/pages/expenses_module_page.dart';
import 'package:triply/features/trips/presentation/modules/pages/flights_module_page.dart';
import 'package:triply/features/trips/presentation/modules/pages/itinerary_module_page.dart';
import 'package:triply/features/trips/presentation/modules/pages/lodging_module_page.dart';
import 'package:triply/features/trips/presentation/pages/create_trip_page.dart';
import 'package:triply/features/trips/presentation/pages/trip_details_page.dart';

class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';
  static const String homeDashboard = '/home';
  static const String createTrip = '/trips/create';
  static const String tripDetails = '/trips/details';
  static const String itinerary = '/trips/itinerary';
  static const String flights = '/trips/flights';
  static const String lodging = '/trips/lodging';
  static const String documents = '/trips/documents';
  static const String expenses = '/trips/expenses';
  static const String checklist = '/trips/checklist';
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
      AppRoutes.createTrip => _pageRoute(settings, const CreateTripPage()),
      AppRoutes.tripDetails => _tripDetailsRoute(settings),
      AppRoutes.itinerary => _tripModuleRoute(
        settings,
        (trip) => ItineraryModulePage(trip: trip),
      ),
      AppRoutes.flights => _tripModuleRoute(
        settings,
        (trip) => FlightsModulePage(trip: trip),
      ),
      AppRoutes.lodging => _tripModuleRoute(
        settings,
        (trip) => LodgingModulePage(trip: trip),
      ),
      AppRoutes.documents => _tripModuleRoute(
        settings,
        (trip) => DocumentsModulePage(trip: trip),
      ),
      AppRoutes.expenses => _tripModuleRoute(
        settings,
        (trip) => ExpensesModulePage(trip: trip),
      ),
      AppRoutes.checklist => _tripModuleRoute(
        settings,
        (trip) => ChecklistModulePage(trip: trip),
      ),
      _ => null,
    };
  }

  static Route<dynamic>? _tripDetailsRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    if (arguments is! Trip) {
      return null;
    }

    return _pageRoute(settings, TripDetailsPage(trip: arguments));
  }

  static Route<dynamic>? _tripModuleRoute(
    RouteSettings settings,
    Widget Function(Trip trip) builder,
  ) {
    final arguments = settings.arguments;
    if (arguments is! Trip) {
      return null;
    }

    return _pageRoute(settings, builder(arguments));
  }

  static MaterialPageRoute<void> _pageRoute(
    RouteSettings settings,
    Widget page,
  ) {
    return MaterialPageRoute<void>(builder: (_) => page, settings: settings);
  }
}
