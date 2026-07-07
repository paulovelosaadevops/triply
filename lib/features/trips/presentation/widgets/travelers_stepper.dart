import 'package:flutter/material.dart';
import 'package:triply/app/theme/design_tokens.dart';

class TravelersStepper extends StatelessWidget {
  const TravelersStepper({
    required this.onDecrement,
    required this.onIncrement,
    required this.value,
    super.key,
  });

  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final int value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<DesignTokens>() ?? DesignTokens.base;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(tokens.radius.md),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: tokens.spacing.md,
          vertical: tokens.spacing.sm,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'Número de viajantes',
                style: theme.textTheme.bodyLarge,
              ),
            ),
            IconButton(
              onPressed: value == 1 ? null : onDecrement,
              icon: const Icon(Icons.remove_rounded),
            ),
            Text(value.toString(), style: theme.textTheme.titleMedium),
            IconButton(
              onPressed: onIncrement,
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
