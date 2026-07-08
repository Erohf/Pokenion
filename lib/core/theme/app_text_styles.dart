import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography for the app. Uses Google Fonts (Space Grotesk / Inter / Poppins)
/// so no font binaries need to be bundled.
///
/// Heading/label styles intentionally omit `color` so they inherit the theme's
/// onSurface color (white in dark, near-black in light) and adapt to light/dark
/// automatically. Muted styles keep an explicit mid-gray that stays legible on
/// both backgrounds.
class AppTextStyles {
  static TextStyle get h1 => GoogleFonts.spaceGrotesk(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get h2 => GoogleFonts.spaceGrotesk(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get h3 => GoogleFonts.spaceGrotesk(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get body => GoogleFonts.inter(
        fontSize: 14,
        color: AppColors.textSecondary,
        height: 1.5,
      );

  static TextStyle get bodyBold => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        color: AppColors.textSecondary,
      );

  static TextStyle get label => GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get labelBold => GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 11,
        color: AppColors.textDim,
      );

  static TextStyle get lifeLabel => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.blue,
        letterSpacing: 1.4,
      );

  static TextStyle get hpValue => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
        letterSpacing: 2.0,
      );

  // Used on colored (blue) buttons — callers set the color (usually white).
  static TextStyle get buttonText => GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get turboTag => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.blue,
      );
}
