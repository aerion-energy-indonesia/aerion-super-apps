// lib/themes/app_theme.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  // Tema Terang (Light Theme)
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Colors.blue,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: Colors.blue,
        secondary: Colors.redAccent,
      ),
      // Atur properti tema lainnya (font, button, dsb.)
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  // Tema Gelap (Dark Theme)
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: Colors.indigo,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: Colors.indigo,
        secondary: Colors.tealAccent,
      ),
      // ...
    );
  }
}
