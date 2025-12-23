// lib/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'app_colors.dart'; 

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    
    // FIX: Using const and correctly accessing AppColors
    colorScheme: const ColorScheme.light( 
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.white,
      background: AppColors.background,
      error: AppColors.error, 
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.text,
      onBackground: AppColors.text,
      onError: AppColors.white,
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.text, fontSize: 16),
      bodySmall: TextStyle(color: AppColors.lightText, fontSize: 14),
      titleLarge: TextStyle(color: AppColors.darkText, fontSize: 22, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: AppColors.text, fontSize: 18, fontWeight: FontWeight.w500),
      labelLarge: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightBackground, // FIX: lightBackground used correctly
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      labelStyle: const TextStyle(color: AppColors.lightText),
      hintStyle: const TextStyle(color: AppColors.lightText),
    ),
    
     /*FIX: CardTheme must be const or explicitly CardThemeData
    cardTheme: const CardTheme(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),*/

    scaffoldBackgroundColor: AppColors.background,
    useMaterial3: true,
  );
}