// lib/theme/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF4CAF50); 
  static const Color secondary = Color(0xFFFFC107); // Amber
  // FIX: Add accent, pointing to the same color value
  static const Color accent = Color(0xFFFFC107); 
  static const Color background = Color(0xFFF5F5F5); 
  // ... (rest of the colors)
   static const Color lightBackground = Color(0xFFFFFFFF); // FIX: Added lightBackground
  static const Color white = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF333333); // Dark Gray text
  static const Color darkText = Color(0xFF000000);
  static const Color lightText = Color(0xFF757575); // Lighter Gray text
  static const Color error = Color(0xFFF44336); // FIX: Added error
}