import 'package:flutter/material.dart';

class ThemeDataStyle {

  /// Theme data for light mode
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF352F44),
      secondary: Color(0xFF3366FF),
      surface: Color(0xFFFFFFFF),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),
    primaryColorLight: const Color(0xFFFFC1AC),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFFFFF),
    ),
    disabledColor: const Color(0xFF919EAB),
    scaffoldBackgroundColor: const Color(0xFFF9FAFB),
  );

  /// Theme data for dark mode
  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFB9B4C7),
      secondary: Color(0xFF3366FF),
      surface: Color(0xFF161C24),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF161C24),
    ),
    primaryColorLight: const Color(0xFFFFC1AC),
    disabledColor: const Color(0xFF919EAB),
    scaffoldBackgroundColor: const Color(0xFF212B36),
  );
}
