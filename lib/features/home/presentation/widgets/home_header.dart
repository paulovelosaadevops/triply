import 'package:flutter/material.dart';
import 'package:triply/app/theme/design_tokens.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<DesignTokens>() ?? DesignTokens.base;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Olá, Paulo 👋', style: theme.textTheme.headlineMedium),
              SizedBox(height: tokens.spacing.xs),
              Text(
                'Vamos planejar sua próxima viagem?',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: tokens.spacing.lg),
        CircleAvatar(
          radius: tokens.spacing.xl,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.person_rounded,
            color: theme.colorScheme.onPrimaryContainer,
            size: tokens.spacing.xl,
          ),
        ),
      ],
    );
  }
}
