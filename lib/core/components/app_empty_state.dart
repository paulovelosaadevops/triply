import 'package:flutter/material.dart';
import 'package:triply/app/theme/design_tokens.dart';
import 'package:triply/core/components/app_card.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    required this.description,
    required this.icon,
    required this.title,
    super.key,
  });

  final String description;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<DesignTokens>() ?? DesignTokens.base;

    return AppCard(
      padding: EdgeInsets.all(tokens.spacing.xl),
      child: Column(
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(tokens.radius.xl),
            ),
            child: Padding(
              padding: EdgeInsets.all(tokens.spacing.lg),
              child: Icon(
                icon,
                color: theme.colorScheme.onPrimaryContainer,
                size: tokens.spacing.xxl,
              ),
            ),
          ),
          SizedBox(height: tokens.spacing.lg),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          SizedBox(height: tokens.spacing.xs),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
