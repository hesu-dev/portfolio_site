import 'package:flutter/material.dart';

/// 앱 전체에서 사용하는 색상 팔레트
class AppColors {
  // Background Colors
  static const Color background = Color(0xFF121212); // Deep Dark Grey
  static const Color surface = Color(0xFF1E1E1E);    // Card Background
  static const Color surfaceVariant = Color(0xFF2C2C2C); // Slightly lighter surface

  // Primary Action Colors
  static const Color primary = Color(0xFF3B82F6);    // Electric Blue
  static const Color primaryDark = Color(0xFF2563EB); // Darker Blue
  static const Color secondary = Color(0xFF10B981);  // Emerald Green (Positive/Success)
  
  // Alert/Status Colors
  static const Color error = Color(0xFFEF4444);      // Red (Danger)
  static const Color warning = Color(0xFFF59E0B);    // Amber (Warning)
  static const Color info = Color(0xFF3B82F6);       // Blue (Info)

  // Weather Condition Colors (Optional)
  static const Color sunny = Color(0xFFFFD60A);
  static const Color rainy = Color(0xFF60A5FA);
  static const Color cloudy = Color(0xFF94A3B8);

  // Text Colors
  static const Color textHighEmphasis = Color(0xFFFFFFFF); // Primary Text
  static const Color textMediumEmphasis = Color(0xFFA0A0A0); // Secondary Text
  static const Color textLowEmphasis = Color(0xFF6B7280);    // Disabled/Hint Text

  // Divider/Border Colors
  static const Color divider = Color(0xFF374151);    // Dark Grey Border

  // --- Light Mode Colors ---
  static const Color lightBackground = Color(0xFFF3F4F6); // Soft Grey
  static const Color lightSurface = Color(0xFFFFFFFF);    // White
  static const Color lightSurfaceVariant = Color(0xFFE5E7EB); // Light Grey
  static const Color lightTextHighEmphasis = Color(0xFF111827); // Almost Black
  static const Color lightTextMediumEmphasis = Color(0xFF4B5563); // Grey
  static const Color lightTextLowEmphasis = Color(0xFF9CA3AF);    // Light Grey
  static const Color lightDivider = Color(0xFFE5E7EB);
}
