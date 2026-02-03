import 'package:flutter/material.dart';

/// Noor AI Design System
///
/// Brand colors represent:
/// - Amber/Gold: Light (Noor) and Islamic golden age of knowledge
/// - Blue: Trust, knowledge, and depth
/// - Green: Success, growth, and Islamic symbolism
class AppTheme {
  // Brand Colors
  static const Color primaryAmber = Color(0xFFFFB300);
  static const Color secondaryBlue = Color(0xFF1E88E5);
  static const Color accentGreen = Color(0xFF43A047);
  static const Color errorRed = Color(0xFFD32F2F);

  // Light Theme Colors
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF5F5F5);
  static const Color textDark = Color(0xFF212121);
  static const Color textGray = Color(0xFF757575);

  // Dark Theme Colors
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textLight = Color(0xFFFFFFFF);

  // Typography
  // TODO: Add custom fonts later (Poppins, Amiri, KFGQPC)
  static const String? fontFamilyPoppins = null; // Uses system font for now
  static const String? fontFamilyAmiri = null; // Uses system font for now
  static const String? fontFamilyQuran = null; // Uses system font for now

  // Light Theme
  static ThemeData get lightTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: primaryAmber,
      primary: primaryAmber,
      secondary: secondaryBlue,
      tertiary: accentGreen,
      error: errorRed,
      surface: backgroundWhite,
      surfaceTint: surfaceLight,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: fontFamilyPoppins,

      // App Bar
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: backgroundWhite,
        foregroundColor: textDark,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: const TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: backgroundWhite,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryAmber,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamilyPoppins,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: secondaryBlue,
          textStyle: const TextStyle(
            fontFamily: fontFamilyPoppins,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryAmber,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
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
          borderSide: const BorderSide(color: primaryAmber, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorRed, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: const TextStyle(
          color: textGray,
          fontFamily: fontFamilyPoppins,
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: backgroundWhite,
        selectedItemColor: primaryAmber,
        unselectedItemColor: textGray,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 57,
          fontWeight: FontWeight.w700,
          color: textDark,
        ),
        displayMedium: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 45,
          fontWeight: FontWeight.w700,
          color: textDark,
        ),
        displaySmall: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: textDark,
        ),
        headlineLarge: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        headlineMedium: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        headlineSmall: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        titleLarge: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        titleMedium: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        titleSmall: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        bodyLarge: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textDark,
        ),
        bodyMedium: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textDark,
        ),
        bodySmall: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textDark,
        ),
        labelLarge: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        labelMedium: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        labelSmall: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: primaryAmber,
      primary: primaryAmber,
      secondary: secondaryBlue,
      tertiary: accentGreen,
      error: errorRed,
      surface: backgroundDark,
      surfaceTint: surfaceDark,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: fontFamilyPoppins,
      scaffoldBackgroundColor: backgroundDark,

      // App Bar
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: backgroundDark,
        foregroundColor: textLight,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: const TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textLight,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: surfaceDark,
      ),

      // Similar configurations as light theme but with dark colors
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryAmber,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamilyPoppins,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryAmber,
          textStyle: const TextStyle(
            fontFamily: fontFamilyPoppins,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryAmber,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark,
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
          borderSide: const BorderSide(color: primaryAmber, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorRed, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: const TextStyle(
          color: textGray,
          fontFamily: fontFamilyPoppins,
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceDark,
        selectedItemColor: primaryAmber,
        unselectedItemColor: textGray,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 57,
          fontWeight: FontWeight.w700,
          color: textLight,
        ),
        displayMedium: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 45,
          fontWeight: FontWeight.w700,
          color: textLight,
        ),
        displaySmall: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: textLight,
        ),
        headlineLarge: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: textLight,
        ),
        headlineMedium: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: textLight,
        ),
        headlineSmall: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textLight,
        ),
        titleLarge: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textLight,
        ),
        titleMedium: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textLight,
        ),
        titleSmall: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textLight,
        ),
        bodyLarge: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textLight,
        ),
        bodyMedium: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textLight,
        ),
        bodySmall: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textLight,
        ),
        labelLarge: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textLight,
        ),
        labelMedium: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textLight,
        ),
        labelSmall: TextStyle(
          fontFamily: fontFamilyPoppins,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textLight,
        ),
      ),
    );
  }
}

/// Custom text styles for Arabic content
class ArabicTextStyles {
  static const TextStyle quranVerse = TextStyle(
    fontFamily: AppTheme.fontFamilyQuran,
    fontSize: 28,
    height: 2.0,
    color: AppTheme.textDark,
  );

  static const TextStyle arabicBody = TextStyle(
    fontFamily: AppTheme.fontFamilyAmiri,
    fontSize: 18,
    height: 1.8,
    color: AppTheme.textDark,
  );

  static const TextStyle arabicHeadline = TextStyle(
    fontFamily: AppTheme.fontFamilyAmiri,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.8,
    color: AppTheme.textDark,
  );
}
