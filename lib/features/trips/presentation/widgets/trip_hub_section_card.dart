import 'package:flutter/material.dart';
import 'package:triply/app/theme/design_tokens.dart';
import 'package:triply/core/components/app_card.dart';
import 'package:triply/features/trips/presentation/models/trip_hub_section.dart';

class TripHubSectionCard extends StatelessWidget {
  const TripHubSectionCard({
    required this.onTap,
    required this.section,
    super.key,
  });

  final VoidCallback onTap;
  final TripHubSection section;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<DesignTokens>() ?? DesignTokens.base;

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.all(tokens.spacing.lg),
      child: Row(
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(tokens.radius.lg),
            ),
            child: Padding(
              padding: EdgeInsets.all(tokens.spacing.md),
              child: Icon(
                section.icon,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          SizedBox(width: tokens.spacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(section.title, style: theme.textTheme.titleMedium),
                SizedBox(height: tokens.spacing.xs),
                Text(
                  section.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: tokens.spacing.md),
          Icon(
            Icons.chevron_right_rounded,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
