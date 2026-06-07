import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const h1 = TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const h2 = TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const h3 = TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static const body = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    color: AppColors.textSecondary,
    height: 1.5,
  );
  
  static const bodyBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.textSecondary,
  );
  
  static const bodySmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    color: AppColors.textSecondary,
  );
  
  static const label = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static const labelBold = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const caption = TextStyle(
    fontFamily: 'Inter',
    fontSize: 11,
    color: AppColors.textDim,
  );

  // Figma specific styles
  static const lifeLabel = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.blue,
    letterSpacing: 1.4,
  );

  static const hpValue = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
    letterSpacing: 2.0,
  );

  static const buttonText = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const turboTag = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.blue,
  );
}
