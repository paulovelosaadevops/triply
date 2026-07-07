import 'package:flutter/material.dart';
import 'package:triply/app/router/app_router.dart';
import 'package:triply/app/theme/design_tokens.dart';
import 'package:triply/core/components/app_card.dart';
import 'package:triply/core/components/primary_button.dart';
import 'package:triply/features/trips/domain/trip.dart';
import 'package:triply/features/trips/presentation/widgets/trip_summary_tile.dart';

class HomeNextTripCard extends StatelessWidget {
  const HomeNextTripCard({this.trip, super.key});

  final Trip? trip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<DesignTokens>() ?? DesignTokens.base;

    return AppCard(
      padding: EdgeInsets.all(tokens.spacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Sua próxima viagem', style: theme.textTheme.titleLarge),
          SizedBox(height: tokens.spacing.sm),
          if (trip == null)
            Text(
              'Nenhuma viagem cadastrada',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else
            TripSummaryTile(trip: trip!),
          SizedBox(height: tokens.spacing.xl),
          Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 180),
              child: PrimaryButton(
                label: 'Criar viagem',
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.createTrip);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
