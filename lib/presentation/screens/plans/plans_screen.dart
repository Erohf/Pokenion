import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/app_card.dart';
import '../../widgets/battle_menu.dart';

class PlansScreen extends StatelessWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Planos', style: AppTextStyles.h2),
      ),
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AppCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          _PlanMenuItem(
                            title: 'Plano Freemium',
                            subtitle: 'Gratuito para todos os usuários.',
                            isSelected: true,
                            onTap: () {},
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          _PlanMenuItem(
                            title: 'Plano Premium',
                            subtitle: 'Desbloqueie temas, aumente o número de coleções e muito mais.',
                            isSelected: false,
                            onTap: () {},
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          _PlanMenuItem(
                            title: 'Plano No-Ads',
                            subtitle: 'Remova os ads permanentemente.',
                            isSelected: false,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
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

class _PlanMenuItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanMenuItem({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(title, style: AppTextStyles.labelBold),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.green)
          : const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
