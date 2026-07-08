import 'package:flutter/material.dart';
import 'package:triply/app/theme/design_tokens.dart';
import 'package:triply/core/components/app_empty_state.dart';
import 'package:triply/core/components/section_title.dart';

class HomeEmptyTrips extends StatelessWidget {
  const HomeEmptyTrips({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens =
        Theme.of(context).extension<DesignTokens>() ?? DesignTokens.base;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SectionTitle(title: 'Minhas viagens'),
        SizedBox(height: tokens.spacing.lg),
        const AppEmptyState(
          description: 'Crie sua primeira viagem para começar.',
          icon: Icons.travel_explore_rounded,
          title: 'Você ainda não possui viagens.',
        ),
      ],
    );
  }
}
