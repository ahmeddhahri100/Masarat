import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

class MasaratTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: MasaratColors.primary,
        primary: MasaratColors.primary,
        onPrimary: MasaratColors.onPrimary,
        primaryContainer: MasaratColors.primaryContainer,
        surface: MasaratColors.surface,
        onSurface: MasaratColors.onSurface,
        outlineVariant: MasaratColors.outlineVariant,
      ),
      scaffoldBackgroundColor: MasaratColors.surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: MasaratColors.surface,
        elevation: 0,
        centerTitle: false,
      ),
      textTheme: TextTheme(
        headlineLarge: MasaratTypography.headlineLarge,
        headlineMedium: MasaratTypography.headlineMedium,
        bodyMedium: MasaratTypography.bodyMedium,
        labelMedium: MasaratTypography.labelMedium,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MasaratColors.primary,
          foregroundColor: MasaratColors.onPrimary,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
          textStyle: MasaratTypography.buttonText,
        ),
      ),
    );
  }
}
