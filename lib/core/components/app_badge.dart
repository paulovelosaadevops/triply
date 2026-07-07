import 'package:flutter/material.dart';
import 'package:triply/app/theme/app_radius.dart';
import 'package:triply/app/theme/app_spacing.dart';

class AppBadge extends StatelessWidget {
  const AppBadge({
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
    super.key,
  });

  final Color? backgroundColor;
  final Color? foregroundColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: foregroundColor ?? colorScheme.onPrimaryContainer,
              ),
        ),
      ),
    );
  }
}
