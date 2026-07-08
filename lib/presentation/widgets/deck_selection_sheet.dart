import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/audio/sfx.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/models/deck.dart';
import '../providers/deck_provider.dart';
import 'pixel.dart';

/// Deck picker that pops out of the VS cap: a pixel-framed panel scales up
/// from the bottom-center with a springy overshoot and the deck rows cascade
/// in. Picking a deck plays the battle-start jingle.
Future<void> showDeckSelectionSheet(BuildContext context) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'decks',
    barrierColor: Colors.black.withValues(alpha: 0.45),
    transitionDuration: const Duration(milliseconds: 380),
    pageBuilder: (_, __, ___) => const _DeckSelectionPanel(),
    transitionBuilder: (context, anim, _, child) {
      final curved = CurvedAnimation(
        parent: anim,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: anim,
        child: ScaleTransition(
          // Grow out of the VS cap (bottom center of the screen).
          alignment: const Alignment(0, 0.92),
          scale: Tween(begin: 0.06, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class _DeckSelectionPanel extends ConsumerWidget {
  const _DeckSelectionPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decks =
        ref.watch(deckNotifierProvider).where((d) => d.isBattleReady).toList();
    final p = context.palette;

    return SafeArea(
      child: Align(
        alignment: const Alignment(0, 0.55),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 96),
            child: PixelBox(
              width: 320,
              color: p.surface,
              radius: 16,
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.flash_on, color: AppColors.yellow, size: 20),
                      const SizedBox(width: 6),
                      Text('Escolha seu deck', style: AppTextStyles.h3),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (decks.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'Nenhum deck pronto para batalha. Um deck precisa de ao '
                        'menos um Pokémon Básico ou EX.',
                        style: AppTextStyles.body,
                      ),
                    )
                  else
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.45,
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: decks.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, i) => _CascadeIn(
                          delayMs: 50 + i * 55,
                          child: _DeckRow(
                            deck: decks[i],
                            onTap: () {
                              sfx(Sfx.battleStart);
                              Navigator.pop(context);
                              context.go('/deck/${decks[i].id}/battle');
                            },
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Fades/slides a child in after [delayMs] — used to cascade the deck rows.
class _CascadeIn extends StatefulWidget {
  final int delayMs;
  final Widget child;
  const _CascadeIn({required this.delayMs, required this.child});

  @override
  State<_CascadeIn> createState() => _CascadeInState();
}

class _CascadeInState extends State<_CascadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.25), end: Offset.zero)
            .animate(curved),
        child: widget.child,
      ),
    );
  }
}

class _DeckRow extends StatelessWidget {
  final Deck deck;
  final VoidCallback onTap;
  const _DeckRow({required this.deck, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final cover = deck.coverCardId != null && deck.coverCardId!.isNotEmpty
        ? deck.pokemonCards.where((c) => c.card.id == deck.coverCardId).firstOrNull
        : deck.pokemonCards.firstOrNull;
    final count = deck.pokemonCards.fold<int>(0, (s, c) => s + c.quantity);

    return PixelButton(
      onTap: onTap,
      color: p.surface2,
      sound: null, // battle jingle plays from the caller
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: p.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: p.borderStrong, width: 2),
            ),
            child: cover?.card.imageUrl == null
                ? const Icon(Icons.catching_pokemon, color: AppColors.blue)
                : CachedNetworkImage(
                    imageUrl: cover!.card.imageUrl!,
                    fit: BoxFit.contain,
                    memCacheWidth: 96,
                    filterQuality: FilterQuality.none,
                    errorWidget: (_, __, ___) =>
                        const Icon(Icons.catching_pokemon, color: AppColors.blue),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(deck.name,
                    style: AppTextStyles.label
                        .copyWith(fontSize: 15, color: p.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text('$count Pokémon', style: AppTextStyles.caption),
              ],
            ),
          ),
          const Icon(Icons.play_arrow_rounded, color: AppColors.blue, size: 26),
        ],
      ),
    );
  }
}
