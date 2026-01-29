import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTextStyles {
  static final TextStyle headerLogo = GoogleFonts.notoSansKr(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final TextStyle navItem = GoogleFonts.notoSansKr(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static final TextStyle heroTitle = GoogleFonts.notoSansKr(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static final TextStyle heroSubtitle = GoogleFonts.notoSansKr(
    fontSize: 18,
    color: Colors.white,
  );

  static final TextStyle sectionTitle = GoogleFonts.notoSansKr(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final TextStyle body = GoogleFonts.notoSansKr(
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static final TextStyle caption = GoogleFonts.notoSansKr(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
  
  static final TextStyle price = GoogleFonts.notoSansKr(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
}
