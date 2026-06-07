import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/models/card.dart';

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
  List<(int, String, int)> _gen1Pokemon = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPokemon();
  }

  Future<void> _fetchPokemon() async {
    try {
      final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=151'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List;
        
        final List<(int, String, int)> loaded = [];
        for (var i = 0; i < results.length; i++) {
          final p = results[i];
          final name = (p['name'] as String).replaceFirstMapped(RegExp(r'^[a-z]'), (m) => m[0]!.toUpperCase());
          // Base HP is not in the list response, we will just default to 60 for visual purposes 
          // or we could fetch each but that is 151 requests. We will default to 60 here.
          loaded.add((i + 1, name, 60));
        }
        
        if (mounted) {
          setState(() {
            _gen1Pokemon = loaded;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

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
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator()) 
                : GridView.builder(
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
