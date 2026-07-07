import 'package:flutter/material.dart';
import 'package:triply/app/theme/design_tokens.dart';
import 'package:triply/features/onboarding/presentation/models/onboarding_item.dart';

class OnboardingPageContent extends StatelessWidget {
  const OnboardingPageContent({
    required this.isActive,
    required this.item,
    super.key,
  });

  static const Duration _entryDuration = Duration(milliseconds: 420);
  static const Curve _entryCurve = Curves.easeOutCubic;

  final bool isActive;
  final OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<DesignTokens>() ?? DesignTokens.base;
    final colorScheme = theme.colorScheme;

    return AnimatedOpacity(
      duration: _entryDuration,
      curve: _entryCurve,
      opacity: isActive ? 1 : 0.72,
      child: AnimatedSlide(
        duration: _entryDuration,
        curve: _entryCurve,
        offset: isActive ? Offset.zero : const Offset(0, 0.03),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final iconSize = constraints.maxHeight < 420
                ? tokens.spacing.xxxl
                : tokens.spacing.xxxl * 1.5;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(tokens.radius.xl),
                    boxShadow: tokens.shadows.sm,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(tokens.spacing.xl),
                    child: Icon(
                      item.icon,
                      color: colorScheme.onPrimaryContainer,
                      size: iconSize,
                    ),
                  ),
                ),
                SizedBox(height: tokens.spacing.xxl),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium,
                ),
                SizedBox(height: tokens.spacing.md),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Text(
                    item.description,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
