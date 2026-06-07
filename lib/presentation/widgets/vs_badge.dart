import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class VsBadge extends StatelessWidget {
  final double size;

  const VsBadge({
    super.key,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.blueDark,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.blue,
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        'VS',
        style: AppTextStyles.labelBold.copyWith(
          color: AppColors.blueLight,
          fontSize: size * 0.4,
        ),
      ),
    );
  }
}
