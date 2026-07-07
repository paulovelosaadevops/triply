import 'package:flutter/material.dart';
import 'package:triply/app/router/app_router.dart';
import 'package:triply/app/theme/design_tokens.dart';
import 'package:triply/core/components/section_title.dart';
import 'package:triply/features/trips/domain/trip.dart';
import 'package:triply/features/trips/presentation/models/trip_hub_section.dart';
import 'package:triply/features/trips/presentation/widgets/trip_details_header.dart';
import 'package:triply/features/trips/presentation/widgets/trip_hero_card.dart';
import 'package:triply/features/trips/presentation/widgets/trip_hub_section_card.dart';

class TripDetailsPage extends StatelessWidget {
  const TripDetailsPage({required this.trip, super.key});

  final Trip trip;

  static const List<TripHubSection> _sections = <TripHubSection>[
    TripHubSection(
      icon: Icons.map_rounded,
      routeName: AppRoutes.itinerary,
      title: 'Roteiro',
      description: 'Organize os dias e principais atividades.',
    ),
    TripHubSection(
      icon: Icons.flight_rounded,
      routeName: AppRoutes.flights,
      title: 'Voos',
      description: 'Centralize passagens e horarios importantes.',
    ),
    TripHubSection(
      icon: Icons.hotel_rounded,
      routeName: AppRoutes.lodging,
      title: 'Hospedagem',
      description: 'Guarde reservas e enderecos da estadia.',
    ),
    TripHubSection(
      icon: Icons.description_rounded,
      routeName: AppRoutes.documents,
      title: 'Documentos',
      description: 'Tenha documentos importantes sempre a mao.',
    ),
    TripHubSection(
      icon: Icons.payments_rounded,
      routeName: AppRoutes.expenses,
      title: 'Gastos',
      description: 'Acompanhe custos e moeda da viagem.',
    ),
    TripHubSection(
      icon: Icons.checklist_rounded,
      routeName: AppRoutes.checklist,
      title: 'Checklist',
      description: 'Prepare tudo antes de sair de casa.',
    ),
  ];

  static const List<String> _quickAddOptions = <String>[
    'Adicionar voo',
    'Adicionar hospedagem',
    'Adicionar documento',
    'Adicionar gasto',
  ];

  void _openSection(BuildContext context, TripHubSection section) {
    Navigator.of(context).pushNamed(section.routeName, arguments: trip);
  }

  void _showQuickAddSheet(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<DesignTokens>() ?? DesignTokens.base;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: theme.colorScheme.surface,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              tokens.spacing.xl,
              tokens.spacing.sm,
              tokens.spacing.xl,
              tokens.spacing.xl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Adicionar a viagem', style: theme.textTheme.titleLarge),
                SizedBox(height: tokens.spacing.lg),
                ..._quickAddOptions.map(
                  (option) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.add_circle_outline_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    title: Text(option),
                    subtitle: const Text('Em breve'),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<DesignTokens>() ?? DesignTokens.base;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showQuickAddSheet(context),
        child: const Icon(Icons.add_rounded),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.all(tokens.spacing.xl),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TripDetailsHeader(trip: trip),
                    SizedBox(height: tokens.spacing.xxl),
                    TripHeroCard(trip: trip),
                    SizedBox(height: tokens.spacing.xxl),
                    const SectionTitle(title: 'Organize sua viagem'),
                    SizedBox(height: tokens.spacing.lg),
                    ..._sections.map(
                      (section) => Padding(
                        padding: EdgeInsets.only(bottom: tokens.spacing.md),
                        child: TripHubSectionCard(
                          section: section,
                          onTap: () => _openSection(context, section),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
