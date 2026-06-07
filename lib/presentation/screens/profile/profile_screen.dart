import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/app_card.dart';
import '../../widgets/battle_menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
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
                    // User Info Card
                    const AppCard(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: AppColors.surface2,
                            child: Icon(Icons.person, size: 48, color: AppColors.blue),
                          ),
                          SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Bem-vindo!', style: AppTextStyles.bodyBold),
                                Text('Lucas Andrade', style: AppTextStyles.h3),
                                Text(
                                  'Conta Vinculada',
                                  style: TextStyle(
                                    color: AppColors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Menu List
                    AppCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          _ProfileMenuItem(
                            title: 'Conta',
                            subtitle: 'Mude seu nome e senha.',
                            onTap: () {},
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          _ProfileMenuItem(
                            title: 'Planos',
                            subtitle: 'Altere seu plano para customizar o aplicativo e não ver anúncios.',
                            onTap: () => context.push('/plans'),
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          _ProfileMenuItem(
                            title: 'Temas',
                            subtitle: 'Altere a aparência do app.',
                            onTap: () {},
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          _ProfileMenuItem(
                            title: 'Sobre',
                            subtitle: 'Versão e informações do app.',
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

class _ProfileMenuItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.title,
    required this.subtitle,
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
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
