import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/models/card.dart';
import '../providers/pokedex_provider.dart';

/// Search-and-pick a Pokémon from the local Pokédex (proto "Search Collection").
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

  @override
  Widget build(BuildContext context) {
    final pokedex = ref.watch(pokedexProvider);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.92,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: context.palette.surface,
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
                    color: context.palette.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  autofocus: true,
                  onChanged: (v) => setState(() => _query = v),
                  style: TextStyle(color: context.palette.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Buscar Pokémon...',
                    hintStyle: const TextStyle(color: AppColors.textDim),
                    prefixIcon: const Icon(Icons.search, color: AppColors.blue),
                    filled: true,
                    fillColor: context.palette.surface2,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: pokedex.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(
                      child: Text('Erro ao carregar Pokédex.',
                          style: AppTextStyles.body)),
                  data: (repo) {
                    final results = repo.search(_query);
                    return ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: results.length,
                      separatorBuilder: (_, __) =>
                          Divider(height: 1, color: context.palette.border),
                      itemBuilder: (context, i) {
                        final card = results[i];
                        return ListTile(
                          onTap: () => Navigator.pop(context, card),
                          title: Text(card.name,
                              style: AppTextStyles.label.copyWith(fontSize: 15)),
                          subtitle: Text(card.stage?.label ?? '',
                              style: AppTextStyles.caption),
                          trailing: SizedBox(
                            width: 44,
                            height: 44,
                            child: card.imageUrl == null
                                ? const Icon(Icons.catching_pokemon,
                                    color: AppColors.blue)
                                : CachedNetworkImage(
                                    imageUrl: card.imageUrl!,
                                    fit: BoxFit.contain,
                                    errorWidget: (_, __, ___) => const Icon(
                                        Icons.catching_pokemon,
                                        color: AppColors.blue),
                                  ),
                          ),
                        );
                      },
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
