import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class MasaratTypography {
  static TextStyle get headlineLarge => GoogleFonts.manrope(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: MasaratColors.onSurface,
        letterSpacing: -0.5,
      );

  static TextStyle get headlineMedium => GoogleFonts.manrope(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: MasaratColors.onSurface,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: MasaratColors.onSurface,
      );

  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: MasaratColors.onSurface.withOpacity(0.6),
        letterSpacing: 0.5,
      );

  static TextStyle get buttonText => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: MasaratColors.onPrimary,
      );
}
