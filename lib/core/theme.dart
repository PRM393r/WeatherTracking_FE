import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Adapted from DESIGN.md (Figma editorial system → weather app palette)
class AppColors {
  // Core (from DESIGN.md monochrome system)
  static const ink = Color(0xFF111111);
  static const canvas = Color(0xFFFFFFFF);
  static const surfaceSoft = Color(0xFFF7F7F5);
  static const hairline = Color(0xFFE6E6E6);

  // Weather-adapted color blocks (replaces Figma's lime/lilac/cream)
  static const blockSky = Color(0xFFBDE0F7);       // clear/sunny
  static const blockStorm = Color(0xFF9BAEC8);     // cloudy/storm
  static const blockRain = Color(0xFFC5D8F4);      // rain
  static const blockSunset = Color(0xFFF4D6B0);    // evening/hot
  static const blockMint = Color(0xFFC8E6CD);      // good AQI
  static const blockCoral = Color(0xFFF3C9B6);     // high temp warning
  static const blockNavy = Color(0xFF1A2744);      // night mode / dark card

  // Semantic
  static const success = Color(0xFF1EA64A);
  static const warning = Color(0xFFE88C30);
  static const error = Color(0xFFD93025);
}

class AppTheme {
  static ThemeData get light {
    final base = GoogleFonts.interTextTheme();
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.blockSky,
        brightness: Brightness.light,
        surface: AppColors.canvas,
      ),
      scaffoldBackgroundColor: AppColors.canvas,
      textTheme: base.copyWith(
        // display-xl equivalent: 86px → 36px mobile scale
        displayLarge: GoogleFonts.inter(
          fontSize: 36, fontWeight: FontWeight.w300,
          letterSpacing: -0.8, color: AppColors.ink,
        ),
        // headline
        headlineMedium: GoogleFonts.inter(
          fontSize: 24, fontWeight: FontWeight.w600,
          letterSpacing: -0.24, color: AppColors.ink,
        ),
        // card-title
        titleLarge: GoogleFonts.inter(
          fontSize: 20, fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        // body
        bodyLarge: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w400,
          letterSpacing: -0.14, color: AppColors.ink,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w400,
          color: AppColors.ink,
        ),
        // caption / eyebrow (mono feel via letter spacing)
        labelSmall: GoogleFonts.jetBrainsMono(
          fontSize: 11, fontWeight: FontWeight.w400,
          letterSpacing: 0.6, color: AppColors.ink.withValues(alpha: 0.6),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.canvas,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.ink, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: AppColors.canvas,
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: const StadiumBorder(), // pill = rounded.pill
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: const StadiumBorder(),
          side: const BorderSide(color: AppColors.ink),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.ink,
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
