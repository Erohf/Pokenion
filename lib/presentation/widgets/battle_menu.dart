import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/audio/sfx.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_palette.dart';
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
        sfx(Sfx.tap);
        showCoinFlipDialog(context);
      } else if (battle.inProgress && battle.deckId != null) {
        sfx(Sfx.tap);
        context.go('/deck/${battle.deckId}/battle');
      } else {
        sfx(Sfx.tap);
        showDeckSelectionSheet(context);
      }
    }

    return SizedBox(
      width: 328,
      height: 112,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 32,
            child: Container(
              decoration: BoxDecoration(
                color: context.palette.surfaceVariant,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 30,
            bottom: 24,
            child: _MenuButton(
              icon: Icons.bookmark_outline,
              onPressed: () {
                sfx(Sfx.tap);
                context.go('/');
              },
            ),
          ),
          Positioned(
            right: 30,
            bottom: 24,
            child: _MenuButton(
              icon: Icons.person_outline,
              onPressed: () {
                sfx(Sfx.tap);
                context.go('/profile');
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: VsButton(
                coinMode: inBattleScreen,
                onTap: onCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The center action button: a glowing gradient orb with a lightning bolt
/// behind slanted "VS" lettering (per the prototype), or a coin icon during
/// battle. Scales down while pressed and idles with a soft glow pulse.
class VsButton extends StatefulWidget {
  final bool coinMode;
  final VoidCallback onTap;
  const VsButton({super.key, required this.coinMode, required this.onTap});

  @override
  State<VsButton> createState() => _VsButtonState();
}

class _VsButtonState extends State<VsButton>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.88 : 1.0,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: AnimatedBuilder(
          animation: _pulse,
          builder: (context, child) {
            final glow = 0.25 + 0.20 * _pulse.value;
            return Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? const Color(0xFF23233A) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blue.withValues(alpha: glow),
                    blurRadius: 22 + 8 * _pulse.value,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: child,
            );
          },
          child: Center(
            child: Container(
              width: 54,
              height: 54,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.blueLight, AppColors.blue, AppColors.blueDark],
                ),
              ),
              child: widget.coinMode
                  ? const Icon(Icons.monetization_on_outlined,
                      color: Colors.white, size: 26)
                  : const _VsEmblem(),
            ),
          ),
        ),
      ),
    );
  }
}

/// Lightning bolt + slanted "VS" lettering, like the prototype emblem.
class _VsEmblem extends StatelessWidget {
  const _VsEmblem();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(size: const Size(30, 34), painter: _BoltPainter()),
        Transform.rotate(
          angle: -0.12,
          child: const Text(
            'VS',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 19,
              letterSpacing: 0.5,
              shadows: [
                Shadow(color: Color(0x662A5FCC), offset: Offset(0, 2), blurRadius: 2),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BoltPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final path = Path()
      ..moveTo(w * 0.62, 0)
      ..lineTo(w * 0.18, h * 0.56)
      ..lineTo(w * 0.46, h * 0.56)
      ..lineTo(w * 0.38, h)
      ..lineTo(w * 0.86, h * 0.42)
      ..lineTo(w * 0.55, h * 0.42)
      ..close();
    canvas.drawPath(
      path,
      Paint()..color = Colors.white.withValues(alpha: 0.30),
    );
  }

  @override
  bool shouldRepaint(covariant _BoltPainter oldDelegate) => false;
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const _MenuButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.blue,
      borderRadius: BorderRadius.circular(42),
      child: InkWell(
        borderRadius: BorderRadius.circular(42),
        onTap: onPressed,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}
