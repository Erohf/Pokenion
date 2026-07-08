import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/ad_banner.dart';
import '../../widgets/battle_menu.dart';

class PlansScreen extends ConsumerWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final showAds = settings.plan.showsAds;

    return Scaffold(
      backgroundColor: context.palette.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.palette.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Planos', style: AppTextStyles.h3),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (showAds) const AdBanner(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: context.palette.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: context.palette.border),
                    ),
                    child: Column(
                      children: [
                        _PlanRow(
                          title: PlanType.freemium.label,
                          subtitle: 'Gratuito para todos os usuários.',
                          selected: settings.plan == PlanType.freemium,
                          onTap: () => ref.read(settingsProvider.notifier).setPlan(PlanType.freemium),
                        ),
                        Divider(height: 1, color: context.palette.border),
                        _PlanRow(
                          title: PlanType.premium.label,
                          subtitle: 'Desbloqueie temas, aumente o número de coleções e muito mais.',
                          selected: settings.plan == PlanType.premium,
                          onTap: () => context.push('/plans/premium'),
                        ),
                        Divider(height: 1, color: context.palette.border),
                        _PlanRow(
                          title: PlanType.noAds.label,
                          subtitle: 'Remova os ads permanentemente.',
                          selected: settings.plan == PlanType.noAds,
                          onTap: () => context.push('/plans/no-ads'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _BottomBar(),
    );
  }
}

class _PlanRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  const _PlanRow({required this.title, required this.subtitle, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(title, style: AppTextStyles.labelBold),
      subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
      trailing: selected
          ? const Icon(Icons.check_circle, color: AppColors.blue)
          : const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}

/// Detail screen for Premium / No-Ads with a subscribe action.
class PlanDetailScreen extends ConsumerWidget {
  final bool premium;
  const PlanDetailScreen({super.key, required this.premium});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = premium ? 'Plano Premium' : 'No-Ads';
    final tagline = premium ? 'Desbloqueio Tudo!' : 'Remova os anúncios permanentemente!';
    final features = premium
        ? const [
            'Desative os anúncios.',
            'Desbloqueie estilos únicos.',
            'Número ilimitado de coleções.',
            'Insígnia personalizada premium.',
          ]
        : const [
            'Desative os anúncios.',
            'Insígnia personalizada no-ads.',
          ];

    return Scaffold(
      backgroundColor: context.palette.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.palette.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Planos', style: AppTextStyles.h3),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.palette.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.palette.border),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(title, style: AppTextStyles.h2),
                  const SizedBox(height: 4),
                  Text(tagline, style: AppTextStyles.body),
                  const SizedBox(height: 16),
                  for (final f in features) ...[
                    Row(
                      children: [
                        Expanded(child: Text(f, style: AppTextStyles.label.copyWith(fontSize: 15))),
                        const Icon(Icons.check, color: AppColors.blue),
                      ],
                    ),
                    if (f != features.last) Divider(height: 20, color: context.palette.border),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(settingsProvider.notifier).setPlan(premium ? PlanType.premium : PlanType.noAds);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$title ativado!'),
                      backgroundColor: AppColors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                  context.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                child: Text('Assinar', style: AppTextStyles.buttonText.copyWith(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 132,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Align(alignment: Alignment.bottomCenter, child: BattleMenu()),
        ),
      ),
    );
  }
}
