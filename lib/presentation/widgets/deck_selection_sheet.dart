import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/models/deck.dart';
import '../providers/deck_provider.dart';

/// Minimalist animated deck list shown when starting a battle (VS button).
Future<void> showDeckSelectionSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => const _DeckSelectionSheet(),
  );
}

class _DeckSelectionSheet extends ConsumerWidget {
  const _DeckSelectionSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decks = ref.watch(deckNotifierProvider).where((d) => d.isBattleReady).toList();

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(offset: Offset(0, (1 - t) * 40), child: child),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Escolha um deck', style: AppTextStyles.h3),
              const SizedBox(height: 12),
              if (decks.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'Nenhum deck pronto. Um deck precisa de ao menos um Pokémon Básico ou EX.',
                    style: AppTextStyles.body,
                  ),
                )
              else
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: decks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) => _DeckRow(
                      deck: decks[i],
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/deck/${decks[i].id}/battle');
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
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
    final cover = deck.coverCardId != null && deck.coverCardId!.isNotEmpty
        ? deck.pokemonCards.where((c) => c.card.id == deck.coverCardId).firstOrNull
        : deck.pokemonCards.firstOrNull;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: cover?.card.imageUrl == null
                  ? const Icon(Icons.catching_pokemon, color: AppColors.blue)
                  : CachedNetworkImage(
                      imageUrl: cover!.card.imageUrl!,
                      fit: BoxFit.contain,
                      errorWidget: (_, __, ___) =>
                          const Icon(Icons.catching_pokemon, color: AppColors.blue),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(deck.name,
                  style: AppTextStyles.label.copyWith(fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
