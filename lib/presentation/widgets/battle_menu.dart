import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
          // Left button (Decks)
          Positioned(
            left: 30,
            bottom: 24,
            child: _MenuButton(
              icon: Icons.bookmark_outline,
              onPressed: () => context.go('/'),
            ),
          ),
          // Right button (User)
          Positioned(
            right: 30,
            bottom: 24,
            child: _MenuButton(
              icon: Icons.person_outline,
              onPressed: () => context.go('/profile'),
            ),
          ),
          // Center button (Home/Action)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => context.go('/'),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: AppColors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'VS',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
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
