import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Theme-dependent colors. Only the tokens that actually change between light
/// and dark live here; brand/semantic colors (blue, red, green, energy…) stay
/// as constants in [AppColors] so const widgets keep working.
///
/// Access via `context.palette`.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  final Color bg;
  final Color surface;
  final Color surface2;
  final Color surfaceVariant; // light-ish panel used on the battle card / AD
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textDim;
  final Color adBg;
  final Color adText;

  const AppPalette({
    required this.bg,
    required this.surface,
    required this.surface2,
    required this.surfaceVariant,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDim,
    required this.adBg,
    required this.adText,
  });

  static const dark = AppPalette(
    bg: AppColors.bg,
    surface: AppColors.surface,
    surface2: AppColors.surface2,
    surfaceVariant: AppColors.surfaceVariant,
    border: AppColors.border,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textDim: AppColors.textDim,
    adBg: AppColors.surfaceVariant,
    adText: AppColors.textDark,
  );

  static const light = AppPalette(
    bg: Color(0xFFF5F5F5),
    surface: Color(0xFFFFFFFF),
    surface2: Color(0xFFF0F0F2),
    surfaceVariant: Color(0xFFECECEE),
    border: Color(0xFFE4E5E7),
    textPrimary: Color(0xFF1B1B22),
    textSecondary: Color(0xFF6B6F76),
    textDim: Color(0xFFA2A6AD),
    adBg: Color(0xFFF0F0F1),
    adText: Color(0xFF303236),
  );

  @override
  AppPalette copyWith({
    Color? bg,
    Color? surface,
    Color? surface2,
    Color? surfaceVariant,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? textDim,
    Color? adBg,
    Color? adText,
  }) =>
      AppPalette(
        bg: bg ?? this.bg,
        surface: surface ?? this.surface,
        surface2: surface2 ?? this.surface2,
        surfaceVariant: surfaceVariant ?? this.surfaceVariant,
        border: border ?? this.border,
        textPrimary: textPrimary ?? this.textPrimary,
        textSecondary: textSecondary ?? this.textSecondary,
        textDim: textDim ?? this.textDim,
        adBg: adBg ?? this.adBg,
        adText: adText ?? this.adText,
      );

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textDim: Color.lerp(textDim, other.textDim, t)!,
      adBg: Color.lerp(adBg, other.adBg, t)!,
      adText: Color.lerp(adText, other.adText, t)!,
    );
  }
}

extension PaletteX on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.dark;
}
