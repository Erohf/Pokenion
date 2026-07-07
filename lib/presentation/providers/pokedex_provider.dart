import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/pokedex/pokedex_repository.dart';

part 'pokedex_provider.g.dart';

@Riverpod(keepAlive: true)
Future<PokedexRepository> pokedex(PokedexRef ref) => PokedexRepository.load();
