import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color brand = Color(0xFF5B5BD6);
  static const Color brandStrong = Color(0xFF4343B8);
  static const Color brandSoft = Color(0xFFEAEAFC);

  static const Color mint = Color(0xFF2FBF8F);
  static const Color amber = Color(0xFFF6A609);
  static const Color red = Color(0xFFE14D4D);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF101114);

  static const Color gray50 = Color(0xFFF8F9FB);
  static const Color gray100 = Color(0xFFF1F3F6);
  static const Color gray200 = Color(0xFFE3E7ED);
  static const Color gray300 = Color(0xFFCDD3DD);
  static const Color gray400 = Color(0xFF98A1B2);
  static const Color gray500 = Color(0xFF697386);
  static const Color gray600 = Color(0xFF4B5565);
  static const Color gray700 = Color(0xFF333B49);
  static const Color gray800 = Color(0xFF202631);
  static const Color gray900 = Color(0xFF151922);

  static const ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: brand,
    onPrimary: white,
    primaryContainer: brandSoft,
    onPrimaryContainer: brandStrong,
    secondary: mint,
    onSecondary: white,
    secondaryContainer: Color(0xFFE3F7F0),
    onSecondaryContainer: Color(0xFF0E5D45),
    tertiary: amber,
    onTertiary: black,
    tertiaryContainer: Color(0xFFFFF4D8),
    onTertiaryContainer: Color(0xFF6D4600),
    error: red,
    onError: white,
    errorContainer: Color(0xFFFFE3E3),
    onErrorContainer: Color(0xFF7A1F1F),
    surface: white,
    onSurface: black,
    surfaceContainerHighest: gray100,
    onSurfaceVariant: gray600,
    outline: gray300,
    outlineVariant: gray200,
    shadow: Color(0x1A101114),
    scrim: Color(0x99101114),
    inverseSurface: gray900,
    onInverseSurface: gray50,
    inversePrimary: Color(0xFFC7C7FF),
  );

  static const ColorScheme darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFC7C7FF),
    onPrimary: Color(0xFF25256F),
    primaryContainer: Color(0xFF343491),
    onPrimaryContainer: Color(0xFFEAEAFC),
    secondary: Color(0xFF6FE0B7),
    onSecondary: Color(0xFF073D2D),
    secondaryContainer: Color(0xFF0E5D45),
    onSecondaryContainer: Color(0xFFE3F7F0),
    tertiary: Color(0xFFFFCF70),
    onTertiary: Color(0xFF4B3000),
    tertiaryContainer: Color(0xFF6D4600),
    onTertiaryContainer: Color(0xFFFFF4D8),
    error: Color(0xFFFFA4A4),
    onError: Color(0xFF611515),
    errorContainer: Color(0xFF7A1F1F),
    onErrorContainer: Color(0xFFFFE3E3),
    surface: gray900,
    onSurface: gray50,
    surfaceContainerHighest: gray800,
    onSurfaceVariant: gray300,
    outline: gray700,
    outlineVariant: gray800,
    shadow: Color(0x66000000),
    scrim: Color(0xCC000000),
    inverseSurface: gray50,
    onInverseSurface: gray900,
    inversePrimary: brand,
  );
}
