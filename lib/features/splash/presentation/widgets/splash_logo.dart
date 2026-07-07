import 'package:flutter/material.dart';
import 'package:triply/app/theme/design_tokens.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({required this.opacity, required this.scale, super.key});

  static const String assetPath = 'assets/logos/triply-logo.png';
  static const double _baseLogoSize = 132;

  final Animation<double> opacity;
  final Animation<double> scale;

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<DesignTokens>();
    final logoSize = _baseLogoSize + (tokens?.spacing.md ?? 0);

    return FadeTransition(
      opacity: opacity,
      child: ScaleTransition(
        scale: scale,
        child: Image.asset(assetPath, width: logoSize, fit: BoxFit.contain),
      ),
    );
  }
}
