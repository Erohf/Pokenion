import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/models/deck.dart';
import '../../providers/deck_provider.dart';
import '../../providers/settings_provider.dart';
import '../../../core/audio/sfx.dart';
import '../../widgets/ad_banner.dart';
import '../../widgets/card_thumbnail.dart';
import '../../widgets/battle_menu.dart';
import '../../widgets/name_dialog.dart';
import '../../widgets/pixel.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decks = ref.watch(deckNotifierProvider);
    final plan = ref.watch(settingsProvider).plan;

    return Scaffold(
      backgroundColor: context.palette.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (plan.showsAds) const AdBanner(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                children: [
                  if (decks.isEmpty)
                    const _EmptyState()
                  else
                    for (final deck in decks)
                      _DeckSection(
                        deck: deck,
                        onOpen: () => context.push('/deck/${deck.id}'),
                        onDelete: () => _confirmDelete(context, ref, deck),
                      ),
                  const SizedBox(height: 8),
                  Center(
                    child: _AddDeckButton(
                      onTap: () => _createDeck(context, ref, plan),
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _BottomBar(),
    );
  }

  Future<void> _createDeck(BuildContext context, WidgetRef ref, PlanType plan) async {
    if (ref.read(deckNotifierProvider).length >= plan.maxDecks) {
      _snack(context,
          'Limite de ${plan.maxDecks} decks atingido. Assine o Premium para mais.');
      return;
    }
    final name = await showNameDialog(context,
        title: 'Novo Deck', hint: 'Nome do deck', confirm: 'Criar');
    if (name == null || !context.mounted) return;
    // Open the editor in "new" mode. The deck is only persisted if the user
    // taps Salvar; tapping Cancelar discards it entirely.
    context.push('/deck/new', extra: name);
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Deck deck) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.palette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: ctx.palette.borderStrong, width: 2),
        ),
        title: Text('Apagar deck', style: AppTextStyles.h3),
        content: Text('Deseja apagar "${deck.name}"? Esta ação não pode ser desfeita.',
            style: AppTextStyles.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancelar',
                style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Apagar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (ok == true) {
      ref.read(deckNotifierProvider.notifier).removeDeck(deck.id);
    }
  }

  void _snack(BuildContext context, String msg) => showPixelSnack(context, msg);
}

class _DeckSection extends StatelessWidget {
  final Deck deck;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  const _DeckSection({required this.deck, required this.onOpen, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final cards = deck.pokemonCards;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: GestureDetector(
        onTap: onOpen,
        behavior: HitTestBehavior.opaque,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(deck.name,
                      style: AppTextStyles.h3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
                IconButton(
                  onPressed: () {
                    sfx(Sfx.back);
                    onDelete();
                  },
                  icon: const Icon(Icons.delete_outline, color: AppColors.blue),
                  tooltip: 'Apagar deck',
                ),
              ],
            ),
            const SizedBox(height: 8),
            PixelBox(
              color: p.surface,
              radius: 14,
              padding: const EdgeInsets.all(10),
              child: cards.isEmpty
                  ? SizedBox(
                      height: 56,
                      child: Center(
                        child: Text('Deck vazio — toque para adicionar cartas',
                            style: AppTextStyles.bodySmall),
                      ),
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final dc in cards.take(18))
                          Container(
                            width: 44,
                            height: 44,
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: p.surface2,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CardThumbnail(
                              imageUrl: dc.card.imageUrl,
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                            ),
                          ),
                        if (cards.length > 18)
                          _MoreChip(count: cards.length - 18),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreChip extends StatelessWidget {
  final int count;
  const _MoreChip({required this.count});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.palette.surface2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('+$count',
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
    );
  }
}

class _AddDeckButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddDeckButton({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return PixelButton(
      onTap: onTap,
      color: AppColors.blue,
      width: 58,
      height: 58,
      radius: 14,
      padding: EdgeInsets.zero,
      child: const Icon(Icons.add, color: Colors.white, size: 30),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.style_outlined, size: 64, color: AppColors.textDim),
          const SizedBox(height: 16),
          Text('Nenhum deck ainda.', style: AppTextStyles.body),
          const SizedBox(height: 4),
          Text('Toque no + para criar seu primeiro deck.',
              style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 132,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Align(alignment: Alignment.bottomCenter, child: BattleMenu()),
        ),
      ),
    );
  }
}
