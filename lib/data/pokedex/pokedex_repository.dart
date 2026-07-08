import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../domain/models/card.dart';

/// Loads the curated local Pokédex dataset (Gens 1-4 + Megas/EX) from assets.
class PokedexRepository {
  PokedexRepository._(this._cards, this._byId, this._searchKeys);

  final List<PokemonCard> _cards;
  final Map<String, PokemonCard> _byId;
  // Pre-lowered names, parallel to [_cards], so search doesn't re-lowercase
  // ~600 strings per keystroke.
  final List<String> _searchKeys;

  static PokedexRepository? _instance;

  static Future<PokedexRepository> load() async {
    if (_instance != null) return _instance!;
    final raw = await rootBundle.loadString('assets/data/pokedex.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final list = (json['cards'] as List)
        .map((e) => _fromDataset(e as Map<String, dynamic>))
        .toList();
    _instance = PokedexRepository._(
      list,
      {for (final c in list) c.id: c},
      [for (final c in list) c.name.toLowerCase()],
    );
    return _instance!;
  }

  List<PokemonCard> get all => List.unmodifiable(_cards);

  PokemonCard? byId(String id) => _byId[id];

  /// Cards that can be evolved into from [card], present anywhere in the dex.
  List<PokemonCard> evolutionsOf(PokemonCard card) =>
      card.evolvesToIds.map((id) => _byId[id]).whereType<PokemonCard>().toList();

  /// Generation of a dex number (1-4).
  static int generationOf(int dex) {
    if (dex <= 151) return 1;
    if (dex <= 251) return 2;
    if (dex <= 386) return 3;
    return 4;
  }

  /// Filters by name substring and, optionally, generation ([gen] 1-4, null =
  /// all).
  List<PokemonCard> search(String query, {int? gen}) {
    final q = query.trim().toLowerCase();
    final out = <PokemonCard>[];
    for (var i = 0; i < _cards.length; i++) {
      final c = _cards[i];
      if (gen != null && generationOf(c.dexNumber ?? 1) != gen) continue;
      if (q.isNotEmpty && !_searchKeys[i].contains(q)) continue;
      out.add(c);
    }
    return out;
  }

  static PokemonCard _fromDataset(Map<String, dynamic> j) {
    return PokemonCard(
      id: j['id'] as String,
      name: j['name'] as String,
      type: CardType.pokemon,
      dexNumber: j['dexNumber'] as int?,
      stage: _stage(j['stage'] as String?),
      baseHp: j['baseHp'] as int?,
      types: (j['types'] as List?)?.map((e) => e as String).toList(),
      imageUrl: j['imageUrl'] as String?,
      imageLargeUrl: j['imageUrl'] as String?,
      evolvesToIds:
          (j['evolvesToIds'] as List?)?.map((e) => e as String).toList() ??
              const [],
      variant: j['variant'] as String?,
    );
  }

  static PokemonStage _stage(String? s) {
    switch (s) {
      case 'stage1':
        return PokemonStage.stage1;
      case 'stage2':
        return PokemonStage.stage2;
      case 'ex':
        return PokemonStage.ex;
      case 'mega':
        return PokemonStage.mega;
      case 'vAstro':
        return PokemonStage.vAstro;
      case 'basic':
      default:
        return PokemonStage.basic;
    }
  }
}
