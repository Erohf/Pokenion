import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../providers/battle_provider.dart';
import 'deck_selection_sheet.dart';
import 'coin_flip_dialog.dart';

/// Bottom navigation bar with a context-aware center action:
/// - On the battle screen → Coin Flip.
/// - Elsewhere with a battle in progress → return to the battle.
/// - Otherwise → pick a deck and start a new battle.
class BattleMenu extends ConsumerWidget {
  final bool inBattleScreen;
  const BattleMenu({super.key, this.inBattleScreen = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final battle = ref.watch(battleProvider);

    void onCenter() {
      if (inBattleScreen) {
        showCoinFlipDialog(context);
      } else if (battle.inProgress && battle.deckId != null) {
        context.go('/deck/${battle.deckId}/battle');
      } else {
        showDeckSelectionSheet(context);
      }
    }

    final centerIsCoin = inBattleScreen;

    return SizedBox(
      width: 328,
      height: 112,
      child: Stack(
        children: [
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
          Positioned(
            left: 30,
            bottom: 24,
            child: _MenuButton(
              icon: Icons.bookmark_outline,
              onPressed: () => context.go('/'),
            ),
          ),
          Positioned(
            right: 30,
            bottom: 24,
            child: _MenuButton(
              icon: Icons.person_outline,
              onPressed: () => context.go('/profile'),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: onCenter,
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
                      decoration: const BoxDecoration(
                        color: AppColors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: centerIsCoin
                            ? const Icon(Icons.monetization_on_outlined,
                                color: Colors.white, size: 26)
                            : const Text('VS',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
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
  const _MenuButton({required this.icon, required this.onPressed});

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
