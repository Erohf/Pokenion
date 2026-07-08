import 'package:flutter/material.dart';
import '../../core/theme/app_palette.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  // When null, these fall back to the current theme's palette.
  final Color? color;
  final Color? borderColor;
  final bool showBorder;
  final double? width;
  final double? height;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 14,
    this.color,
    this.borderColor,
    this.showBorder = true,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final border = showBorder ? (borderColor ?? p.border) : null;
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? p.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border != null ? Border.all(color: border) : null,
      ),
      child: child,
    );
  }
}
