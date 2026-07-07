import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/models/active_pokemon.dart';
import '../../../domain/models/deck.dart';
import '../../../domain/models/status_condition.dart';
import '../../providers/battle_provider.dart';
import '../../providers/deck_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/ad_banner.dart';
import '../../widgets/battle_menu.dart';

typedef StatusCfg = ({IconData icon, String label, Color color});

const Map<StatusCondition, StatusCfg> statusConfig = {
  StatusCondition.asleep: (icon: Icons.bedtime, label: 'Asleep', color: Color(0xFF9090A8)),
  StatusCondition.burned: (icon: Icons.local_fire_department, label: 'Burned', color: AppColors.energyFire),
  StatusCondition.confused: (icon: Icons.cyclone, label: 'Confused', color: AppColors.energyPsychic),
  StatusCondition.paralyzed: (icon: Icons.block, label: 'Paralyzed', color: AppColors.energyLightning),
  StatusCondition.poisoned: (icon: Icons.dangerous, label: 'Poisoned', color: AppColors.energyGrass),
};

class BattleScreen extends ConsumerStatefulWidget {
  final String deckId;
  const BattleScreen({super.key, required this.deckId});

  @override
  ConsumerState<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends ConsumerState<BattleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureStarted());
  }

  void _ensureStarted() {
    final deck = ref.read(deckNotifierProvider.notifier).byId(widget.deckId);
    if (deck == null) return;
    final battle = ref.read(battleProvider);
    // Start a fresh battle only if none is running for this deck.
    if (!battle.inProgress || battle.deckId != widget.deckId) {
      ref.read(battleProvider.notifier).startBattle(deck);
    }
  }

  Deck? get _deck => ref.read(deckNotifierProvider.notifier).byId(widget.deckId);

  /// Deck cards eligible to be picked, excluding those already in play (by id).
  List<DeckCard> _available({bool onlyStartable = true}) {
    final deck = _deck;
    if (deck == null) return [];
    final state = ref.read(battleProvider);
    final inPlay = <String>{
      if (state.active != null) state.active!.card.id,
      for (final b in state.bench) b.card.id,
    };
    return deck.pokemonCards.where((dc) {
      if (inPlay.contains(dc.card.id)) return false;
      if (onlyStartable && !(dc.card.stage?.canStartInPlay ?? false)) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(battleProvider);
    final showAds = ref.watch(settingsProvider).plan.showsAds;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (showAds) const AdBanner(),
            Expanded(
              child: state.active == null
                  ? _ActiveSelection(
                      options: _available(),
                      onPick: (dc) => ref.read(battleProvider.notifier).chooseActive(dc),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: _BattleBoard(
                        active: state.active!,
                        bench: state.bench,
                        onEndGame: _confirmEndGame,
                        onNewGame: _newGame,
                        onHpChanged: (hp) => ref.read(battleProvider.notifier).updateHp(hp),
                        onHpDelta: (d) => ref.read(battleProvider.notifier).addHp(d),
                        onStatus: _statusMenu,
                        onEvolve: _evolveMenu,
                        onDefeated: _defeatedMenu,
                        onBenchTap: _benchTap,
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _BottomBar(),
    );
  }

  // ── Bench ────────────────────────────────────────────────────────────────
  Future<void> _benchTap(int index) async {
    final state = ref.read(battleProvider);
    if (index >= state.bench.length) {
      // Empty slot → add from deck.
      final dc = await _pickDeckCard('Adicionar ao banco', _available());
      if (dc != null) ref.read(battleProvider.notifier).addToBench(dc);
    } else {
      // Occupied → swap active with this bench slot, or replace it.
      final action = await showModalBottomSheet<String>(
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
                leading: const Icon(Icons.swap_vert, color: AppColors.blue),
                title: Text('Tornar ativo (recuar)', style: AppTextStyles.label),
                onTap: () => Navigator.pop(ctx, 'swap'),
              ),
              ListTile(
                leading: const Icon(Icons.autorenew, color: AppColors.blue),
                title: Text('Trocar por outro do deck', style: AppTextStyles.label),
                onTap: () => Navigator.pop(ctx, 'replace'),
              ),
            ],
          ),
        ),
      );
      if (action == 'swap') {
        ref.read(battleProvider.notifier).swapWithBench(index);
      } else if (action == 'replace') {
        final dc = await _pickDeckCard('Trocar Pokémon do banco', _available());
        if (dc != null) ref.read(battleProvider.notifier).replaceBench(index, dc);
      }
    }
  }

  // ── Status ───────────────────────────────────────────────────────────────
  Future<void> _statusMenu() async {
    final current = ref.read(battleProvider).active?.statuses ?? const <StatusCondition>{};
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) {
          final statuses = ref.read(battleProvider).active?.statuses ?? const <StatusCondition>{};
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(width: 40, height: 4,
                      decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text('Status', style: AppTextStyles.h3),
                      const Spacer(),
                      if (statuses.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            ref.read(battleProvider.notifier).clearStatus();
                            setModal(() {});
                          },
                          child: const Text('Limpar', style: TextStyle(color: AppColors.red)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  for (final s in StatusCondition.values)
                    _StatusRow(
                      cfg: statusConfig[s]!,
                      selected: statuses.contains(s),
                      onTap: () {
                        ref.read(battleProvider.notifier).toggleStatus(s);
                        setModal(() {});
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
    if (current != ref.read(battleProvider).active?.statuses) setState(() {});
  }

  // ── Evolve ───────────────────────────────────────────────────────────────
  Future<void> _evolveMenu() async {
    final deck = _deck;
    final active = ref.read(battleProvider).active;
    if (deck == null || active == null) return;
    // Evolutions must be present in the deck.
    final options = deck.pokemonCards
        .where((dc) => active.card.evolvesToIds.contains(dc.card.id))
        .toList();
    if (options.isEmpty) {
      _snack('${active.card.name} não possui evolução neste deck.');
      return;
    }
    final chosen = await _pickDeckCard('Evoluir ${active.card.name}', options);
    if (chosen != null) {
      ref.read(battleProvider.notifier).evolve(chosen.card, chosen.effectiveHp);
    }
  }

  // ── Defeated ─────────────────────────────────────────────────────────────
  Future<void> _defeatedMenu() async {
    final bench = ref.read(battleProvider).bench;
    if (bench.isEmpty) {
      _snack('Sem Pokémon no banco para substituir. Adicione um antes.');
      return;
    }
    final index = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Escolher novo Pokémon ativo', style: AppTextStyles.h3),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (var i = 0; i < bench.length; i++)
                    _PokemonPickTile(
                      imageUrl: bench[i].card.imageUrl,
                      name: bench[i].card.name,
                      subtitle: '${bench[i].currentHp}/${bench[i].maxHp}',
                      onTap: () => Navigator.pop(ctx, i),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (index != null) ref.read(battleProvider.notifier).markDefeated(index);
  }

  // ── Session ──────────────────────────────────────────────────────────────
  Future<void> _confirmEndGame() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Encerrar jogo', style: AppTextStyles.h3),
        content: Text('Tem certeza? O progresso da batalha será perdido.',
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
            child: const Text('Encerrar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (ok == true) {
      ref.read(battleProvider.notifier).endGame();
      if (mounted) context.go('/');
    }
  }

  void _newGame() {
    final deck = _deck;
    if (deck == null) return;
    ref.read(battleProvider.notifier).startBattle(deck);
    setState(() {});
  }

  // ── Helpers ────────────────────────────────────────────────────────────
  Future<DeckCard?> _pickDeckCard(String title, List<DeckCard> options) {
    if (options.isEmpty) {
      _snack('Nenhum Pokémon disponível no deck.');
      return Future.value(null);
    }
    return showModalBottomSheet<DeckCard>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.h3),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final dc in options)
                    _PokemonPickTile(
                      imageUrl: dc.card.imageUrl,
                      name: dc.card.name,
                      subtitle: '${dc.effectiveHp} HP',
                      onTap: () => Navigator.pop(ctx, dc),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.surface2,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// ── Active selection ─────────────────────────────────────────────────────────
class _ActiveSelection extends StatelessWidget {
  final List<DeckCard> options;
  final ValueChanged<DeckCard> onPick;
  const _ActiveSelection({required this.options, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          Text('Escolha seu Pokémon inicial', style: AppTextStyles.h2, textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text('Somente Básico ou EX podem começar.',
              style: AppTextStyles.body, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          Expanded(
            child: options.isEmpty
                ? Center(child: Text('Nenhum Pokémon elegível no deck.', style: AppTextStyles.body))
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: options.length,
                    itemBuilder: (context, i) => _PokemonPickTile(
                      imageUrl: options[i].card.imageUrl,
                      name: options[i].card.name,
                      subtitle: '${options[i].effectiveHp} HP',
                      onTap: () => onPick(options[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Battle board ─────────────────────────────────────────────────────────────
class _BattleBoard extends StatelessWidget {
  final ActivePokemon active;
  final List<ActivePokemon> bench;
  final VoidCallback onEndGame;
  final VoidCallback onNewGame;
  final ValueChanged<int> onHpChanged;
  final ValueChanged<int> onHpDelta;
  final VoidCallback onStatus;
  final VoidCallback onEvolve;
  final VoidCallback onDefeated;
  final ValueChanged<int> onBenchTap;

  const _BattleBoard({
    required this.active,
    required this.bench,
    required this.onEndGame,
    required this.onNewGame,
    required this.onHpChanged,
    required this.onHpDelta,
    required this.onStatus,
    required this.onEvolve,
    required this.onDefeated,
    required this.onBenchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _PillButton(text: 'End Game', color: AppColors.surfaceVariant, textColor: AppColors.textDark, onTap: onEndGame),
              const SizedBox(width: 24),
              _PillButton(text: 'New Game', color: AppColors.blue, textColor: Colors.white, onTap: onNewGame),
            ],
          ),
          const SizedBox(height: 16),
          _ActiveCard(
            active: active,
            onStatus: onStatus,
            onEvolve: onEvolve,
            onDefeated: onDefeated,
            onHpChanged: onHpChanged,
            onHpDelta: onHpDelta,
          ),
          const SizedBox(height: 16),
          _BenchRow(bench: bench, onTap: onBenchTap),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _ActiveCard extends StatelessWidget {
  final ActivePokemon active;
  final VoidCallback onStatus;
  final VoidCallback onEvolve;
  final VoidCallback onDefeated;
  final ValueChanged<int> onHpChanged;
  final ValueChanged<int> onHpDelta;

  const _ActiveCard({
    required this.active,
    required this.onStatus,
    required this.onEvolve,
    required this.onDefeated,
    required this.onHpChanged,
    required this.onHpDelta,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        children: [
          _HpControl(
            currentHp: active.currentHp,
            maxHp: active.maxHp,
            onChanged: onHpChanged,
            onDelta: onHpDelta,
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(12),
                child: active.card.imageUrl == null
                    ? const Icon(Icons.catching_pokemon, size: 90, color: AppColors.blue)
                    : CachedNetworkImage(
                        imageUrl: active.card.imageUrl!,
                        fit: BoxFit.contain,
                        errorWidget: (_, __, ___) =>
                            const Icon(Icons.catching_pokemon, size: 90, color: AppColors.blue),
                      ),
              ),
              Positioned(
                left: 8, top: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(active.card.name,
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
              Positioned(
                right: 8, top: 8,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: onStatus,
                      child: Container(
                        width: 44, height: 44,
                        decoration: const BoxDecoration(color: AppColors.blue, shape: BoxShape.circle),
                        child: const Icon(Icons.medical_services_outlined, color: Colors.white, size: 20),
                      ),
                    ),
                    for (final s in active.statuses) ...[
                      const SizedBox(height: 6),
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(color: statusConfig[s]!.color, shape: BoxShape.circle),
                        child: Icon(statusConfig[s]!.icon, color: Colors.white, size: 18),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _PillButton(text: 'Evolve', color: AppColors.blue, textColor: Colors.white, width: 160, onTap: onEvolve),
          const SizedBox(height: 8),
          _PillButton(text: 'Defeated', color: AppColors.surfaceVariant, textColor: AppColors.textDark, width: 120, height: 30, onTap: onDefeated),
        ],
      ),
    );
  }
}

class _HpControl extends StatefulWidget {
  final int currentHp;
  final int maxHp;
  final ValueChanged<int> onChanged;
  final ValueChanged<int> onDelta;
  const _HpControl({required this.currentHp, required this.maxHp, required this.onChanged, required this.onDelta});

  @override
  State<_HpControl> createState() => _HpControlState();
}

class _HpControlState extends State<_HpControl> {
  bool _editing = false;
  late final TextEditingController _controller = TextEditingController(text: '${widget.currentHp}');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _hpColor {
    final ratio = widget.maxHp == 0 ? 0 : widget.currentHp / widget.maxHp;
    if (ratio > 0.5) return AppColors.green;
    if (ratio > 0.2) return AppColors.yellow;
    return AppColors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('LIFE', style: AppTextStyles.lifeLabel),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _round(Icons.remove, () => widget.onDelta(-1)),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                _controller.text = '${widget.currentHp}';
                setState(() => _editing = true);
              },
              child: Container(
                width: 96,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: _editing
                    ? TextField(
                        controller: _controller,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        textAlign: TextAlign.center,
                        style: AppTextStyles.hpValue,
                        decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                        onSubmitted: (v) {
                          setState(() => _editing = false);
                          widget.onChanged(int.tryParse(v) ?? widget.currentHp);
                        },
                      )
                    : Text('${widget.currentHp}',
                        style: AppTextStyles.hpValue.copyWith(color: _hpColor)),
              ),
            ),
            const SizedBox(width: 10),
            _round(Icons.add, () => widget.onDelta(1)),
          ],
        ),
        const SizedBox(height: 4),
        Text('máx ${widget.maxHp}', style: AppTextStyles.caption),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _quick('-50', () => widget.onDelta(-50)),
            _quick('-10', () => widget.onDelta(-10)),
            _quick('+10', () => widget.onDelta(10)),
            _quick('+50', () => widget.onDelta(50)),
          ],
        ),
      ],
    );
  }

  Widget _round(IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40, height: 40,
          decoration: const BoxDecoration(color: AppColors.surfaceVariant, shape: BoxShape.circle),
          child: Icon(icon, color: AppColors.blue, size: 20),
        ),
      );

  Widget _quick(String label, VoidCallback onTap) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(label, style: AppTextStyles.labelBold),
          ),
        ),
      );
}

class _BenchRow extends StatelessWidget {
  final List<ActivePokemon> bench;
  final ValueChanged<int> onTap;
  const _BenchRow({required this.bench, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (i) {
        final has = i < bench.length;
        return GestureDetector(
          onTap: () => onTap(i),
          child: Container(
            width: 56,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border, width: has ? 1.5 : 1),
            ),
            padding: const EdgeInsets.all(4),
            child: has
                ? Column(
                    children: [
                      Expanded(
                        child: bench[i].card.imageUrl == null
                            ? const Icon(Icons.catching_pokemon, color: AppColors.blue)
                            : CachedNetworkImage(
                                imageUrl: bench[i].card.imageUrl!,
                                fit: BoxFit.contain,
                                errorWidget: (_, __, ___) =>
                                    const Icon(Icons.catching_pokemon, color: AppColors.blue),
                              ),
                      ),
                      Text('${bench[i].currentHp}',
                          style: AppTextStyles.caption.copyWith(fontSize: 9)),
                    ],
                  )
                : const Icon(Icons.add, color: AppColors.textDim, size: 20),
          ),
        );
      }),
    );
  }
}

// ── Small shared widgets ─────────────────────────────────────────────────────
class _PillButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final double? width;
  final double height;
  final VoidCallback onTap;
  const _PillButton({
    required this.text,
    required this.color,
    required this.textColor,
    this.width,
    this.height = 40,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(28)),
        child: Text(text, style: AppTextStyles.buttonText.copyWith(color: textColor)),
      ),
    );
  }
}

class _PokemonPickTile extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final String subtitle;
  final VoidCallback onTap;
  const _PokemonPickTile({
    required this.imageUrl,
    required this.name,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 84,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84, height: 84,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surface2,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.blue, width: 1.2),
              ),
              child: imageUrl == null
                  ? const Icon(Icons.catching_pokemon, color: AppColors.blue)
                  : CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.contain,
                      errorWidget: (_, __, ___) =>
                          const Icon(Icons.catching_pokemon, color: AppColors.blue),
                    ),
            ),
            const SizedBox(height: 4),
            Text(name,
                style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(subtitle, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final StatusCfg cfg;
  final bool selected;
  final VoidCallback onTap;
  const _StatusRow({required this.cfg, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? cfg.color.withValues(alpha: 0.15) : AppColors.surface2,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? cfg.color : AppColors.border, width: selected ? 1.5 : 1),
          ),
          child: Row(
            children: [
              Icon(cfg.icon, color: cfg.color, size: 22),
              const SizedBox(width: 12),
              Text(cfg.label,
                  style: AppTextStyles.label.copyWith(
                      color: selected ? cfg.color : AppColors.textPrimary,
                      fontWeight: selected ? FontWeight.bold : FontWeight.w500)),
              const Spacer(),
              if (selected) Icon(Icons.check_circle, color: cfg.color, size: 18),
            ],
          ),
        ),
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
          child: Align(alignment: Alignment.bottomCenter, child: BattleMenu(inBattleScreen: true)),
        ),
      ),
    );
  }
}
