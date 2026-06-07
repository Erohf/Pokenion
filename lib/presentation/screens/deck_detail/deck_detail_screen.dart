import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/deck_provider.dart';
import '../../widgets/card_thumbnail.dart';
import '../../widgets/app_card.dart';
import '../../widgets/pokemon_picker_dialog.dart';

class DeckDetailScreen extends ConsumerWidget {
  final String deckId;

  const DeckDetailScreen({super.key, required this.deckId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decksAsync = ref.watch(deckNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.bg : const Color(0xFFF5F5F5);
    final textColor = isDark ? AppColors.textPrimary : AppColors.textDark;
    final cardBg = isDark ? AppColors.surface : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: textColor),
            tooltip: 'Renomear deck',
            onPressed: () {
              final deck = decksAsync.value?.firstWhere((d) => d.id == deckId);
              if (deck != null) {
                _showRenameDialog(context, ref, deck.name);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: decksAsync.when(
          data: (decks) {
            final deckIndex = decks.indexWhere((d) => d.id == deckId);
            if (deckIndex < 0) {
              return Center(
                child: Text('Deck não encontrado.', style: TextStyle(color: textColor)),
              );
            }
            final deck = decks[deckIndex];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(deck.name, style: AppTextStyles.h1.copyWith(color: textColor)),
                      const SizedBox(height: 4),
                      Text(
                        deck.format ?? 'Standard',
                        style: AppTextStyles.body.copyWith(color: AppColors.blue),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Cards Grid
                Expanded(
                  child: AppCard(
                    color: cardBg,
                    borderRadius: 24,
                    padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Cartas',
                              style: AppTextStyles.h2.copyWith(color: textColor),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.blue.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${deck.cards.length}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
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
                                  onTap: () => _addCard(context, ref),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.surface2
                                          : const Color(0xFFF0F0F0),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isDark ? AppColors.border : const Color(0xFFDDDDDD),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_circle_outline,
                                          color: AppColors.blue,
                                          size: 32,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Adicionar',
                                          style: AppTextStyles.caption.copyWith(
                                            color: AppColors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              final deckCard = deck.cards[index - 1];
                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  CardThumbnail(
                                    imageUrl: deckCard.card.imageUrl,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                  if (deckCard.quantity > 1)
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.blue,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'x${deckCard.quantity}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
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

  Future<void> _addCard(BuildContext context, WidgetRef ref) async {
    final card = await showPokemonPickerDialog(context);
    if (card != null) {
      ref.read(deckNotifierProvider.notifier).addCardToDeck(deckId, card);
    }
  }

  Future<void> _showRenameDialog(
    BuildContext context,
    WidgetRef ref,
    String currentName,
  ) async {
    final controller = TextEditingController(text: currentName);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.surface : Colors.white;
    final textColor = isDark ? AppColors.textPrimary : AppColors.textDark;

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Renomear Deck',
          style: AppTextStyles.h3.copyWith(color: textColor),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: 'Nome do deck',
            hintStyle: TextStyle(color: isDark ? AppColors.textDim : Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? AppColors.border : const Color(0xFFE0E0E0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
            ),
          ),
          onSubmitted: (v) => Navigator.of(ctx).pop(v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancelar',
              style: TextStyle(color: isDark ? AppColors.textSecondary : Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Salvar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (result != null && result.trim().isNotEmpty) {
      ref.read(deckNotifierProvider.notifier).renameDeck(deckId, result.trim());
    }
  }
}
