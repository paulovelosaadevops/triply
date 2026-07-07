import 'package:flutter/material.dart';
import 'package:triply/app/theme/design_tokens.dart';
import 'package:triply/core/components/app_card.dart';
import 'package:triply/core/components/section_title.dart';

class HomeEmptyTrips extends StatelessWidget {
  const HomeEmptyTrips({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<DesignTokens>() ?? DesignTokens.base;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SectionTitle(title: 'Minhas viagens'),
        SizedBox(height: tokens.spacing.lg),
        AppCard(
          padding: EdgeInsets.all(tokens.spacing.xl),
          child: Column(
            children: <Widget>[
              Icon(
                Icons.travel_explore_rounded,
                color: theme.colorScheme.primary,
                size: tokens.spacing.xxxl,
              ),
              SizedBox(height: tokens.spacing.lg),
              Text(
                'Você ainda não possui viagens.',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(height: tokens.spacing.xs),
              Text(
                'Crie sua primeira viagem para começar.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
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
