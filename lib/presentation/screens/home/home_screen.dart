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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.bg : const Color(0xFFF5F5F5);
    final adColor = isDark ? AppColors.surfaceVariant : const Color(0xFFE0E0E0);
    final adTextColor = isDark ? AppColors.textDark : Colors.grey[600]!;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Top Banner (Mock Ad)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
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

            // Content
            Padding(
              padding: const EdgeInsets.only(top: 116, left: 16, right: 16, bottom: 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meus Decks',
                    style: AppTextStyles.h2.copyWith(
                      color: isDark ? AppColors.textPrimary : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Selecione um deck para começar:',
                    style: AppTextStyles.body.copyWith(
                      color: isDark ? AppColors.textSecondary : Colors.grey[600]!,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: decksAsync.when(
                      data: (decks) => decks.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.style_outlined,
                                    size: 64,
                                    color: isDark ? AppColors.textDim : Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Nenhum deck criado.',
                                    style: AppTextStyles.body.copyWith(
                                      color: isDark ? AppColors.textSecondary : Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Toque no + para criar seu primeiro deck.',
                                    style: AppTextStyles.caption.copyWith(
                                      color: isDark ? AppColors.textDim : Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              itemCount: decks.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final deck = decks[index];
                                return DeckListItem(
                                  deck: deck,
                                  onTap: () => context.push('/deck/${deck.id}'),
                                  onPlayTap: () => context.push('/deck/${deck.id}/battle'),
                                  onEditTap: () => _showRenameDialog(context, ref, deck.id, deck.name),
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
              bottom: 148,
              child: FloatingActionButton(
                onPressed: () => _showCreateDeckDialog(context, ref),
                backgroundColor: AppColors.blue,
                child: const Icon(Icons.add, color: AppColors.textPrimary),
              ),
            ),

            // Bottom Menu
            const Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(child: BattleMenu()),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCreateDeckDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => _DeckNameDialog(
        title: 'Novo Deck',
        confirmLabel: 'Criar',
        controller: controller,
      ),
    );
    if (result != null && result.trim().isNotEmpty) {
      ref.read(deckNotifierProvider.notifier).addDeck(result.trim());
    }
  }

  Future<void> _showRenameDialog(
    BuildContext context,
    WidgetRef ref,
    String deckId,
    String currentName,
  ) async {
    final controller = TextEditingController(text: currentName);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => _DeckNameDialog(
        title: 'Renomear Deck',
        confirmLabel: 'Salvar',
        controller: controller,
      ),
    );
    if (result != null && result.trim().isNotEmpty) {
      ref.read(deckNotifierProvider.notifier).renameDeck(deckId, result.trim());
    }
  }
}

class _DeckNameDialog extends StatelessWidget {
  final String title;
  final String confirmLabel;
  final TextEditingController controller;

  const _DeckNameDialog({
    required this.title,
    required this.confirmLabel,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.surface : Colors.white;
    final textColor = isDark ? AppColors.textPrimary : AppColors.textDark;

    return AlertDialog(
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        title,
        style: AppTextStyles.h3.copyWith(color: textColor),
      ),
      content: TextField(
        controller: controller,
        autofocus: true,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          hintText: 'Nome do deck',
          hintStyle: TextStyle(
            color: isDark ? AppColors.textDim : Colors.grey,
          ),
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
        onSubmitted: (v) => Navigator.of(context).pop(v),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancelar',
            style: TextStyle(color: isDark ? AppColors.textSecondary : Colors.grey),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(controller.text),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            confirmLabel,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
