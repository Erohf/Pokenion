import 'dart:ui' show ImageFilter;
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

/// Deck picker that bursts out of the VS button: the panel scales up from the
/// bottom-center with a springy overshoot over a blurred backdrop, and the
/// deck rows cascade in. Picking a deck plays the battle-start fanfare.
Future<void> showDeckSelectionSheet(BuildContext context) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'decks',
    barrierColor: Colors.black.withValues(alpha: 0.35),
    transitionDuration: const Duration(milliseconds: 420),
    pageBuilder: (_, __, ___) => const _DeckSelectionPanel(),
    transitionBuilder: (context, anim, _, child) {
      final curved = CurvedAnimation(
        parent: anim,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeInCubic,
      );
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5 * anim.value,
          sigmaY: 5 * anim.value,
        ),
        child: FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            // Grow out of the VS button (bottom center of the screen).
            alignment: const Alignment(0, 0.92),
            scale: Tween(begin: 0.05, end: 1.0).animate(curved),
            child: child,
          ),
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
          child: Container(
            width: 320,
            margin: const EdgeInsets.only(bottom: 96),
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
            decoration: BoxDecoration(
              color: p.surface,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: AppColors.blue.withValues(alpha: 0.35)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blue.withValues(alpha: 0.22),
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.flash_on, color: AppColors.blue, size: 20),
                    const SizedBox(width: 6),
                    Text('Escolha seu deck', style: AppTextStyles.h3),
                  ],
                ),
                const SizedBox(height: 12),
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
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) => _CascadeIn(
                        delayMs: 60 + i * 55,
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
    duration: const Duration(milliseconds: 300),
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

    return Material(
      color: p.surface2,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: p.surface,
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: AppColors.blue.withValues(alpha: 0.4)),
                ),
                child: cover?.card.imageUrl == null
                    ? const Icon(Icons.catching_pokemon, color: AppColors.blue)
                    : CachedNetworkImage(
                        imageUrl: cover!.card.imageUrl!,
                        fit: BoxFit.contain,
                        memCacheWidth: 96,
                        errorWidget: (_, __, ___) => const Icon(
                            Icons.catching_pokemon,
                            color: AppColors.blue),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(deck.name,
                        style: AppTextStyles.label.copyWith(fontSize: 15),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    Text('$count Pokémon', style: AppTextStyles.caption),
                  ],
                ),
              ),
              const Icon(Icons.play_arrow_rounded,
                  color: AppColors.blue, size: 26),
            ],
          ),
        ),
      ),
    );
  }
}
