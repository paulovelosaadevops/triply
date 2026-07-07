import 'package:flutter/material.dart';
import 'package:triply/app/theme/dark_theme.dart';
import 'package:triply/app/theme/light_theme.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light => buildLightTheme();

  static ThemeData get dark => buildDarkTheme();
}
