import 'package:flutter/material.dart';
import 'package:triply/app/theme/design_tokens.dart';
import 'package:triply/core/components/app_card.dart';

class TripPhotoPlaceholder extends StatelessWidget {
  const TripPhotoPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<DesignTokens>() ?? DesignTokens.base;

    return AppCard(
      padding: EdgeInsets.all(tokens.spacing.xl),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.image_outlined,
            color: theme.colorScheme.primary,
            size: tokens.spacing.xxl,
          ),
          SizedBox(width: tokens.spacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Foto da viagem', style: theme.textTheme.titleMedium),
                SizedBox(height: tokens.spacing.xs),
                Text(
                  'Em breve',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
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
