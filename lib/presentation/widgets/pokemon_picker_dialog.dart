import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/audio/sfx.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/models/card.dart';
import '../providers/pokedex_provider.dart';

/// Search-and-pick a Pokémon from the local Pokédex (proto "Search Collection").
///
/// Built for a ~600-entry list without jank:
/// - debounced search (list rebuilds at most every 250 ms while typing);
/// - generation filter chips to slice the list;
/// - fixed-extent lazy rows (cheap layout, only visible rows built);
/// - sprite decode capped via [memCacheWidth] and a static placeholder
///   (no per-row spinners).
Future<PokemonCard?> showPokemonPickerDialog(BuildContext context) {
  return showModalBottomSheet<PokemonCard>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _PokemonPickerSheet(),
  );
}

class _PokemonPickerSheet extends ConsumerStatefulWidget {
  const _PokemonPickerSheet();
  @override
  ConsumerState<_PokemonPickerSheet> createState() => _PokemonPickerSheetState();
}

class _PokemonPickerSheetState extends ConsumerState<_PokemonPickerSheet> {
  String _query = '';
  int? _gen; // null = all generations
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onQueryChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      if (mounted) setState(() => _query = v);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pokedex = ref.watch(pokedexProvider);
    final p = context.palette;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.92,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: p.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: TextField(
                  autofocus: true,
                  onChanged: _onQueryChanged,
                  style: TextStyle(color: p.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Buscar Pokémon...',
                    hintStyle: const TextStyle(color: AppColors.textDim),
                    prefixIcon: const Icon(Icons.search, color: AppColors.blue),
                    filled: true,
                    fillColor: p.surface2,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 46,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  children: [
                    _GenChip(
                      label: 'Todas',
                      selected: _gen == null,
                      onTap: () => setState(() => _gen = null),
                    ),
                    for (var g = 1; g <= 4; g++)
                      _GenChip(
                        label: 'Gen $g',
                        selected: _gen == g,
                        onTap: () => setState(() => _gen = g),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: pokedex.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(
                      child: Text('Erro ao carregar Pokédex.',
                          style: AppTextStyles.body)),
                  data: (repo) {
                    final results = repo.search(_query, gen: _gen);
                    if (results.isEmpty) {
                      return Center(
                        child: Text('Nenhum Pokémon encontrado.',
                            style: AppTextStyles.body),
                      );
                    }
                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: results.length,
                      itemExtent: 60,
                      itemBuilder: (context, i) => _PokemonRow(
                        card: results[i],
                        onTap: () {
                          sfx(Sfx.tap);
                          Navigator.pop(context, results[i]);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GenChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _GenChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.blue : p.surface2,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? p.borderStrong : p.border,
              width: 2,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.pixelTag.copyWith(
              fontSize: 10,
              color: selected ? Colors.white : p.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _PokemonRow extends StatelessWidget {
  final PokemonCard card;
  final VoidCallback onTap;
  const _PokemonRow({required this.card, required this.onTap});

  Color get _stageColor => switch (card.stage) {
        PokemonStage.ex => AppColors.yellow,
        PokemonStage.mega => AppColors.energyPsychic,
        _ => AppColors.blue,
      };

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            SizedBox(
              width: 46,
              height: 46,
              child: card.imageUrl == null
                  ? const Icon(Icons.catching_pokemon, color: AppColors.blue)
                  : CachedNetworkImage(
                      imageUrl: card.imageUrl!,
                      fit: BoxFit.contain,
                      memCacheWidth: 96,
                      filterQuality: FilterQuality.none,
                      fadeInDuration: const Duration(milliseconds: 120),
                      placeholder: (_, __) => Icon(Icons.catching_pokemon,
                          color: p.border, size: 28),
                      errorWidget: (_, __, ___) => const Icon(
                          Icons.catching_pokemon,
                          color: AppColors.blue),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(card.name,
                      style: AppTextStyles.label.copyWith(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text(
                    '#${(card.dexNumber ?? 0).toString().padLeft(3, '0')} · ${card.baseHp ?? '-'} HP',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: _stageColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    color: _stageColor.withValues(alpha: 0.55), width: 1.5),
              ),
              child: Text(
                card.stage?.label.toUpperCase() ?? '',
                style: AppTextStyles.pixelTag.copyWith(
                  fontSize: 8.5,
                  color: _stageColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
