import 'package:flutter/material.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_text_styles.dart';

/// Placeholder ad banner shown to Freemium users.
class AdBanner extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final double height;

  const AdBanner({
    super.key,
    this.margin = EdgeInsets.zero,
    this.height = 90,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      height: height,
      width: double.infinity,
      margin: margin,
      alignment: Alignment.center,
      color: p.adBg,
      child: Text('AD', style: AppTextStyles.h1.copyWith(color: p.adText)),
    );
  }
}
