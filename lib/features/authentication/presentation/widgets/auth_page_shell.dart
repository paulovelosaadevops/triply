import 'package:flutter/material.dart';
import 'package:triply/app/theme/design_tokens.dart';

class AuthPageShell extends StatelessWidget {
  const AuthPageShell({
    required this.children,
    required this.description,
    required this.title,
    this.leading,
    super.key,
  });

  final List<Widget> children;
  final String description;
  final Widget? leading;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<DesignTokens>() ?? DesignTokens.base;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(tokens.spacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (leading != null) ...<Widget>[
                    Align(alignment: Alignment.centerLeft, child: leading),
                    SizedBox(height: tokens.spacing.xl),
                  ],
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOutCubic,
                    child: Text(
                      title,
                      key: ValueKey<String>(title),
                      style: theme.textTheme.headlineMedium,
                    ),
                  ),
                  SizedBox(height: tokens.spacing.sm),
                  Text(
                    description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: tokens.spacing.xxl),
                  ...children,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
