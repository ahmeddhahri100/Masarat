import 'package:flutter/material.dart';

class MasaratColors {
  // Primary Forest Greens
  static const Color primary = Color(0xFF0F5238);
  static const Color primaryContainer = Color(0xFF2D6A4F);
  static const Color onPrimary = Colors.white;
  static const Color onPrimaryContainer = Color(0xFFA8E7C5);
  static const Color primaryFixed = Color(0xFFB1F0CE);
  static const Color onPrimaryFixed = Color(0xFF002114);

  // Secondary
  static const Color secondary = Color(0xFF51625B);
  static const Color onSecondary = Colors.white;
  static const Color secondaryFixed = Color(0xFFD4E7DD);
  static const Color onSecondaryFixed = Color(0xFF394A43);

  // Tertiary (for destructive/error states)
  static const Color tertiary = Color(0xFF713638);
  static const Color tertiaryFixed = Color(0xFFFFDAD9);
  static const Color onTertiaryFixed = Color(0xFF6F3537);

  // Surface & Neutrals (Living Neutrals)
  static const Color surface = Color(0xFFF8F9FA);
  static const Color onSurface = Color(0xFF191C1D);
  static const Color onSurfaceVariant = Color(0xFF404943);
  static const Color surfaceContainer = Color(0xFFEDEEEF);
  static const Color surfaceContainerHigh = Color(0xFFE7E8E9);
  static const Color surfaceContainerHighest = Color(0xFFE1E3E4);
  static const Color surfaceContainerLow = Color(0xFFF3F4F5);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);

  // Outline
  static const Color outline = Color(0xFF707973);
  static const Color outlineVariant = Color(0xFFBFC9C1);

  // Error
  static const Color error = Color(0xFFBA1A1A);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [primaryContainer, primary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
