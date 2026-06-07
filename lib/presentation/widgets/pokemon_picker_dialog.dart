import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/models/card.dart';

/// All 151 Generation 1 Pokémon with their Pokédex numbers and base HP.
const _gen1Pokemon = [
  (1, 'Bulbasaur', 45), (2, 'Ivysaur', 60), (3, 'Venusaur', 80),
  (4, 'Charmander', 39), (5, 'Charmeleon', 58), (6, 'Charizard', 78),
  (7, 'Squirtle', 44), (8, 'Wartortle', 59), (9, 'Blastoise', 79),
  (10, 'Caterpie', 45), (11, 'Metapod', 50), (12, 'Butterfree', 60),
  (13, 'Weedle', 40), (14, 'Kakuna', 45), (15, 'Beedrill', 65),
  (16, 'Pidgey', 40), (17, 'Pidgeotto', 63), (18, 'Pidgeot', 83),
  (19, 'Rattata', 30), (20, 'Raticate', 55), (21, 'Spearow', 40),
  (22, 'Fearow', 65), (23, 'Ekans', 35), (24, 'Arbok', 60),
  (25, 'Pikachu', 35), (26, 'Raichu', 60), (27, 'Sandshrew', 50),
  (28, 'Sandslash', 75), (29, 'Nidoran♀', 55), (30, 'Nidorina', 70),
  (31, 'Nidoqueen', 90), (32, 'Nidoran♂', 46), (33, 'Nidorino', 61),
  (34, 'Nidoking', 81), (35, 'Clefairy', 70), (36, 'Clefable', 95),
  (37, 'Vulpix', 38), (38, 'Ninetales', 73), (39, 'Jigglypuff', 115),
  (40, 'Wigglytuff', 140), (41, 'Zubat', 40), (42, 'Golbat', 75),
  (43, 'Oddish', 45), (44, 'Gloom', 60), (45, 'Vileplume', 75),
  (46, 'Paras', 35), (47, 'Parasect', 60), (48, 'Venonat', 60),
  (49, 'Venomoth', 70), (50, 'Diglett', 10), (51, 'Dugtrio', 35),
  (52, 'Meowth', 40), (53, 'Persian', 65), (54, 'Psyduck', 50),
  (55, 'Golduck', 80), (56, 'Mankey', 40), (57, 'Primeape', 65),
  (58, 'Growlithe', 55), (59, 'Arcanine', 90), (60, 'Poliwag', 40),
  (61, 'Poliwhirl', 65), (62, 'Poliwrath', 90), (63, 'Abra', 25),
  (64, 'Kadabra', 40), (65, 'Alakazam', 55), (66, 'Machop', 70),
  (67, 'Machoke', 80), (68, 'Machamp', 90), (69, 'Bellsprout', 50),
  (70, 'Weepinbell', 65), (71, 'Victreebel', 80), (72, 'Tentacool', 40),
  (73, 'Tentacruel', 80), (74, 'Geodude', 40), (75, 'Graveler', 55),
  (76, 'Golem', 80), (77, 'Ponyta', 50), (78, 'Rapidash', 65),
  (79, 'Slowpoke', 90), (80, 'Slowbro', 95), (81, 'Magnemite', 25),
  (82, 'Magneton', 50), (83, "Farfetch'd", 52), (84, 'Doduo', 35),
  (85, 'Dodrio', 60), (86, 'Seel', 65), (87, 'Dewgong', 90),
  (88, 'Grimer', 80), (89, 'Muk', 105), (90, 'Shellder', 30),
  (91, 'Cloyster', 50), (92, 'Gastly', 30), (93, 'Haunter', 45),
  (94, 'Gengar', 60), (95, 'Onix', 35), (96, 'Drowzee', 60),
  (97, 'Hypno', 85), (98, 'Krabby', 30), (99, 'Kingler', 55),
  (100, 'Voltorb', 40), (101, 'Electrode', 60), (102, 'Exeggcute', 60),
  (103, 'Exeggutor', 95), (104, 'Cubone', 50), (105, 'Marowak', 60),
  (106, 'Hitmonlee', 50), (107, 'Hitmonchan', 50), (108, 'Lickitung', 90),
  (109, 'Koffing', 40), (110, 'Weezing', 65), (111, 'Rhyhorn', 80),
  (112, 'Rhydon', 105), (113, 'Chansey', 250), (114, 'Tangela', 65),
  (115, 'Kangaskhan', 105), (116, 'Horsea', 30), (117, 'Seadra', 55),
  (118, 'Goldeen', 45), (119, 'Seaking', 80), (120, 'Staryu', 30),
  (121, 'Starmie', 60), (122, 'Mr. Mime', 40), (123, 'Scyther', 70),
  (124, 'Jynx', 65), (125, 'Electabuzz', 65), (126, 'Magmar', 65),
  (127, 'Pinsir', 65), (128, 'Tauros', 75), (129, 'Magikarp', 20),
  (130, 'Gyarados', 95), (131, 'Lapras', 130), (132, 'Ditto', 48),
  (133, 'Eevee', 55), (134, 'Vaporeon', 130), (135, 'Jolteon', 65),
  (136, 'Flareon', 65), (137, 'Porygon', 65), (138, 'Omanyte', 35),
  (139, 'Omastar', 70), (140, 'Kabuto', 30), (141, 'Kabutops', 60),
  (142, 'Aerodactyl', 80), (143, 'Snorlax', 160), (144, 'Articuno', 90),
  (145, 'Zapdos', 90), (146, 'Moltres', 90), (147, 'Dratini', 41),
  (148, 'Dragonair', 61), (149, 'Dragonite', 91), (150, 'Mewtwo', 106),
  (151, 'Mew', 100),
];

String _spriteUrl(int dexNum) =>
    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$dexNum.png';

/// Shows a dialog to pick a Generation 1 Pokémon and returns a [PokemonCard].
Future<PokemonCard?> showPokemonPickerDialog(BuildContext context) {
  return showDialog<PokemonCard>(
    context: context,
    builder: (ctx) => const _PokemonPickerDialog(),
  );
}

class _PokemonPickerDialog extends StatefulWidget {
  const _PokemonPickerDialog();

  @override
  State<_PokemonPickerDialog> createState() => _PokemonPickerDialogState();
}

class _PokemonPickerDialogState extends State<_PokemonPickerDialog> {
  String _query = '';

  List<(int, String, int)> get _filtered => _gen1Pokemon
      .where((p) => p.$2.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.surface : Colors.white;
    final textColor = isDark ? AppColors.textPrimary : AppColors.textDark;
    final borderColor = isDark ? AppColors.border : const Color(0xFFE0E0E0);

    return Dialog(
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        width: 360,
        height: 520,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Row(
                children: [
                  Text(
                    'Geração 1',
                    style: AppTextStyles.h3.copyWith(color: textColor),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: isDark ? AppColors.textSecondary : Colors.grey),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            // Search field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Buscar Pokémon...',
                  hintStyle: TextStyle(color: isDark ? AppColors.textDim : Colors.grey),
                  prefixIcon: Icon(Icons.search, color: isDark ? AppColors.textDim : Colors.grey),
                  filled: true,
                  fillColor: isDark ? AppColors.surface2 : const Color(0xFFF0F0F0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Grid of Pokémon
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _filtered.length,
                itemBuilder: (ctx, i) {
                  final (dex, name, hp) = _filtered[i];
                  return _PokemonTile(
                    dexNum: dex,
                    name: name,
                    hp: hp,
                    isDark: isDark,
                    onTap: () {
                      final card = PokemonCard(
                        id: 'gen1-$dex',
                        name: name,
                        set: 'Gen I',
                        number: '$dex',
                        type: CardType.pokemon,
                        hp: hp * 10, // Scale to TCG HP range
                        imageUrl: _spriteUrl(dex),
                        imageLargeUrl: _spriteUrl(dex),
                      );
                      Navigator.of(context).pop(card);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PokemonTile extends StatelessWidget {
  final int dexNum;
  final String name;
  final int hp;
  final bool isDark;
  final VoidCallback onTap;

  const _PokemonTile({
    required this.dexNum,
    required this.name,
    required this.hp,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? AppColors.surface2 : const Color(0xFFF5F5F5);
    final textColor = isDark ? AppColors.textPrimary : AppColors.textDark;
    final subColor = isDark ? AppColors.textSecondary : Colors.grey[600]!;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.border : const Color(0xFFE0E0E0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              _spriteUrl(dexNum),
              width: 60,
              height: 60,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.catching_pokemon,
                size: 40,
                color: AppColors.blue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '#${dexNum.toString().padLeft(3, '0')}',
              style: AppTextStyles.caption.copyWith(color: subColor),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                name,
                style: AppTextStyles.bodySmall.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
