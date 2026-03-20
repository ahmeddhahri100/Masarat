import 'package:flutter/material.dart';

class MasaratColors {
  // Primary Forest Greens
  static const Color primary = Color(0xFF0F5238);
  static const Color primaryContainer = Color(0xFF2D6A4F);
  static const Color onPrimary = Colors.white;
  static const Color onPrimaryContainer = Color(0xFFA8E7C5);

  // Surface & Neutrals (Living Neutrals)
  static const Color surface = Color(0xFFF8F9FA);
  static const Color onSurface = Color(0xFF191C1D);
  static const Color surfaceContainerLow = Color(0xFFF3F4F5);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color outlineVariant = Color(0xFFBFC9C1);

  // Muted Professional Status Colors
  static const Color secondaryFixed = Color(0xFFD4E7DD);
  static const Color onSecondaryFixed = Color(0xFF394A43);
  static const Color primaryFixed = Color(0xFFB1F0CE);
  static const Color tertiaryFixed = Color(0xFFFFDAD9);
  static const Color onTertiaryFixed = Color(0xFF6F3537);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
