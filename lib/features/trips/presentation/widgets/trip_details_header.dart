import 'package:flutter/material.dart';
import 'package:triply/app/theme/design_tokens.dart';
import 'package:triply/features/trips/domain/trip.dart';
import 'package:triply/features/trips/presentation/widgets/trip_text_formatters.dart';

class TripDetailsHeader extends StatelessWidget {
  const TripDetailsHeader({required this.trip, super.key});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<DesignTokens>() ?? DesignTokens.base;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        SizedBox(height: tokens.spacing.lg),
        Text(trip.title, style: theme.textTheme.headlineLarge),
        SizedBox(height: tokens.spacing.xs),
        Text(
          trip.destination,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: tokens.spacing.lg),
        Wrap(
          spacing: tokens.spacing.sm,
          runSpacing: tokens.spacing.sm,
          children: <Widget>[
            _TripMetaChip(
              icon: Icons.calendar_today_rounded,
              label: TripTextFormatters.dateRange(trip),
            ),
            _TripMetaChip(
              icon: Icons.group_rounded,
              label: TripTextFormatters.travelers(trip.travelers),
            ),
            _TripMetaChip(icon: Icons.payments_rounded, label: trip.currency),
          ],
        ),
      ],
    );
  }
}

class _TripMetaChip extends StatelessWidget {
  const _TripMetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<DesignTokens>() ?? DesignTokens.base;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(tokens.radius.pill),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: tokens.spacing.md,
          vertical: tokens.spacing.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: tokens.spacing.lg),
            SizedBox(width: tokens.spacing.xs),
            Text(label, style: theme.textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}
