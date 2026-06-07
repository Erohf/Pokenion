import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/models/deck.dart';
import 'app_card.dart';

class DeckListItem extends StatelessWidget {
  final Deck deck;
  final VoidCallback? onTap;
  final VoidCallback? onPlayTap;
  final VoidCallback? onEditTap;

  const DeckListItem({
    super.key,
    required this.deck,
    this.onTap,
    this.onPlayTap,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimary : AppColors.textDark;
    final subColor = isDark ? AppColors.textSecondary : Colors.grey[600]!;

    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Deck Cover Placeholder
            Container(
              width: 60,
              height: 80,
              decoration: BoxDecoration(
                color: isDark ? AppColors.surface2 : const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.style,
                color: isDark ? AppColors.textDim : Colors.grey,
              ),
            ),
            const SizedBox(width: 16),
            // Deck Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deck.name,
                    style: AppTextStyles.h3.copyWith(color: textColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deck.format ?? 'Standard',
                    style: AppTextStyles.bodySmall.copyWith(color: subColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${deck.cards.length} carta${deck.cards.length == 1 ? '' : 's'}',
                    style: AppTextStyles.caption.copyWith(color: subColor),
                  ),
                ],
              ),
            ),
            // Edit button
            IconButton(
              onPressed: onEditTap,
              icon: Icon(
                Icons.edit_outlined,
                color: isDark ? AppColors.textSecondary : Colors.grey,
                size: 20,
              ),
              tooltip: 'Renomear deck',
            ),
            // Play Button
            IconButton(
              onPressed: onPlayTap,
              icon: const Icon(
                Icons.play_circle_fill,
                color: AppColors.blue,
                size: 32,
              ),
              tooltip: 'Jogar',
            ),
          ],
        ),
      ),
    );
  }
}
