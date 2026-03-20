import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class MasaratTypography {
  // Display — for empty states / hero text
  static TextStyle get displayMedium => GoogleFonts.manrope(
        fontSize: 44,
        fontWeight: FontWeight.bold,
        color: MasaratColors.onSurface,
        letterSpacing: -1.0,
      );

  // Headlines — editorial authority
  static TextStyle get headlineLarge => GoogleFonts.manrope(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: MasaratColors.onSurface,
        letterSpacing: -0.5,
      );

  static TextStyle get headlineMedium => GoogleFonts.manrope(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: MasaratColors.onSurface,
        letterSpacing: -0.25,
      );

  static TextStyle get headlineSmall => GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: MasaratColors.onSurface,
      );

  // Title
  static TextStyle get titleMedium => GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: MasaratColors.onSurface,
      );

  // Body — functional Inter
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: MasaratColors.onSurface,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: MasaratColors.onSurface,
        height: 1.4,
      );

  // Label — small, technical
  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: MasaratColors.onSurface,
        letterSpacing: 0.1,
      );

  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: MasaratColors.onSurfaceVariant,
        letterSpacing: 0.5,
      );

  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: MasaratColors.onSurfaceVariant,
        letterSpacing: 0.5,
      );

  static TextStyle get buttonText => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: MasaratColors.onPrimary,
        letterSpacing: 0.1,
      );
}
