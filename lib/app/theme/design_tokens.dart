import 'package:flutter/material.dart';
import 'package:triply/app/theme/app_radius.dart';
import 'package:triply/app/theme/app_shadows.dart';
import 'package:triply/app/theme/app_spacing.dart';

@immutable
class DesignTokens extends ThemeExtension<DesignTokens> {
  const DesignTokens({
    required this.spacing,
    required this.radius,
    required this.shadows,
  });

  final AppSpacingTokens spacing;
  final AppRadiusTokens radius;
  final AppShadowTokens shadows;

  static const DesignTokens base = DesignTokens(
    spacing: AppSpacingTokens(),
    radius: AppRadiusTokens(),
    shadows: AppShadowTokens(),
  );

  @override
  DesignTokens copyWith({
    AppSpacingTokens? spacing,
    AppRadiusTokens? radius,
    AppShadowTokens? shadows,
  }) {
    return DesignTokens(
      spacing: spacing ?? this.spacing,
      radius: radius ?? this.radius,
      shadows: shadows ?? this.shadows,
    );
  }

  @override
  DesignTokens lerp(ThemeExtension<DesignTokens>? other, double t) {
    if (other is! DesignTokens) {
      return this;
    }

    return DesignTokens(
      spacing: spacing.lerp(other.spacing, t),
      radius: radius.lerp(other.radius, t),
      shadows: t < 0.5 ? shadows : other.shadows,
    );
  }
}

@immutable
class AppSpacingTokens {
  const AppSpacingTokens({
    this.none = AppSpacing.none,
    this.xxs = AppSpacing.xxs,
    this.xs = AppSpacing.xs,
    this.sm = AppSpacing.sm,
    this.md = AppSpacing.md,
    this.lg = AppSpacing.lg,
    this.xl = AppSpacing.xl,
    this.xxl = AppSpacing.xxl,
    this.xxxl = AppSpacing.xxxl,
  });

  final double none;
  final double xxs;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double xxxl;

  AppSpacingTokens lerp(AppSpacingTokens other, double t) {
    return AppSpacingTokens(
      none: lerpDouble(none, other.none, t),
      xxs: lerpDouble(xxs, other.xxs, t),
      xs: lerpDouble(xs, other.xs, t),
      sm: lerpDouble(sm, other.sm, t),
      md: lerpDouble(md, other.md, t),
      lg: lerpDouble(lg, other.lg, t),
      xl: lerpDouble(xl, other.xl, t),
      xxl: lerpDouble(xxl, other.xxl, t),
      xxxl: lerpDouble(xxxl, other.xxxl, t),
    );
  }
}

@immutable
class AppRadiusTokens {
  const AppRadiusTokens({
    this.none = AppRadius.none,
    this.xs = AppRadius.xs,
    this.sm = AppRadius.sm,
    this.md = AppRadius.md,
    this.lg = AppRadius.lg,
    this.xl = AppRadius.xl,
    this.pill = AppRadius.pill,
  });

  final double none;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double pill;

  AppRadiusTokens lerp(AppRadiusTokens other, double t) {
    return AppRadiusTokens(
      none: lerpDouble(none, other.none, t),
      xs: lerpDouble(xs, other.xs, t),
      sm: lerpDouble(sm, other.sm, t),
      md: lerpDouble(md, other.md, t),
      lg: lerpDouble(lg, other.lg, t),
      xl: lerpDouble(xl, other.xl, t),
      pill: lerpDouble(pill, other.pill, t),
    );
  }
}

@immutable
class AppShadowTokens {
  const AppShadowTokens({
    this.none = AppShadows.none,
    this.sm = AppShadows.sm,
    this.md = AppShadows.md,
  });

  final List<BoxShadow> none;
  final List<BoxShadow> sm;
  final List<BoxShadow> md;
}

double lerpDouble(double a, double b, double t) {
  return a + (b - a) * t;
}
