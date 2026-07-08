import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/audio/sfx.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/models/deck.dart';
import '../../providers/deck_provider.dart';
import '../../providers/battle_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/card_thumbnail.dart';
import '../../widgets/pokemon_picker_dialog.dart';
import '../../widgets/add_pokemon_dialog.dart';
import '../../widgets/name_dialog.dart';
import '../../widgets/pixel.dart';

/// Deck editor. Works on a local *draft* copy: all changes (name, cards, cover)
/// are only committed to the store when the user taps Salvar. Cancelar (or a
/// discarded back navigation) throws the draft away — for a new deck that means
/// it is never created.
class DeckDetailScreen extends ConsumerStatefulWidget {
  /// Null when creating a brand-new deck; otherwise the id of the deck to edit.
  final String? deckId;
  final String? initialName;

  const DeckDetailScreen({super.key, required this.deckId, this.initialName});

  @override
  ConsumerState<DeckDetailScreen> createState() => _DeckDetailScreenState();
}

class _DeckDetailScreenState extends ConsumerState<DeckDetailScreen> {
  static const _uuid = Uuid();

  late Deck _draft;
  bool _dirty = false;
  bool _missing = false;

  bool get _isNew => widget.deckId == null;

  @override
  void initState() {
    super.initState();
    if (_isNew) {
      _draft = Deck(
        id: _uuid.v4(),
        name: (widget.initialName ?? '').trim().isEmpty
            ? 'Novo Deck'
            : widget.initialName!.trim(),
        createdAt: DateTime.now(),
      );
    } else {
      final existing = ref.read(deckNotifierProvider.notifier).byId(widget.deckId!);
      if (existing == null) {
        _missing = true;
        _draft = Deck(id: widget.deckId!, name: '', createdAt: DateTime.now());
      } else {
        _draft = existing;
      }
    }
  }

  void _mutate(Deck next) => setState(() {
        _draft = next;
        _dirty = true;
      });

  @override
  Widget build(BuildContext context) {
    // If this deck is the one used in an ongoing battle, block editing.
    final inBattle = ref.watch(battleProvider.select(
      (s) => s.inProgress && s.deckId == widget.deckId,
    ));

    if (_missing) {
      return Scaffold(
        backgroundColor: context.palette.bg,
        body: Center(
          child: Text('Deck não encontrado.',
              style: TextStyle(color: context.palette.textPrimary)),
        ),
      );
    }

    final cards = _draft.pokemonCards;
    final total = cards.fold<int>(0, (s, c) => s + c.quantity);
    final editable = !inBattle;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmDiscard()) {
          if (context.mounted) context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: context.palette.bg,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.palette.textPrimary),
            onPressed: () async {
              if (await _confirmDiscard() && context.mounted) context.pop();
            },
          ),
          title: GestureDetector(
            onTap: editable ? _rename : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(_draft.name,
                      style: AppTextStyles.h3, overflow: TextOverflow.ellipsis),
                ),
                if (editable) ...[
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
                    color: context.palette.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: context.palette.borderStrong, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: context.palette.shadow,
                        offset: const Offset(4, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 0.74,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: cards.length + (editable ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (editable && index == 0) {
                        return _AddTile(onTap: _addCard);
                      }
                      final dc = cards[index - (editable ? 1 : 0)];
                      final isCover = _draft.coverCardId == dc.card.id;
                      return _CardTile(
                        imageUrl: dc.card.imageUrl,
                        hp: dc.effectiveHp,
                        quantity: dc.quantity,
                        isCover: isCover,
                        showRemove: editable,
                        onRemove: () => _removeCard(dc.card.id),
                        onLongPress:
                            editable ? () => _cardActions(dc.card.id, isCover) : null,
                      );
                    },
                  ),
                ),
              ),
              if (editable) _saveCancelBar() else const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _saveCancelBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: PixelButton(
              onTap: _cancel,
              color: context.palette.surface2,
              height: 52,
              sound: null, // _cancel plays its own
              child: Text('Cancelar',
                  style: AppTextStyles.buttonText
                      .copyWith(color: context.palette.textSecondary)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: PixelButton(
              onTap: _save,
              color: AppColors.blue,
              height: 52,
              sound: null, // _save plays confirm
              child: Text('Salvar',
                  style: AppTextStyles.buttonText.copyWith(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Draft mutations ────────────────────────────────────────────────────

  Future<void> _addCard() async {
    final total = _draft.cards.fold<int>(0, (s, c) => s + c.quantity);
    if (total >= 60) {
      _snack('Limite de 60 Pokémon atingido.');
      return;
    }
    final card = await showPokemonPickerDialog(context);
    if (card == null || !mounted) return;
    final hp = await showAddPokemonDialog(context, card);
    if (hp == null) return;
    final idx = _draft.cards.indexWhere((dc) => dc.card.id == card.id);
    final List<DeckCard> next;
    if (idx >= 0) {
      next = [..._draft.cards];
      next[idx] = next[idx].copyWith(quantity: next[idx].quantity + 1);
    } else {
      next = [..._draft.cards, DeckCard(card: card, quantity: 1, hp: hp)];
    }
    _mutate(_draft.copyWith(cards: next));
  }

  void _removeCard(String cardId) {
    final next = _draft.cards.where((dc) => dc.card.id != cardId).toList();
    // '' is the "no cover" sentinel (freezed copyWith can't set null).
    final cover = _draft.coverCardId == cardId ? '' : _draft.coverCardId;
    _mutate(_draft.copyWith(cards: next, coverCardId: cover));
  }

  Future<void> _rename() async {
    final name = await showNameDialog(context,
        title: 'Renomear Deck', hint: 'Nome do deck', confirm: 'OK', initial: _draft.name);
    if (name != null) _mutate(_draft.copyWith(name: name.trim()));
  }

  Future<void> _cardActions(String cardId, bool isCover) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: context.palette.surface,
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
                _mutate(_draft.copyWith(coverCardId: isCover ? '' : cardId));
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: AppColors.red),
              title: Text('Remover do deck',
                  style: AppTextStyles.label.copyWith(color: AppColors.red)),
              onTap: () {
                _removeCard(cardId);
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── Commit / discard ───────────────────────────────────────────────────

  Future<void> _save() async {
    sfx(Sfx.confirm);
    final notifier = ref.read(deckNotifierProvider.notifier);
    if (_isNew) {
      final maxDecks = ref.read(settingsProvider).plan.maxDecks;
      final result = await notifier.addExistingDeck(_draft, maxDecks: maxDecks);
      if (result == DeckOpResult.limitReached) {
        _snack('Limite de $maxDecks decks atingido. Assine o Premium para mais.');
        return;
      }
    } else {
      await notifier.updateDeck(_draft);
    }
    if (mounted) context.pop();
  }

  void _cancel() async {
    sfx(Sfx.back);
    if (await _confirmDiscard() && mounted) context.pop();
  }

  /// Returns true if it's safe to leave (nothing to lose or user confirmed).
  Future<bool> _confirmDiscard() async {
    if (!_dirty) return true;
    final discard = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.palette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: context.palette.borderStrong, width: 2),
        ),
        title: Text('Descartar alterações?', style: AppTextStyles.h3),
        content: Text(
          _isNew
              ? 'O deck não será criado.'
              : 'As alterações feitas neste deck serão perdidas.',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Continuar editando',
                style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Descartar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    return discard == true;
  }

  void _snack(String msg) => showPixelSnack(context, msg);
}

class _AddTile extends StatelessWidget {
  final VoidCallback onTap;
  const _AddTile({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return PixelButton(
      onTap: onTap,
      color: context.palette.surface2,
      radius: 10,
      padding: EdgeInsets.zero,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: context.palette.borderStrong, width: 2),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 20),
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
                color: context.palette.surface2,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isCover
                      ? AppColors.blue
                      : context.palette.borderStrong,
                  width: 2,
                ),
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
