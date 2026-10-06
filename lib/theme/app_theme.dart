import 'package:flutter/material.dart';

class AppColors {
  static const primaryGreen = Color(0xFF2E7D32);   // main brand / buttons
  static const primaryGreenDark = Color(0xFF1B5E20);
  static const accentOrange = Color(0xFFF57C00);   // CTAs, alerts, highlights
  static const background = Color(0xFFF7F6F1);     // warm off-white
  static const surface = Color(0xFFFFFFFF);
  static const textDark = Color(0xFF212121);
  static const textMuted = Color(0xFF6B6B6B);
  static const error = Color(0xFFC62828);
  static const success = Color(0xFF388E3C);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        primary: AppColors.primaryGreen,
        secondary: AppColors.accentOrange,
        surface: AppColors.surface,
        error: AppColors.error,
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textDark),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textDark),
        bodyLarge: TextStyle(fontSize: 18, color: AppColors.textDark),
        bodyMedium: TextStyle(fontSize: 16, color: AppColors.textMuted),
        labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      fontFamily: 'NotoSans',

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          elevation: 2,
        ),
      ),

      cardTheme: const CardThemeData(
  color: AppColors.surface,
  elevation: 3,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
  margin: EdgeInsets.symmetric(vertical: 8),
),


      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }
}
