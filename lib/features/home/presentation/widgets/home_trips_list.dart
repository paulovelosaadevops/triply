import 'package:flutter/material.dart';
import 'package:triply/app/theme/design_tokens.dart';
import 'package:triply/core/components/app_card.dart';
import 'package:triply/core/components/section_title.dart';
import 'package:triply/features/trips/domain/trip.dart';
import 'package:triply/features/trips/presentation/widgets/trip_summary_tile.dart';

class HomeTripsList extends StatelessWidget {
  const HomeTripsList({required this.trips, super.key});

  final List<Trip> trips;

  @override
  Widget build(BuildContext context) {
    final tokens =
        Theme.of(context).extension<DesignTokens>() ?? DesignTokens.base;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SectionTitle(title: 'Minhas viagens'),
        SizedBox(height: tokens.spacing.lg),
        ...trips.map(
          (trip) => Padding(
            padding: EdgeInsets.only(bottom: tokens.spacing.md),
            child: AppCard(
              padding: EdgeInsets.all(tokens.spacing.lg),
              child: TripSummaryTile(trip: trip),
            ),
          ),
        ),
      ],
    );
  }
}
