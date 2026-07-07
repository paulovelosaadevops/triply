import 'package:flutter/material.dart';
import 'package:triply/app/theme/design_tokens.dart';

class TripModulePageShell extends StatelessWidget {
  const TripModulePageShell({
    required this.children,
    required this.onAdd,
    required this.title,
    this.subtitle,
    super.key,
  });

  final List<Widget> children;
  final VoidCallback onAdd;
  final String? subtitle;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<DesignTokens>() ?? DesignTokens.base;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: onAdd,
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
                    IconButton(
                      alignment: Alignment.centerLeft,
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    SizedBox(height: tokens.spacing.lg),
                    Text(title, style: theme.textTheme.headlineMedium),
                    if (subtitle != null) ...<Widget>[
                      SizedBox(height: tokens.spacing.xs),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    SizedBox(height: tokens.spacing.xxl),
                    ...children,
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
