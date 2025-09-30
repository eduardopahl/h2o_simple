import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFF42A5F5);
  static const Color darkBlue = Color(0xFF0D47A1);
  static const Color accentCyan = Color(0xFF00ACC1);
  static const Color backgroundLight = Color(0xFFF5F9FF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  static const Color progressEmpty = Color(0xFFE3F2FD);
  static const Color progressFilled = Color(0xFF2196F3);
  static const Color progressCompleted = Color(0xFF4CAF50);

  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF424242);
  static const Color textLight = Color(0xFF666666);

  // Cores de ação
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFE53E3E);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color infoColor = Color(0xFF3498DB);

  // Cores de fundo
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color shadowColor = Color(0x1A000000);

  // Cores de input
  static const Color inputFillColor = Color(0xFFFAFAFA);
  static const Color inputBorderColor = Color(0xFFE0E0E0);

  // Cores para tema escuro
  static const Color darkPrimaryBlue = Color(0xFF90CAF9);
  static const Color darkLightBlue = Color(0xFF64B5F6);
  static const Color darkDarkBlue = Color(0xFF1976D2);
  static const Color darkAccentCyan = Color(0xFF4DD0E1);
  static const Color darkBackgroundDark = Color(0xFF121212);
  static const Color darkCardBackground = Color(0xFF1E1E1E);

  static const Color darkProgressEmpty = Color(0xFF263238);
  static const Color darkProgressFilled = Color(0xFF42A5F5);
  static const Color darkProgressCompleted = Color(0xFF66BB6A);

  static const Color darkTextPrimary = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFFBDBDBD);
  static const Color darkTextLight = Color(0xFF9E9E9E);

  static const Color darkSurfaceColor = Color(0xFF1E1E1E);
  static const Color darkShadowColor = Color(0x4D000000);

  static const Color darkInputFillColor = Color(0xFF2C2C2C);
  static const Color darkInputBorderColor = Color(0xFF424242);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.light,
      primary: primaryBlue,
      secondary: accentCyan,
      surface: cardBackground,
      onSurface: backgroundLight,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: primaryBlue,
      foregroundColor: surfaceColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: surfaceColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    cardTheme: CardTheme(
      color: cardBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryBlue,
      foregroundColor: surfaceColor,
      elevation: 4,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: surfaceColor,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryBlue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryBlue,
        side: const BorderSide(color: primaryBlue),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: inputFillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: inputBorderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: inputBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryBlue, width: 2),
      ),
      labelStyle: const TextStyle(color: textSecondary),
      hintStyle: const TextStyle(color: textLight),
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: textPrimary,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: textPrimary,
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      displaySmall: TextStyle(
        color: textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: TextStyle(
        color: textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: TextStyle(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: TextStyle(
        color: textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(
        color: textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        color: textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: TextStyle(
        color: textLight,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      labelLarge: TextStyle(
        color: textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: darkPrimaryBlue,
      brightness: Brightness.dark,
      primary: darkPrimaryBlue,
      secondary: darkAccentCyan,
      surface: darkCardBackground,
      onSurface: darkBackgroundDark,
    ),

    scaffoldBackgroundColor: darkBackgroundDark,

    appBarTheme: const AppBarTheme(
      backgroundColor: darkCardBackground,
      foregroundColor: darkTextPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: darkTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    cardTheme: CardTheme(
      color: darkCardBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: darkPrimaryBlue,
      foregroundColor: darkBackgroundDark,
      elevation: 4,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimaryBlue,
        foregroundColor: darkBackgroundDark,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: darkPrimaryBlue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: darkPrimaryBlue,
        side: const BorderSide(color: darkPrimaryBlue),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkInputFillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: darkInputBorderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: darkInputBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: darkPrimaryBlue, width: 2),
      ),
      labelStyle: const TextStyle(color: darkTextSecondary),
      hintStyle: const TextStyle(color: darkTextLight),
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: darkTextPrimary,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: darkTextPrimary,
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      displaySmall: TextStyle(
        color: darkTextPrimary,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: TextStyle(
        color: darkTextPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        color: darkTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: TextStyle(
        color: darkTextPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: TextStyle(
        color: darkTextPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: darkTextPrimary,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(
        color: darkTextPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: darkTextPrimary,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        color: darkTextSecondary,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: TextStyle(
        color: darkTextLight,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      labelLarge: TextStyle(
        color: darkTextPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  static const LinearGradient waterGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [lightBlue, primaryBlue],
  );

  static const LinearGradient progressGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [accentCyan, primaryBlue],
  );

  static const LinearGradient darkWaterGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [darkLightBlue, darkPrimaryBlue],
  );

  static const LinearGradient darkProgressGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [darkAccentCyan, darkPrimaryBlue],
  );
}
