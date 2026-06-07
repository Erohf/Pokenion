import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class HpTracker extends StatelessWidget {
  final int currentHp;
  final int maxHp;
  final ValueChanged<int>? onChanged;

  const HpTracker({
    super.key,
    required this.currentHp,
    required this.maxHp,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'LIFE',
          style: AppTextStyles.lifeLabel,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _HpButton(
              icon: Icons.remove,
              onPressed: () => onChanged?.call(currentHp - 10),
            ),
            const SizedBox(width: 8),
            Container(
              width: 80,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.borderVariant,
                borderRadius: BorderRadius.circular(100),
              ),
              alignment: Alignment.center,
              child: Text(
                '$currentHp',
                style: AppTextStyles.hpValue,
              ),
            ),
            const SizedBox(width: 8),
            _HpButton(
              icon: Icons.add,
              onPressed: () => onChanged?.call(currentHp + 10),
            ),
          ],
        ),
      ],
    );
  }
}

class _HpButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _HpButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.borderVariant,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: AppColors.blue,
          size: 16,
        ),
      ),
    );
  }
}
