import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class StatusBadge extends StatelessWidget {
  final Widget icon;
  final String? label;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const StatusBadge({
    super.key,
    required this.icon,
    this.label,
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: backgroundColor ?? AppColors.surfaceVariant,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: icon,
          ),
          if (label != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: Text(
                label!,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
