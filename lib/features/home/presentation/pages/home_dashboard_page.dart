import 'package:flutter/material.dart';
import 'package:triply/app/theme/design_tokens.dart';
import 'package:triply/features/home/presentation/models/home_quick_action.dart';
import 'package:triply/features/home/presentation/widgets/home_bottom_navigation.dart';
import 'package:triply/features/home/presentation/widgets/home_empty_trips.dart';
import 'package:triply/features/home/presentation/widgets/home_header.dart';
import 'package:triply/features/home/presentation/widgets/home_next_trip_card.dart';
import 'package:triply/features/home/presentation/widgets/home_quick_actions.dart';

class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({super.key});

  static const List<HomeQuickAction> _quickActions = <HomeQuickAction>[
    HomeQuickAction(icon: Icons.flight_rounded, label: 'Voos'),
    HomeQuickAction(icon: Icons.hotel_rounded, label: 'Hospedagem'),
    HomeQuickAction(icon: Icons.route_rounded, label: 'Roteiros'),
    HomeQuickAction(icon: Icons.payments_rounded, label: 'Gastos'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<DesignTokens>() ?? DesignTokens.base;

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
                    const HomeNextTripCard(),
                    SizedBox(height: tokens.spacing.xxl),
                    HomeQuickActions(actions: _quickActions),
                    SizedBox(height: tokens.spacing.xxl),
                    const HomeEmptyTrips(),
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
