import 'package:flutter/material.dart';
import 'package:triply/app/theme/design_tokens.dart';
import 'package:triply/core/components/app_card.dart';
import 'package:triply/features/trips/domain/trip.dart';
import 'package:triply/features/trips/presentation/widgets/trip_text_formatters.dart';

class TripHeroCard extends StatelessWidget {
  const TripHeroCard({required this.trip, super.key});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<DesignTokens>() ?? DesignTokens.base;

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16 / 9,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(tokens.radius.lg),
                ),
              ),
              child: Icon(
                Icons.landscape_rounded,
                color: theme.colorScheme.onPrimaryContainer,
                size: tokens.spacing.xxxl,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(tokens.spacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(trip.title, style: theme.textTheme.titleLarge),
                SizedBox(height: tokens.spacing.xs),
                Text(
                  trip.destination,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: tokens.spacing.sm),
                Text(
                  TripTextFormatters.dateRange(trip),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
