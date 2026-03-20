import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';
import 'typography.dart';

class MasaratTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: MasaratColors.primary,
        onPrimary: MasaratColors.onPrimary,
        primaryContainer: MasaratColors.primaryContainer,
        onPrimaryContainer: MasaratColors.onPrimaryContainer,
        secondary: MasaratColors.secondary,
        onSecondary: MasaratColors.onSecondary,
        secondaryContainer: MasaratColors.secondaryFixed,
        onSecondaryContainer: MasaratColors.onSecondaryFixed,
        tertiary: MasaratColors.tertiary,
        onTertiary: Colors.white,
        tertiaryContainer: MasaratColors.tertiaryFixed,
        onTertiaryContainer: MasaratColors.onTertiaryFixed,
        error: MasaratColors.error,
        onError: Colors.white,
        errorContainer: const Color(0xFFFFDAD6),
        onErrorContainer: const Color(0xFF93000A),
        surface: MasaratColors.surface,
        onSurface: MasaratColors.onSurface,
        onSurfaceVariant: MasaratColors.onSurfaceVariant,
        outline: MasaratColors.outline,
        outlineVariant: MasaratColors.outlineVariant,
        surfaceContainerLowest: MasaratColors.surfaceContainerLowest,
        surfaceContainerLow: MasaratColors.surfaceContainerLow,
        surfaceContainer: MasaratColors.surfaceContainer,
        surfaceContainerHigh: MasaratColors.surfaceContainerHigh,
        surfaceContainerHighest: MasaratColors.surfaceContainerHighest,
      ),
      scaffoldBackgroundColor: MasaratColors.surface,
      fontFamily: GoogleFonts.inter().fontFamily,

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: MasaratColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: MasaratColors.onSurface),
        titleTextStyle: MasaratTypography.headlineSmall,
      ),

      // Text Theme
      textTheme: TextTheme(
        displayMedium: MasaratTypography.displayMedium,
        headlineLarge: MasaratTypography.headlineLarge,
        headlineMedium: MasaratTypography.headlineMedium,
        headlineSmall: MasaratTypography.headlineSmall,
        titleMedium: MasaratTypography.titleMedium,
        bodyLarge: MasaratTypography.bodyLarge,
        bodyMedium: MasaratTypography.bodyMedium,
        labelLarge: MasaratTypography.labelLarge,
        labelMedium: MasaratTypography.labelMedium,
        labelSmall: MasaratTypography.labelSmall,
      ),

      // Elevated Button — Full-width gradient pill
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MasaratColors.primary,
          foregroundColor: MasaratColors.onPrimary,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
          textStyle: MasaratTypography.buttonText,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: MasaratColors.primary,
          minimumSize: const Size(double.infinity, 56),
          side: const BorderSide(color: MasaratColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: MasaratTypography.buttonText.copyWith(
            color: MasaratColors.primary,
          ),
        ),
      ),

      // Input Decoration — Filled, no border, rounded
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MasaratColors.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: MasaratColors.primary, width: 1.5),
        ),
        labelStyle: MasaratTypography.labelMedium,
        hintStyle: MasaratTypography.bodyMedium.copyWith(
          color: MasaratColors.onSurfaceVariant.withOpacity(0.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),

      // Tab Bar
      tabBarTheme: TabBarThemeData(
        indicatorColor: MasaratColors.primary,
        labelColor: MasaratColors.primary,
        unselectedLabelColor: MasaratColors.onSurfaceVariant,
        dividerColor: Colors.transparent,
        labelStyle: MasaratTypography.labelLarge,
        unselectedLabelStyle: MasaratTypography.labelLarge,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: MasaratColors.primary, width: 2),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: MasaratColors.surfaceContainerLowest,
        selectedItemColor: MasaratColors.primary,
        unselectedItemColor: MasaratColors.onSurfaceVariant.withOpacity(0.5),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: MasaratTypography.labelSmall.copyWith(
          color: MasaratColors.primary,
        ),
        unselectedLabelStyle: MasaratTypography.labelSmall,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: MasaratColors.surfaceContainerLow,
        selectedColor: MasaratColors.primaryFixed,
        labelStyle: MasaratTypography.labelMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: Colors.transparent,
        thickness: 0,
      ),
    );
  }
}
