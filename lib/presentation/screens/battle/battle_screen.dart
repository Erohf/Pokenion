import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/hp_tracker.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/battle_menu.dart';
import '../../widgets/energy_tracker.dart';
import '../../providers/battle_provider.dart';
import '../../providers/deck_provider.dart';
import '../../../domain/models/status_condition.dart';
import '../../../domain/models/active_pokemon.dart';
import '../../../domain/models/card.dart';

// ─── Status config ────────────────────────────────────────────────────────────

const _statusConfig = {
  StatusCondition.asleep: (
    icon: Icons.bedtime_outlined,
    label: 'Dormindo',
    color: Color(0xFF9090A8),
  ),
  StatusCondition.burned: (
    icon: Icons.local_fire_department,
    label: 'Queimado',
    color: AppColors.energyFire,
  ),
  StatusCondition.confused: (
    icon: Icons.cyclone,
    label: 'Confuso',
    color: AppColors.energyPsychic,
  ),
  StatusCondition.paralyzed: (
    icon: Icons.bolt,
    label: 'Paralisado',
    color: AppColors.energyLightning,
  ),
  StatusCondition.poisoned: (
    icon: Icons.dangerous,
    label: 'Envenenado',
    color: AppColors.energyGrass,
  ),
};

// ─── Gen 1 evolutions map (pre→next) ─────────────────────────────────────────

const _evolutionMap = <String, List<(int, String, int)>>{
  'bulbasaur':  [(2, 'Ivysaur', 600), (3, 'Venusaur', 800)],
  'ivysaur':    [(3, 'Venusaur', 800)],
  'charmander': [(5, 'Charmeleon', 580), (6, 'Charizard', 780)],
  'charmeleon': [(6, 'Charizard', 780)],
  'squirtle':   [(8, 'Wartortle', 590), (9, 'Blastoise', 790)],
  'wartortle':  [(9, 'Blastoise', 790)],
  'caterpie':   [(11, 'Metapod', 500), (12, 'Butterfree', 600)],
  'metapod':    [(12, 'Butterfree', 600)],
  'weedle':     [(14, 'Kakuna', 450), (15, 'Beedrill', 650)],
  'kakuna':     [(15, 'Beedrill', 650)],
  'pidgey':     [(17, 'Pidgeotto', 630), (18, 'Pidgeot', 830)],
  'pidgeotto':  [(18, 'Pidgeot', 830)],
  'rattata':    [(20, 'Raticate', 550)],
  'spearow':    [(22, 'Fearow', 650)],
  'ekans':      [(24, 'Arbok', 600)],
  'pikachu':    [(26, 'Raichu', 600)],
  'sandshrew':  [(28, 'Sandslash', 750)],
  'nidoran♀':   [(30, 'Nidorina', 700), (31, 'Nidoqueen', 900)],
  'nidorina':   [(31, 'Nidoqueen', 900)],
  'nidoran♂':   [(33, 'Nidorino', 610), (34, 'Nidoking', 810)],
  'nidorino':   [(34, 'Nidoking', 810)],
  'clefairy':   [(36, 'Clefable', 950)],
  'vulpix':     [(38, 'Ninetales', 730)],
  'jigglypuff': [(40, 'Wigglytuff', 1400)],
  'zubat':      [(42, 'Golbat', 750)],
  'oddish':     [(44, 'Gloom', 600), (45, 'Vileplume', 750)],
  'gloom':      [(45, 'Vileplume', 750)],
  'paras':      [(47, 'Parasect', 600)],
  'venonat':    [(49, 'Venomoth', 700)],
  'diglett':    [(51, 'Dugtrio', 350)],
  'meowth':     [(53, 'Persian', 650)],
  'psyduck':    [(55, 'Golduck', 800)],
  'mankey':     [(57, 'Primeape', 650)],
  'growlithe':  [(59, 'Arcanine', 900)],
  'poliwag':    [(61, 'Poliwhirl', 650), (62, 'Poliwrath', 900)],
  'poliwhirl':  [(62, 'Poliwrath', 900)],
  'abra':       [(64, 'Kadabra', 400), (65, 'Alakazam', 550)],
  'kadabra':    [(65, 'Alakazam', 550)],
  'machop':     [(67, 'Machoke', 800), (68, 'Machamp', 900)],
  'machoke':    [(68, 'Machamp', 900)],
  'bellsprout': [(70, 'Weepinbell', 650), (71, 'Victreebel', 800)],
  'weepinbell': [(71, 'Victreebel', 800)],
  'tentacool':  [(73, 'Tentacruel', 800)],
  'geodude':    [(75, 'Graveler', 550), (76, 'Golem', 800)],
  'graveler':   [(76, 'Golem', 800)],
  'ponyta':     [(78, 'Rapidash', 650)],
  'slowpoke':   [(80, 'Slowbro', 950)],
  'magnemite':  [(82, 'Magneton', 500)],
  'doduo':      [(85, 'Dodrio', 600)],
  'seel':       [(87, 'Dewgong', 900)],
  'grimer':     [(89, 'Muk', 1050)],
  'shellder':   [(91, 'Cloyster', 500)],
  'gastly':     [(93, 'Haunter', 450), (94, 'Gengar', 600)],
  'haunter':    [(94, 'Gengar', 600)],
  'drowzee':    [(97, 'Hypno', 850)],
  'krabby':     [(99, 'Kingler', 550)],
  'voltorb':    [(101, 'Electrode', 600)],
  'exeggcute':  [(103, 'Exeggutor', 950)],
  'cubone':     [(105, 'Marowak', 600)],
  'rhyhorn':    [(112, 'Rhydon', 1050)],
  'tangela':    [],
  'horsea':     [(117, 'Seadra', 550)],
  'goldeen':    [(119, 'Seaking', 800)],
  'staryu':     [(121, 'Starmie', 600)],
  'magikarp':   [(130, 'Gyarados', 950)],
  'eevee':      [(134, 'Vaporeon', 1300), (135, 'Jolteon', 650), (136, 'Flareon', 650)],
  'omanyte':    [(139, 'Omastar', 700)],
  'kabuto':     [(141, 'Kabutops', 600)],
  'dratini':    [(148, 'Dragonair', 610), (149, 'Dragonite', 910)],
  'dragonair':  [(149, 'Dragonite', 910)],
};

String _spriteUrl(int dex) =>
    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$dex.png';

// ─── BattleScreen ─────────────────────────────────────────────────────────────

class BattleScreen extends ConsumerStatefulWidget {
  final String deckId;
  const BattleScreen({super.key, required this.deckId});

  @override
  ConsumerState<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends ConsumerState<BattleScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _init());
    }
  }

  void _init() {
    final decks = ref.read(deckNotifierProvider).value ?? [];
    final deck = decks.firstWhere(
      (d) => d.id == widget.deckId,
      orElse: () => decks.isNotEmpty ? decks.first : throw Exception('No decks'),
    );
    ref.read(battleProvider.notifier).startBattle(deck);
  }

  @override
  Widget build(BuildContext context) {
    final battleState = ref.watch(battleProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.bg : const Color(0xFFF5F5F5);
    final adColor = isDark ? AppColors.surfaceVariant : const Color(0xFFE0E0E0);
    final adTextColor = isDark ? AppColors.textDark : Colors.grey[600]!;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            // AD Banner
            Positioned(
              top: 0, left: 0, right: 0,
              child: Container(
                height: 100,
                color: adColor,
                alignment: Alignment.center,
                child: Text(
                  'AD',
                  style: AppTextStyles.h1.copyWith(color: adTextColor),
                ),
              ),
            ),

            // Main Content
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 116, bottom: 120),
                child: _MainCard(
                  state: battleState,
                  isDark: isDark,
                  onHpChanged: (hp) => ref.read(battleProvider.notifier).updateHp(hp),
                  onStatusTap: () => _showStatusMenu(context),
                  onEvolveTap: () => _showEvolveMenu(context, battleState),
                  onDefeatedTap: () => _showDefeatedMenu(context, battleState),
                  onBenchTap: (i) => ref.read(battleProvider.notifier).swapWithBench(i),
                  onEndGame: () => context.go('/'),
                  onNewGame: () => _confirmNewGame(context),
                ),
              ),
            ),

            // Bottom Menu
            const Positioned(
              bottom: 16, left: 0, right: 0,
              child: Center(child: BattleMenu()),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Status Menu ───────────────────────────────────────────────────
  void _showStatusMenu(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.surface : Colors.white;
    final textColor = isDark ? AppColors.textPrimary : AppColors.textDark;
    final current = ref.read(battleProvider).activePokemon?.statusCondition;

    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.border : const Color(0xFFDDDDDD),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Selecionar Status', style: AppTextStyles.h3.copyWith(color: textColor)),
            const SizedBox(height: 8),
            if (current != null)
              TextButton.icon(
                onPressed: () {
                  ref.read(battleProvider.notifier).clearStatus();
                  Navigator.pop(ctx);
                },
                icon: const Icon(Icons.close, color: AppColors.red, size: 16),
                label: const Text('Remover status', style: TextStyle(color: AppColors.red)),
              ),
            const SizedBox(height: 8),
            ...StatusCondition.values.map((status) {
              final cfg = _statusConfig[status]!;
              final isSelected = current == status;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () {
                    ref.read(battleProvider.notifier).toggleStatus(status);
                    Navigator.pop(ctx);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? cfg.color.withOpacity(0.15)
                          : (isDark ? AppColors.surface2 : const Color(0xFFF5F5F5)),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? cfg.color : (isDark ? AppColors.border : const Color(0xFFE0E0E0)),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(cfg.icon, color: cfg.color, size: 22),
                        const SizedBox(width: 12),
                        Text(
                          cfg.label,
                          style: TextStyle(
                            color: isSelected ? cfg.color : textColor,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          Icon(Icons.check_circle, color: cfg.color, size: 18),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ─── Evolve Menu ───────────────────────────────────────────────────
  void _showEvolveMenu(BuildContext context, dynamic state) {
    final active = state.activePokemon as ActivePokemon?;
    if (active == null) return;

    final key = active.card.name.toLowerCase();
    final evolutions = _evolutionMap[key];

    if (evolutions == null || evolutions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${active.card.name} não possui evoluções.'),
          backgroundColor: AppColors.textDim,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.surface : Colors.white;
    final textColor = isDark ? AppColors.textPrimary : AppColors.textDark;

    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.border : const Color(0xFFDDDDDD),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Evoluir ${active.card.name}', style: AppTextStyles.h3.copyWith(color: textColor)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: evolutions.map((evo) {
                final (dex, name, hp) = evo;
                return GestureDetector(
                  onTap: () {
                    final card = PokemonCard(
                      id: 'gen1-$dex',
                      name: name,
                      set: 'Gen I',
                      number: '$dex',
                      type: CardType.pokemon,
                      hp: hp,
                      imageUrl: _spriteUrl(dex),
                      imageLargeUrl: _spriteUrl(dex),
                    );
                    ref.read(battleProvider.notifier).evolve(card);
                    Navigator.pop(ctx);
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surface2 : const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.blue, width: 1.5),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            _spriteUrl(dex),
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.catching_pokemon,
                              color: AppColors.blue,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(name, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13)),
                      Text('HP: $hp', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Defeated Menu ─────────────────────────────────────────────────
  void _showDefeatedMenu(BuildContext context, dynamic state) {
    final bench = (state.bench as List<ActivePokemon>);
    if (bench.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não há Pokémon no banco para substituir.'),
          backgroundColor: AppColors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.surface : Colors.white;
    final textColor = isDark ? AppColors.textPrimary : AppColors.textDark;

    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.border : const Color(0xFFDDDDDD),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Escolher Substituto', style: AppTextStyles.h3.copyWith(color: textColor)),
            const SizedBox(height: 4),
            Text(
              'Selecione um Pokémon do banco:',
              style: AppTextStyles.body.copyWith(color: isDark ? AppColors.textSecondary : Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: bench.asMap().entries.map((entry) {
                final i = entry.key;
                final pokemon = entry.value;
                final imgUrl = pokemon.card.imageUrl;
                return GestureDetector(
                  onTap: () {
                    ref.read(battleProvider.notifier).defeatActive(i);
                    Navigator.pop(ctx);
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 64, height: 64,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surface2 : const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.blue, width: 1.5),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: imgUrl != null
                              ? Image.network(imgUrl, fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.catching_pokemon, color: AppColors.blue))
                              : const Icon(Icons.catching_pokemon, color: AppColors.blue),
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 60,
                        child: Text(
                          pokemon.card.name,
                          style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${pokemon.currentHp}/${pokemon.maxHp}',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Confirm New Game ──────────────────────────────────────────────
  void _confirmNewGame(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.surface : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Novo Jogo',
          style: AppTextStyles.h3.copyWith(
            color: isDark ? AppColors.textPrimary : AppColors.textDark,
          ),
        ),
        content: Text(
          'Deseja reiniciar a partida com o mesmo deck?',
          style: AppTextStyles.body.copyWith(
            color: isDark ? AppColors.textSecondary : Colors.grey[600],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancelar', style: TextStyle(color: isDark ? AppColors.textSecondary : Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(battleProvider.notifier).resetGame();
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Reiniciar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ─── MainCard ─────────────────────────────────────────────────────────────────

class _MainCard extends StatelessWidget {
  final dynamic state;
  final bool isDark;
  final ValueChanged<int> onHpChanged;
  final VoidCallback onStatusTap;
  final VoidCallback onEvolveTap;
  final VoidCallback onDefeatedTap;
  final ValueChanged<int> onBenchTap;
  final VoidCallback onEndGame;
  final VoidCallback onNewGame;

  const _MainCard({
    required this.state,
    required this.isDark,
    required this.onHpChanged,
    required this.onStatusTap,
    required this.onEvolveTap,
    required this.onDefeatedTap,
    required this.onBenchTap,
    required this.onEndGame,
    required this.onNewGame,
  });

  Map<EnergyType, int> _mapEnergies(List<EnergyType> attached) {
    final Map<EnergyType, int> map = {};
    for (final e in attached) {
      map[e] = (map[e] ?? 0) + 1;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final active = state.activePokemon as ActivePokemon?;
    final bench = state.bench as List<ActivePokemon>;
    final currentHp = active?.currentHp ?? 0;
    final maxHp = active?.maxHp ?? 0;
    final status = active?.statusCondition;
    final imgUrl = active?.card.imageUrl;

    final cardBg = isDark ? AppColors.surfaceVariant : const Color(0xFFEEEEEE);
    final cardBorder = isDark ? AppColors.borderVariant : const Color(0xFFCCCCCC);
    final innerBg = isDark ? AppColors.borderVariant : const Color(0xFFDDDDDD);

    return SizedBox(
      width: 300,
      height: 544,
      child: Stack(
        children: [
          // Background Card
          Positioned(
            top: 44, bottom: 80, left: 0, right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: cardBg,
                border: Border.all(color: cardBorder, width: 2),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),

          // Internal image area
          Positioned(
            top: 140, bottom: 112, left: 32, right: 32,
            child: Container(
              decoration: BoxDecoration(
                color: innerBg,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),

          // Pokémon Image
          Positioned(
            top: 150, bottom: 120, left: 48, right: 48,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: imgUrl != null
                  ? CachedNetworkImage(imageUrl: imgUrl, fit: BoxFit.contain)
                  : Icon(
                      Icons.catching_pokemon,
                      size: 80,
                      color: isDark ? AppColors.textDim : Colors.grey,
                    ),
            ),
          ),

          // Pokémon Name tag
          if (active != null)
            Positioned(
              top: 154,
              left: 48,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  active.card.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // HP Section
          Positioned(
            top: 60, left: 0, right: 0,
            child: Column(
              children: [
                Center(
                  child: HpTracker(
                    currentHp: currentHp,
                    maxHp: maxHp,
                    onChanged: onHpChanged,
                  ),
                ),
                if (active != null && active.attachedEnergies.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  EnergyTracker(
                    energies: _mapEnergies(active.attachedEnergies),
                  ),
                ],
              ],
            ),
          ),

          // Action Buttons (Evolve, Defeated)
          Positioned(
            bottom: 100, left: 0, right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ActionButton(
                  text: 'Evolve',
                  color: AppColors.blue,
                  width: 128,
                  onPressed: onEvolveTap,
                ),
                const SizedBox(height: 8),
                _ActionButton(
                  text: 'Defeated',
                  color: isDark ? AppColors.textDark : const Color(0xFF555555),
                  width: 96,
                  height: 24,
                  fontSize: 12,
                  onPressed: onDefeatedTap,
                ),
              ],
            ),
          ),

          // Right side: Status button + active status icon
          Positioned(
            top: 116, right: 8,
            child: Column(
              children: [
                // Status selector button
                StatusBadge(
                  icon: const Icon(Icons.shield_outlined, size: 16, color: Colors.white),
                  backgroundColor: AppColors.blue,
                  onTap: onStatusTap,
                ),
                // Active status icon (if any)
                if (status != null) ...[
                  const SizedBox(height: 5),
                  StatusBadge(
                    icon: Icon(
                      _statusConfig[status]!.icon,
                      size: 16,
                      color: Colors.white,
                    ),
                    backgroundColor: _statusConfig[status]!.color,
                  ),
                ],
              ],
            ),
          ),

          // Bench Cards
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: bench.isEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (_) => _EmptyBenchCard(isDark: isDark),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: bench.asMap().entries.map((entry) {
                      return _BenchCard(
                        pokemon: entry.value,
                        isDark: isDark,
                        onTap: () => onBenchTap(entry.key),
                      );
                    }).toList(),
                  ),
          ),

          // Control Buttons (End Game, New Game)
          Positioned(
            top: 0, left: 22, right: 22,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ControlButton(
                  text: 'End Game',
                  color: isDark ? AppColors.textDark : const Color(0xFF555555),
                  onPressed: onEndGame,
                ),
                const SizedBox(width: 32),
                _ControlButton(
                  text: 'New Game',
                  color: AppColors.blue,
                  onPressed: onNewGame,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final String text;
  final Color color;
  final double width;
  final double height;
  final double fontSize;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.text,
    required this.color,
    required this.width,
    this.height = 32,
    this.fontSize = 16,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(48),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: AppTextStyles.buttonText.copyWith(fontSize: fontSize),
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const _ControlButton({
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 112,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(48),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: AppTextStyles.buttonText.copyWith(fontSize: 13),
        ),
      ),
    );
  }
}

class _BenchCard extends StatelessWidget {
  final ActivePokemon pokemon;
  final bool isDark;
  final VoidCallback onTap;

  const _BenchCard({
    required this.pokemon,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? AppColors.surfaceVariant : const Color(0xFFEEEEEE);
    final borderColor = isDark ? AppColors.borderVariant : const Color(0xFFCCCCCC);
    final imgUrl = pokemon.card.imageUrl;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 64,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: imgUrl != null
              ? Image.network(
                  imgUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.catching_pokemon,
                    size: 24,
                    color: AppColors.blue,
                  ),
                )
              : const Icon(Icons.catching_pokemon, size: 24, color: AppColors.blue),
        ),
      ),
    );
  }
}

class _EmptyBenchCard extends StatelessWidget {
  final bool isDark;
  const _EmptyBenchCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 64,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface2 : const Color(0xFFEEEEEE),
        border: Border.all(
          color: isDark ? AppColors.border : const Color(0xFFDDDDDD),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.add,
        size: 20,
        color: isDark ? AppColors.textDim : Colors.grey[400],
      ),
    );
  }
}
