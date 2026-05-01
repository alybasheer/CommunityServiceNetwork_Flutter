import 'package:flutter/material.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.safetyBlue,
      brightness: Brightness.light,
      primary: AppColors.safetyBlue,
      secondary: AppColors.steelBlue,
      error: AppColors.emergencyRed,
      surface: AppColors.pureWhite,
    );

    return _baseTheme(colorScheme).copyWith(
      scaffoldBackgroundColor: AppColors.background,
      cardColor: AppColors.pureWhite,
      appBarTheme: _appBarTheme(colorScheme),
    );
  }

  static ThemeData get darkTheme {
    const surface = Color(0xFF111827);
    const scaffold = Color(0xFF0B1220);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.steelBlue,
      brightness: Brightness.dark,
      primary: const Color(0xFF60A5FA),
      secondary: const Color(0xFF38BDF8),
      error: const Color(0xFFF87171),
      surface: surface,
    ).copyWith(
      onSurface: const Color(0xFFE5E7EB),
      outline: const Color(0xFF334155),
    );

    return _baseTheme(colorScheme).copyWith(
      scaffoldBackgroundColor: scaffold,
      cardColor: surface,
      appBarTheme: _appBarTheme(colorScheme),
    );
  }

  static ThemeData _baseTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final borderColor =
        isDark ? const Color(0xFF334155) : AppColors.lightBorderGray;

    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      fontFamily: 'Poppins',
      visualDensity: VisualDensity.adaptivePlatformDensity,
      dividerColor: borderColor,
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF172033) : AppColors.background,
        hintStyle: TextStyle(
          color: isDark ? const Color(0xFF94A3B8) : AppColors.mediumGray,
        ),
        labelStyle: TextStyle(
          color: isDark ? const Color(0xFFCBD5E1) : AppColors.mediumGray,
        ),
        prefixIconColor: colorScheme.primary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.35)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return isDark ? const Color(0xFFCBD5E1) : Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary.withValues(alpha: 0.35);
          }
          return isDark ? const Color(0xFF334155) : AppColors.lightBorderGray;
        }),
      ),
    );
  }

  static AppBarTheme _appBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 0,
      backgroundColor: colorScheme.primary,
      foregroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        fontFamily: 'Poppins',
      ),
    );
  }
}
