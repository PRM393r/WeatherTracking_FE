import 'package:flutter/material.dart';

class SmartHomeTheme {
  // 1. Colors
  static const Color backgroundColor = Color(0xFFF7F9FC); // Off-white
  static const Color primaryAccent = Color(0xFF0A3F5C);   // Deep Navy Blue
  static const Color secondaryColor = Color(0xFFE3F0F8);  // Soft Light Blue

  // 2. Soft UI Shadows
  static const BoxShadow softShadow = BoxShadow(
    color: Color(0x1A000000), // 10% Black
    blurRadius: 20,
    spreadRadius: 0,
    offset: Offset(0, 10),
  );

  // 3. Border Radius
  static final BorderRadius borderRadiusStandard = BorderRadius.circular(24.0);
  static final BorderRadius borderRadiusLarge = BorderRadius.circular(30.0);

  // General App ThemeData
  static ThemeData get themeData {
    return ThemeData(
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryAccent,
      colorScheme: const ColorScheme.light(
        primary: primaryAccent,
        secondary: secondaryColor,
        surface: backgroundColor,
      ),
      fontFamily: 'Inter', // Hoặc font chữ bo tròn mà bạn thích
    );
  }
}
