import 'package:flutter/material.dart';
import 'package:triply/app/theme/design_tokens.dart';
import 'package:triply/features/home/presentation/models/home_quick_action.dart';
import 'package:triply/features/home/presentation/widgets/home_bottom_navigation.dart';
import 'package:triply/features/home/presentation/widgets/home_empty_trips.dart';
import 'package:triply/features/home/presentation/widgets/home_header.dart';
import 'package:triply/features/home/presentation/widgets/home_next_trip_card.dart';
import 'package:triply/features/home/presentation/widgets/home_quick_actions.dart';
import 'package:triply/features/home/presentation/widgets/home_trips_list.dart';
import 'package:triply/features/trips/data/trip_local_repository.dart';

class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({super.key});

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  static const List<HomeQuickAction> _quickActions = <HomeQuickAction>[
    HomeQuickAction(icon: Icons.flight_rounded, label: 'Voos'),
    HomeQuickAction(icon: Icons.hotel_rounded, label: 'Hospedagem'),
    HomeQuickAction(icon: Icons.route_rounded, label: 'Roteiros'),
    HomeQuickAction(icon: Icons.payments_rounded, label: 'Gastos'),
  ];

  final TripLocalRepository _tripRepository = TripLocalRepository.instance;

  @override
  void initState() {
    super.initState();
    _tripRepository.addListener(_handleTripsChanged);
  }

  @override
  void dispose() {
    _tripRepository.removeListener(_handleTripsChanged);
    super.dispose();
  }

  void _handleTripsChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<DesignTokens>() ?? DesignTokens.base;
    final trips = _tripRepository.trips;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      bottomNavigationBar: const HomeBottomNavigation(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                tokens.spacing.xl,
                tokens.spacing.xl,
                tokens.spacing.xl,
                tokens.spacing.xxl,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const HomeHeader(),
                    SizedBox(height: tokens.spacing.xxl),
                    HomeNextTripCard(trip: _tripRepository.nextTrip),
                    SizedBox(height: tokens.spacing.xxl),
                    HomeQuickActions(actions: _quickActions),
                    SizedBox(height: tokens.spacing.xxl),
                    trips.isEmpty
                        ? const HomeEmptyTrips()
                        : HomeTripsList(trips: trips),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
