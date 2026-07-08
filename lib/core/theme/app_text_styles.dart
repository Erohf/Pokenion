import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography for the "modern pixel" design language:
/// - Pixelify Sans: display / headings / buttons (modern pixel, very readable)
/// - Silkscreen: tiny retro tags and labels ("LIFE", stage badges, chips)
/// - VT323: big terminal-style digits (HP counters)
/// - Inter: body copy, where readability beats style
///
/// Heading/label styles omit `color` so they inherit the theme's onSurface
/// color and adapt to light/dark automatically.
class AppTextStyles {
  static TextStyle get h1 => GoogleFonts.pixelifySans(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        height: 1.1,
      );

  static TextStyle get h2 => GoogleFonts.pixelifySans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.15,
      );

  static TextStyle get h3 => GoogleFonts.pixelifySans(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        height: 1.2,
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

  static TextStyle get label => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get labelBold => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 11,
        color: AppColors.textDim,
      );

  /// Tiny retro tag ("LIFE", stage badges, chips). All-caps by nature.
  static TextStyle get pixelTag => GoogleFonts.silkscreen(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      );

  static TextStyle get lifeLabel => GoogleFonts.silkscreen(
        fontSize: 13,
        color: AppColors.blue,
        letterSpacing: 2.0,
      );

  /// Big pixel digits for HP counters and tallies.
  static TextStyle get hpValue => GoogleFonts.silkscreen(
        fontSize: 21,
        color: AppColors.textDark,
        height: 1.0,
      );

  // Used on colored buttons — callers set the color (usually white).
  static TextStyle get buttonText => GoogleFonts.pixelifySans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get turboTag => GoogleFonts.silkscreen(
        fontSize: 14,
        color: AppColors.blue,
      );
}
