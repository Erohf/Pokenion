import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/deck_provider.dart';
import '../../widgets/deck_list_item.dart';
import '../../widgets/battle_menu.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decksAsync = ref.watch(deckNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Stack(
          children: [
            // Top Banner (Mock Ad as in Figma)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                color: AppColors.surfaceVariant,
                alignment: Alignment.center,
                child: Text(
                  'AD',
                  style: AppTextStyles.h1.copyWith(color: AppColors.textDark),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.only(top: 116, left: 16, right: 16, bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meus Decks',
                    style: AppTextStyles.h2,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Selecione um deck para começar:',
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: decksAsync.when(
                      data: (decks) => ListView.separated(
                        itemCount: decks.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final deck = decks[index];
                          return DeckListItem(
                            deck: deck,
                            onTap: () => context.push('/deck/${deck.id}'),
                            onPlayTap: () => context.push('/deck/${deck.id}/battle'),
                          );
                        },
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Center(child: Text('Erro: $err')),
                    ),
                  ),
                ],
              ),
            ),

            // FAB for adding deck
            Positioned(
              right: 24,
              bottom: 140,
              child: FloatingActionButton(
                onPressed: () {
                  // TODO: Import Deck flow
                },
                backgroundColor: AppColors.blue,
                child: const Icon(Icons.add, color: AppColors.textPrimary),
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
