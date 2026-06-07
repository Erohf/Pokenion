import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/hp_tracker.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/battle_menu.dart';
import '../../widgets/energy_tracker.dart';
import '../../providers/battle_provider.dart';
import '../../../domain/models/status_condition.dart';

class BattleScreen extends ConsumerWidget {
  const BattleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final battleState = ref.watch(battleProvider);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Propaganda (Ad banner)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                color: AppColors.surfaceVariant,
                alignment: Alignment.center,
                child: const Text(
                  'AD',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            
            // Main Content
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 116, bottom: 120),
                child: MainCard(
                  state: battleState,
                  onHpChanged: (hp) => ref.read(battleProvider.notifier).updateHp(hp),
                ),
              ),
            ),
            
            // Bottom Menu
            const Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: BattleMenu(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainCard extends StatelessWidget {
  final dynamic state;
  final ValueChanged<int> onHpChanged;

  const MainCard({
    super.key,
    required this.state,
    required this.onHpChanged,
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
    final active = state.activePokemon;
    final currentHp = active?.currentHp ?? 0;
    final maxHp = active?.maxHp ?? 0;

    return Container(
      width: 300,
      height: 544,
      child: Stack(
        children: [
          // Background Card
          Positioned(
            top: 44,
            bottom: 80,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                border: Border.all(color: AppColors.borderVariant, width: 2),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          
          // Internal area for image
          Positioned(
            top: 140,
            bottom: 112,
            left: 32,
            right: 32,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.borderVariant,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          
          // Pokemon Image
          Positioned(
            top: 176,
            bottom: 148,
            left: 64,
            right: 64,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: const DecorationImage(
                  image: CachedNetworkImageProvider('https://www.figma.com/api/mcp/asset/e70fb7ba-4f39-45b4-af56-6a4c6484e8f4'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          // Turbo Tag
          Positioned(
            top: 154,
            left: 48,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bolt, color: AppColors.blue, size: 16),
                const SizedBox(width: 4),
                const Text('Turbo', style: AppTextStyles.turboTag),
              ],
            ),
          ),
          
          // LIFE Section (HpTracker)
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Center(
                  child: HpTracker(
                    currentHp: currentHp,
                    maxHp: maxHp,
                    onChanged: onHpChanged,
                  ),
                ),
                if (active != null) ...[
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
            bottom: 100,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ActionButton(
                  text: 'Evolve',
                  color: AppColors.blue,
                  width: 128,
                  onPressed: () {},
                ),
                const SizedBox(height: 8),
                _ActionButton(
                  text: 'Defeated',
                  color: AppColors.textDark,
                  width: 96,
                  height: 24,
                  fontSize: 12,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          
          // Stats & Status Conditions (Right side)
          Positioned(
            top: 116,
            right: 8,
            child: Column(
              children: [
                StatusBadge(
                  icon: const Text('Stats', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  backgroundColor: AppColors.blue,
                  onTap: () {},
                ),
                const SizedBox(height: 5),
                StatusBadge(
                  icon: const Icon(Icons.dangerous, size: 16, color: AppColors.textDark),
                  label: 'x3',
                ),
                const SizedBox(height: 5),
                StatusBadge(
                  icon: const Icon(Icons.local_fire_department, size: 16, color: AppColors.textDark),
                  label: 'x2',
                ),
                const SizedBox(height: 5),
                const StatusBadge(
                  icon: Icon(Icons.cyclone, size: 16, color: AppColors.textDark),
                ),
              ],
            ),
          ),
          
          // Bench / Bottom Cards
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) => _BenchCard(index: index)),
            ),
          ),
          
          // Control Buttons (End Game, New Game)
          const Positioned(
            top: 0,
            left: 22,
            right: 22,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ControlButton(text: 'End Game', color: AppColors.textDark),
                SizedBox(width: 32),
                _ControlButton(text: 'New Game', color: AppColors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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

  const _ControlButton({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _BenchCard extends StatelessWidget {
  final int index;

  const _BenchCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final images = [
      'https://www.figma.com/api/mcp/asset/95577525-bcac-40ca-8904-9343075d653c',
      'https://www.figma.com/api/mcp/asset/e7e691a0-9cf0-4046-8a3c-7224cd5c7982',
      'https://www.figma.com/api/mcp/asset/14186477-c313-4374-aebd-bb4806b8323e',
      'https://www.figma.com/api/mcp/asset/31e0304c-3dc6-4422-b52e-26a471d68dec',
      'https://www.figma.com/api/mcp/asset/d49996b3-64bd-491d-8050-565a18059112',
    ];

    return Container(
      width: 48,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        border: Border.all(color: AppColors.borderVariant, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: images[index],
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
