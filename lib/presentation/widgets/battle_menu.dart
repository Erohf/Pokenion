import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/audio/sfx.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_palette.dart';
import '../providers/battle_provider.dart';
import 'deck_selection_sheet.dart';
import 'coin_flip_dialog.dart';
import 'pixel.dart';

/// Bottom navigation dock (modern pixel): a flat outlined tray with two square
/// key-cap buttons and the raised VS cap in the middle. The center action is
/// context-aware:
/// - On the battle screen → Coin Flip.
/// - Elsewhere with a battle in progress → return to the battle.
/// - Otherwise → pick a deck and start a new battle.
class BattleMenu extends ConsumerWidget {
  final bool inBattleScreen;
  const BattleMenu({super.key, this.inBattleScreen = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final battle = ref.watch(battleProvider);
    final p = context.palette;

    void onCenter() {
      if (inBattleScreen) {
        showCoinFlipDialog(context);
      } else if (battle.inProgress && battle.deckId != null) {
        context.go('/deck/${battle.deckId}/battle');
      } else {
        showDeckSelectionSheet(context);
      }
    }

    return SizedBox(
      width: 328,
      height: 108,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Dock tray
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 30,
            child: PixelBox(
              color: p.surface,
              radius: 18,
              shadowOffset: const Offset(0, 4),
              child: const SizedBox.expand(),
            ),
          ),
          Positioned(
            left: 26,
            bottom: 18,
            child: PixelIconButton(
              icon: Icons.style_outlined,
              color: AppColors.blue,
              onTap: () => context.go('/'),
            ),
          ),
          Positioned(
            right: 26,
            bottom: 18,
            child: PixelIconButton(
              icon: Icons.person_outline,
              color: AppColors.blue,
              onTap: () => context.go('/profile'),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: VsButton(coinMode: inBattleScreen, onTap: onCenter),
            ),
          ),
        ],
      ),
    );
  }
}

/// The raised center cap: flat blue rounded square with a pixel lightning bolt
/// and "VS" (or a pixel coin during battle). Idles with a tiny bob so it feels
/// alive without glowing.
class VsButton extends StatefulWidget {
  final bool coinMode;
  final VoidCallback onTap;
  const VsButton({super.key, required this.coinMode, required this.onTap});

  @override
  State<VsButton> createState() => _VsButtonState();
}

class _VsButtonState extends State<VsButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bob = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _bob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bob,
      builder: (context, child) {
        final dy = -2.0 * Curves.easeInOut.transform(_bob.value);
        return Transform.translate(offset: Offset(0, dy), child: child);
      },
      child: PixelButton(
        onTap: widget.onTap,
        color: AppColors.blue,
        width: 64,
        height: 64,
        radius: 16,
        padding: EdgeInsets.zero,
        sound: Sfx.tap,
        child: widget.coinMode
            // Same emblem as the login logo (catching_pokemon), no frame —
            // reads as the app's "ball" and doubles as the coin to flip.
            ? const Icon(Icons.catching_pokemon, color: Colors.white, size: 32)
            : const _VsEmblem(),
      ),
    );
  }
}

/// Blocky lightning bolt + "VS" in pixel lettering.
class _VsEmblem extends StatelessWidget {
  const _VsEmblem();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(size: const Size(26, 32), painter: _PixelBoltPainter()),
        Text(
          'VS',
          style: GoogleFonts.silkscreen(
            color: Colors.white,
            fontSize: 17,
            height: 1,
            shadows: [
              Shadow(
                color: AppColors.blueDark.withValues(alpha: 0.9),
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Bolt drawn as stacked blocks (real pixel-art construction, no smooth path).
class _PixelBoltPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.28);
    final u = size.width / 6; // pixel unit
    // (col,row,width) rows of the bolt, 8 rows tall
    const rows = [
      (3, 0, 2),
      (2, 1, 2),
      (2, 2, 2),
      (1, 3, 4),
      (2, 4, 3),
      (2, 5, 2),
      (1, 6, 2),
      (1, 7, 1),
    ];
    for (final (c, r, w) in rows) {
      canvas.drawRect(
        Rect.fromLTWH(c * u, r * size.height / 8, w * u, size.height / 8),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PixelBoltPainter oldDelegate) => false;
}

