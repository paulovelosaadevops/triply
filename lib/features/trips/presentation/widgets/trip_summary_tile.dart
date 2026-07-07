import 'package:flutter/material.dart';
import 'package:triply/app/theme/design_tokens.dart';
import 'package:triply/features/trips/domain/trip.dart';
import 'package:triply/features/trips/presentation/widgets/trip_text_formatters.dart';

class TripSummaryTile extends StatelessWidget {
  const TripSummaryTile({required this.trip, super.key});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<DesignTokens>() ?? DesignTokens.base;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(tokens.radius.lg),
          ),
          child: Padding(
            padding: EdgeInsets.all(tokens.spacing.md),
            child: Icon(
              Icons.luggage_rounded,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        SizedBox(width: tokens.spacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(trip.title, style: theme.textTheme.titleMedium),
              SizedBox(height: tokens.spacing.xs),
              Text(
                trip.destination,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: tokens.spacing.xs),
              Text(
                '${TripTextFormatters.dateRange(trip)} • ${TripTextFormatters.travelers(trip.travelers)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
