import 'package:flutter/material.dart';
import '../../domain/models/status_condition.dart';
import '../../core/theme/app_colors.dart';

class EnergyTracker extends StatelessWidget {
  final Map<EnergyType, int> energies;
  final Function(EnergyType)? onAdd;
  final Function(EnergyType)? onRemove;

  const EnergyTracker({
    super.key,
    required this.energies,
    this.onAdd,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: EnergyType.values.map((type) {
          final count = energies[type] ?? 0;
          if (count == 0 && onAdd == null) return const SizedBox.shrink();
          
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: _EnergyBadge(
              type: type,
              count: count,
              onTap: () => onAdd?.call(type),
              onLongPress: () => onRemove?.call(type),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _EnergyBadge extends StatelessWidget {
  final EnergyType type;
  final int count;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _EnergyBadge({
    required this.type,
    required this.count,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: _getEnergyColor(type),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _getEnergyIcon(type),
            if (count > 0) ...[
              const SizedBox(width: 4),
              Text(
                'x$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getEnergyColor(EnergyType type) {
    switch (type) {
      case EnergyType.fire: return AppColors.energyFire;
      case EnergyType.water: return AppColors.energyWater;
      case EnergyType.grass: return AppColors.energyGrass;
      case EnergyType.lightning: return AppColors.energyLightning;
      case EnergyType.psychic: return AppColors.energyPsychic;
      case EnergyType.fighting: return AppColors.energyFighting;
      case EnergyType.darkness: return AppColors.energyDarkness;
      case EnergyType.metal: return AppColors.energyMetal;
      case EnergyType.dragon: return AppColors.energyDragon;
      case EnergyType.colorless: return AppColors.energyColorless;
      default: return Colors.grey;
    }
  }

  Widget _getEnergyIcon(EnergyType type) {
    IconData icon;
    switch (type) {
      case EnergyType.fire: icon = Icons.local_fire_department; break;
      case EnergyType.water: icon = Icons.water_drop; break;
      case EnergyType.grass: icon = Icons.eco; break;
      case EnergyType.lightning: icon = Icons.bolt; break;
      case EnergyType.psychic: icon = Icons.psychology; break;
      case EnergyType.fighting: icon = Icons.fitness_center; break;
      case EnergyType.darkness: icon = Icons.nightlight_round; break;
      case EnergyType.metal: icon = Icons.shield; break;
      case EnergyType.dragon: icon = Icons.auto_awesome; break;
      case EnergyType.colorless: icon = Icons.circle; break;
      default: icon = Icons.help;
    }
    return Icon(icon, size: 14, color: Colors.white);
  }
}
