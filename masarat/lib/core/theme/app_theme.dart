import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App theme configuration using Google Fonts and Material Design 3
class AppTheme {
  AppTheme._();

  // ============================================================
  // Color Seeds
  // ============================================================

  static const Color _primaryColorLight = Color(0xFF2563EB);
  static const Color _primaryColorDark = Color(0xFF3B82F6);
  static const Color _secondaryColor = Color(0xFF10B981);
  static const Color _errorColor = Color(0xFFEF4444);
  static const Color _warningColor = Color(0xFFF59E0B);
  static const Color _successColor = Color(0xFF22C55E);
  static const Color _infoColor = Color(0xFF3B82F6);

  // ============================================================
  // Light Theme
  // ============================================================

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColorLight,
        brightness: Brightness.light,
        secondary: _secondaryColor,
        error: _errorColor,
      ),
      textTheme: _buildTextTheme(Brightness.light),
      appBarTheme: _buildAppBarTheme(Brightness.light),
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      outlinedButtonTheme: _buildOutlinedButtonTheme(),
      textButtonTheme: _buildTextButtonTheme(),
      inputDecorationTheme: _buildInputDecorationTheme(Brightness.light),
      cardTheme: _buildCardTheme(Brightness.light),
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(Brightness.light),
      floatingActionButtonTheme: _buildFloatingActionButtonTheme(),
      chipTheme: _buildChipTheme(Brightness.light),
      dialogTheme: _buildDialogTheme(Brightness.light),
      snackBarTheme: _buildSnackBarTheme(Brightness.light),
      dividerTheme: _buildDividerTheme(Brightness.light),
      listTileTheme: _buildListTileTheme(Brightness.light),
      navigationBarTheme: _buildNavigationBarTheme(Brightness.light),
      bottomSheetTheme: _buildBottomSheetTheme(Brightness.light),
    );
  }

  // ============================================================
  // Dark Theme
  // ============================================================

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColorDark,
        brightness: Brightness.dark,
        secondary: _secondaryColor,
        error: _errorColor,
      ),
      textTheme: _buildTextTheme(Brightness.dark),
      appBarTheme: _buildAppBarTheme(Brightness.dark),
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      outlinedButtonTheme: _buildOutlinedButtonTheme(),
      textButtonTheme: _buildTextButtonTheme(),
      inputDecorationTheme: _buildInputDecorationTheme(Brightness.dark),
      cardTheme: _buildCardTheme(Brightness.dark),
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(Brightness.dark),
      floatingActionButtonTheme: _buildFloatingActionButtonTheme(),
      chipTheme: _buildChipTheme(Brightness.dark),
      dialogTheme: _buildDialogTheme(Brightness.dark),
      snackBarTheme: _buildSnackBarTheme(Brightness.dark),
      dividerTheme: _buildDividerTheme(Brightness.dark),
      listTileTheme: _buildListTileTheme(Brightness.dark),
      navigationBarTheme: _buildNavigationBarTheme(Brightness.dark),
      bottomSheetTheme: _buildBottomSheetTheme(Brightness.dark),
    );
  }

  // ============================================================
  // Text Theme
  // ============================================================

  static TextTheme _buildTextTheme(Brightness brightness) {
    final baseTextTheme = GoogleFonts.poppinsTextTheme(
      brightness == Brightness.light
          ? Typography.material2021().black
          : Typography.material2021().white,
    );

    return baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
      displayMedium: baseTextTheme.displayMedium?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
      displaySmall: baseTextTheme.displaySmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      titleSmall: baseTextTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w400,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.w400,
      ),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      labelMedium: baseTextTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      labelSmall: baseTextTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // ============================================================
  // Component Themes
  // ============================================================

  static AppBarTheme _buildAppBarTheme(Brightness brightness) {
    return AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: true,
      backgroundColor: brightness == Brightness.light
          ? Colors.white
          : const Color(0xFF1E1E1E),
      foregroundColor: brightness == Brightness.light
          ? Colors.black87
          : Colors.white,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: brightness == Brightness.light ? Colors.black87 : Colors.white,
      ),
      iconTheme: IconThemeData(
        color: brightness == Brightness.light ? Colors.black87 : Colors.white,
      ),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(Brightness brightness) {
    return InputDecorationTheme(
      filled: true,
      fillColor: brightness == Brightness.light
          ? Colors.grey.shade100
          : Colors.grey.shade900,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _errorColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _errorColor, width: 2),
      ),
      hintStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: brightness == Brightness.light
            ? Colors.grey.shade500
            : Colors.grey.shade600,
      ),
      labelStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: brightness == Brightness.light
            ? Colors.grey.shade700
            : Colors.grey.shade400,
      ),
      errorStyle: GoogleFonts.poppins(
        fontSize: 12,
        color: _errorColor,
      ),
    );
  }

  static CardTheme _buildCardTheme(Brightness brightness) {
    return CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: brightness == Brightness.light
              ? Colors.grey.shade200
              : Colors.grey.shade800,
          width: 1,
        ),
      ),
      color: brightness == Brightness.light
          ? Colors.white
          : const Color(0xFF2A2A2A),
    );
  }

  static BottomNavigationBarThemeData _buildBottomNavigationBarTheme(
    Brightness brightness,
  ) {
    return BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      backgroundColor: brightness == Brightness.light
          ? Colors.white
          : const Color(0xFF1E1E1E),
      selectedItemColor: _primaryColorLight,
      unselectedItemColor: brightness == Brightness.light
          ? Colors.grey.shade600
          : Colors.grey.shade500,
      selectedLabelStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  static FloatingActionButtonThemeData _buildFloatingActionButtonTheme() {
    return FloatingActionButtonThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  static ChipThemeData _buildChipTheme(Brightness brightness) {
    return ChipThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: brightness == Brightness.light
          ? Colors.grey.shade100
          : Colors.grey.shade800,
      labelStyle: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  static DialogTheme _buildDialogTheme(Brightness brightness) {
    return DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: brightness == Brightness.light
          ? Colors.white
          : const Color(0xFF2A2A2A),
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: brightness == Brightness.light ? Colors.black87 : Colors.white,
      ),
      contentTextStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: brightness == Brightness.light
            ? Colors.grey.shade700
            : Colors.grey.shade300,
      ),
    );
  }

  static SnackBarThemeData _buildSnackBarTheme(Brightness brightness) {
    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: brightness == Brightness.light
          ? const Color(0xFF323232)
          : const Color(0xFFE0E0E0),
      contentTextStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: brightness == Brightness.light
            ? Colors.white
            : Colors.black87,
      ),
    );
  }

  static DividerThemeData _buildDividerTheme(Brightness brightness) {
    return DividerThemeData(
      thickness: 1,
      color: brightness == Brightness.light
          ? Colors.grey.shade200
          : Colors.grey.shade800,
    );
  }

  static ListTileThemeData _buildListTileTheme(Brightness brightness) {
    return ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: brightness == Brightness.light ? Colors.black87 : Colors.white,
      ),
      subtitleTextStyle: GoogleFonts.poppins(
        fontSize: 13,
        color: brightness == Brightness.light
            ? Colors.grey.shade600
            : Colors.grey.shade400,
      ),
    );
  }

  static NavigationBarThemeData _buildNavigationBarTheme(Brightness brightness) {
    return NavigationBarThemeData(
      elevation: 0,
      backgroundColor: brightness == Brightness.light
          ? Colors.white
          : const Color(0xFF1E1E1E),
      indicatorColor: brightness == Brightness.light
          ? _primaryColorLight.withAlpha(30)
          : _primaryColorDark.withAlpha(30),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        return GoogleFonts.poppins(
          fontSize: 12,
          fontWeight:
              states.contains(WidgetState.selected) ? FontWeight.w600 : FontWeight.w400,
        );
      }),
    );
  }

  static BottomSheetThemeData _buildBottomSheetTheme(Brightness brightness) {
    return BottomSheetThemeData(
      backgroundColor: brightness == Brightness.light
          ? Colors.white
          : const Color(0xFF2A2A2A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }
}

/// Custom colors extension for additional app colors
class AppColors {
  AppColors._();

  // Status Colors
  static const Color success = _successColor;
  static const Color warning = _warningColor;
  static const Color error = _errorColor;
  static const Color info = _infoColor;

  // Social Colors
  static const Color google = Color(0xFFDB4437);
  static const Color facebook = Color(0xFF1877F2);
  static const Color apple = Color(0xFF000000);
  static const Color twitter = Color(0xFF1DA1F2);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [_primaryColorLight, _secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shimmer Colors
  static List<Color> get shimmerColors => [
    Colors.grey.shade300,
    Colors.grey.shade100,
    Colors.grey.shade300,
  ];

  static List<Color> get shimmerDarkColors => [
    Colors.grey.shade800,
    Colors.grey.shade700,
    Colors.grey.shade800,
  ];
}
