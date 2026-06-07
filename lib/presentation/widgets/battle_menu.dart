import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class BattleMenu extends StatelessWidget {
  const BattleMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 328,
      height: 112,
      child: Stack(
        children: [
          // Background
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 32,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          // Left button (Bookmarks)
          Positioned(
            left: 30,
            bottom: 24,
            child: _MenuButton(
              icon: Icons.bookmark_outline,
              onPressed: () {},
            ),
          ),
          // Right button (User)
          Positioned(
            right: 30,
            bottom: 24,
            child: _MenuButton(
              icon: Icons.person_outline,
              onPressed: () {},
            ),
          ),
          // Center button (Coin/Action)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.copyright, // Representing the coin/logo
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _MenuButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(42),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}
