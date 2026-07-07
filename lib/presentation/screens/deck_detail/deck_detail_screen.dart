import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/models/deck.dart';
import '../../providers/deck_provider.dart';
import '../../providers/battle_provider.dart';
import '../../widgets/card_thumbnail.dart';
import '../../widgets/pokemon_picker_dialog.dart';
import '../../widgets/add_pokemon_dialog.dart';
import '../../widgets/name_dialog.dart';

class DeckDetailScreen extends ConsumerWidget {
  final String deckId;
  const DeckDetailScreen({super.key, required this.deckId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deck = ref.watch(deckNotifierProvider.select(
      (decks) => decks.where((d) => d.id == deckId).firstOrNull,
    ));

    // If this deck is the one being used in an ongoing battle, block editing.
    final inBattle = ref.watch(battleProvider.select(
      (s) => s.inProgress && s.deckId == deckId,
    ));

    if (deck == null) {
      return const Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(child: Text('Deck não encontrado.', style: TextStyle(color: Colors.white))),
      );
    }

    final cards = deck.pokemonCards;
    final total = cards.fold<int>(0, (s, c) => s + c.quantity);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: GestureDetector(
          onTap: inBattle ? null : () => _rename(context, ref, deck),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(deck.name,
                    style: AppTextStyles.h3, overflow: TextOverflow.ellipsis),
              ),
              if (!inBattle) ...[
                const SizedBox(width: 6),
                const Icon(Icons.edit, size: 16, color: AppColors.textSecondary),
              ],
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (inBattle)
              Container(
                width: double.infinity,
                color: AppColors.blue.withValues(alpha: 0.15),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Text('Deck em uso na batalha — edição bloqueada.',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.blueLight)),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  Text('Pokémon', style: AppTextStyles.h2),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.blue.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('$total/60',
                        style: AppTextStyles.caption.copyWith(
                            color: AppColors.blue, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 0.74,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: cards.length + (inBattle ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (!inBattle && index == 0) {
                      return _AddTile(onTap: () => _addCard(context, ref, deck));
                    }
                    final dc = cards[index - (inBattle ? 0 : 1)];
                    final isCover = deck.coverCardId == dc.card.id;
                    return _CardTile(
                      imageUrl: dc.card.imageUrl,
                      hp: dc.effectiveHp,
                      quantity: dc.quantity,
                      isCover: isCover,
                      showRemove: !inBattle,
                      onRemove: () => ref
                          .read(deckNotifierProvider.notifier)
                          .removeCard(deck.id, dc.card.id),
                      onLongPress: inBattle
                          ? null
                          : () => _cardActions(context, ref, deck, dc.card.id, isCover),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: deck.isBattleReady
                      ? () => context.push('/deck/${deck.id}/battle')
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    disabledBackgroundColor: AppColors.surface2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    deck.isBattleReady
                        ? 'INICIAR BATALHA'
                        : 'Adicione um Pokémon Básico ou EX',
                    style: AppTextStyles.buttonText.copyWith(
                      fontSize: 15,
                      color: deck.isBattleReady ? Colors.white : AppColors.textDim,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addCard(BuildContext context, WidgetRef ref, Deck deck) async {
    final card = await showPokemonPickerDialog(context);
    if (card == null || !context.mounted) return;
    final hp = await showAddPokemonDialog(context, card);
    if (hp == null) return;
    await ref.read(deckNotifierProvider.notifier).addCard(deck.id, card, hp: hp);
  }

  Future<void> _rename(BuildContext context, WidgetRef ref, Deck deck) async {
    final name = await showNameDialog(context,
        title: 'Renomear Deck', hint: 'Nome do deck', confirm: 'Salvar', initial: deck.name);
    if (name != null) {
      ref.read(deckNotifierProvider.notifier).renameDeck(deck.id, name);
    }
  }

  Future<void> _cardActions(
      BuildContext context, WidgetRef ref, Deck deck, String cardId, bool isCover) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.image_outlined, color: AppColors.blue),
              title: Text(isCover ? 'Remover como capa' : 'Definir como capa',
                  style: AppTextStyles.label),
              onTap: () {
                ref.read(deckNotifierProvider.notifier).setCover(deck.id, isCover ? '' : cardId);
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: AppColors.red),
              title: Text('Remover do deck',
                  style: AppTextStyles.label.copyWith(color: AppColors.red)),
              onTap: () {
                ref.read(deckNotifierProvider.notifier).removeCard(deck.id, cardId);
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AddTile extends StatelessWidget {
  final VoidCallback onTap;
  const _AddTile({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: const Center(
          child: CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.blue,
            child: Icon(Icons.add, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}

class _CardTile extends StatelessWidget {
  final String? imageUrl;
  final int hp;
  final int quantity;
  final bool isCover;
  final bool showRemove;
  final VoidCallback onRemove;
  final VoidCallback? onLongPress;

  const _CardTile({
    required this.imageUrl,
    required this.hp,
    required this.quantity,
    required this.isCover,
    required this.showRemove,
    required this.onRemove,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface2,
                borderRadius: BorderRadius.circular(12),
                border: isCover
                    ? Border.all(color: AppColors.blue, width: 2)
                    : Border.all(color: AppColors.border),
              ),
              padding: const EdgeInsets.all(6),
              child: Column(
                children: [
                  Expanded(
                    child: CardThumbnail(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Text('$hp HP',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
          if (isCover)
            const Positioned(
              left: 4,
              bottom: 4,
              child: Icon(Icons.push_pin, size: 14, color: AppColors.blue),
            ),
          if (quantity > 1)
            Positioned(
              left: 4,
              top: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('x$quantity',
                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            ),
          if (showRemove)
            Positioned(
              right: 2,
              top: 2,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
                  child: const Icon(Icons.remove, color: Colors.white, size: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
