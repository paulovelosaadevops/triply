import 'package:flutter/material.dart';
import 'package:triply/app/theme/design_tokens.dart';

class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({
    required this.currentIndex,
    required this.itemCount,
    super.key,
  });

  static const Duration _animationDuration = Duration(milliseconds: 260);
  static const Curve _animationCurve = Curves.easeOutCubic;

  final int currentIndex;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<DesignTokens>() ?? DesignTokens.base;
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount, (index) {
        final isActive = index == currentIndex;

        return AnimatedContainer(
          duration: _animationDuration,
          curve: _animationCurve,
          width: isActive ? tokens.spacing.xxl : tokens.spacing.sm,
          height: tokens.spacing.sm,
          margin: EdgeInsets.symmetric(horizontal: tokens.spacing.xs),
          decoration: BoxDecoration(
            color: isActive
                ? colorScheme.primary
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(tokens.radius.pill),
          ),
        );
      }),
    );
  }
}
