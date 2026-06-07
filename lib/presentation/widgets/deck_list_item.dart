import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/models/deck.dart';
import 'app_card.dart';

class DeckListItem extends StatelessWidget {
  final Deck deck;
  final VoidCallback? onTap;
  final VoidCallback? onPlayTap;

  const DeckListItem({
    super.key,
    required this.deck,
    this.onTap,
    this.onPlayTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Deck Cover / Thumbnail placeholder
            Container(
              width: 60,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.surface2,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.style, color: AppColors.textDim),
            ),
            const SizedBox(width: 16),
            // Deck Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deck.name,
                    style: AppTextStyles.h3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deck.format ?? 'Standard',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _StatBadge(label: 'W', value: deck.wins.toString(), color: AppColors.green),
                      const SizedBox(width: 8),
                      _StatBadge(label: 'L', value: deck.losses.toString(), color: AppColors.red),
                    ],
                  ),
                ],
              ),
            ),
            // Play Button
            IconButton(
              onPressed: onPlayTap,
              icon: const Icon(Icons.play_circle_fill, color: AppColors.blue, size: 32),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label:',
          style: AppTextStyles.caption,
        ),
        const SizedBox(width: 2),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
