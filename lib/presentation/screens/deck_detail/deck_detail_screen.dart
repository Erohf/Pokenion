import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/deck_provider.dart';
import '../../widgets/card_thumbnail.dart';
import '../../widgets/app_card.dart';

class DeckDetailScreen extends ConsumerWidget {
  final String deckId;

  const DeckDetailScreen({super.key, required this.deckId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decksAsync = ref.watch(deckNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.textPrimary),
            onPressed: () {
              // TODO: Edit deck
            },
          ),
        ],
      ),
      body: SafeArea(
        child: decksAsync.when(
          data: (decks) {
            final deck = decks.firstWhere((d) => d.id == deckId);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(deck.name, style: AppTextStyles.h1),
                      const SizedBox(height: 4),
                      Text(
                        deck.format ?? 'Standard',
                        style: AppTextStyles.body.copyWith(color: AppColors.blue),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _StatItem(label: 'Partidas', value: deck.totalMatches.toString()),
                          const SizedBox(width: 24),
                          _StatItem(label: 'Vitórias', value: deck.wins.toString()),
                          const SizedBox(width: 24),
                          _StatItem(label: 'Derrotas', value: deck.losses.toString()),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Cards Grid
                Expanded(
                  child: AppCard(
                    color: AppColors.surface,
                    borderRadius: 24,
                    padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cartas', style: AppTextStyles.h2),
                        const SizedBox(height: 16),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: deck.cards.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                // Add card button
                                return GestureDetector(
                                  onTap: () {
                                    // TODO: Add card
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.surface2,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: AppColors.border, width: 1),
                                    ),
                                    child: const Icon(Icons.add, color: AppColors.textDim, size: 32),
                                  ),
                                );
                              }
                              final deckCard = deck.cards[index - 1];
                              return CardThumbnail(
                                imageUrl: deckCard.card.imageUrl,
                                width: double.infinity,
                                height: double.infinity,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Play Button
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => context.push('/deck/$deckId/battle'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'INICIAR BATALHA',
                        style: AppTextStyles.buttonText.copyWith(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Erro: $err')),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        Text(value, style: AppTextStyles.h3),
      ],
    );
  }
}

// Helper because ElevatedButton.styleFrom shape might be tricky with RoundedRectangleBorder
extension on ElevatedButton {
  // Just use standard RoundedRectangleBorder
}
