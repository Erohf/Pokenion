import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/app_card.dart';
import '../../widgets/battle_menu.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String _userName = 'Lucas Andrade';

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);
    final isDark = themeMode == ThemeMode.dark;
    final bgColor = isDark ? AppColors.bg : const Color(0xFFF5F5F5);
    final adColor = isDark ? AppColors.surfaceVariant : const Color(0xFFE0E0E0);
    final adTextColor = isDark ? AppColors.textDark : Colors.grey[600]!;
    final textColor = isDark ? AppColors.textPrimary : AppColors.textDark;

    return Scaffold(
      backgroundColor: bgColor,
      // Fixed bottom nav using bottomNavigationBar slot
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16, top: 8),
          child: const Center(child: BattleMenu()),
        ),
      ),
      body: SafeArea(
        bottom: false,
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
              padding: const EdgeInsets.only(top: 116, left: 16, right: 16, bottom: 24),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // User Info Card
                    AppCard(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: isDark ? AppColors.surface2 : const Color(0xFFEEEEEE),
                            child: Icon(
                              Icons.person,
                              size: 48,
                              color: AppColors.blue,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bem-vindo!',
                                  style: AppTextStyles.bodyBold.copyWith(color: textColor),
                                ),
                                Text(
                                  _userName,
                                  style: AppTextStyles.h3.copyWith(color: textColor),
                                ),
                                const Text(
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
                            icon: Icons.person_outline,
                            onTap: () => _showAccountDialog(context, isDark, textColor),
                          ),
                          Divider(
                            height: 1,
                            color: isDark ? AppColors.border : const Color(0xFFEEEEEE),
                          ),
                          _ProfileMenuItem(
                            title: 'Planos',
                            subtitle: 'Altere seu plano para customizar o aplicativo.',
                            icon: Icons.star_outline,
                            onTap: () => context.push('/plans'),
                          ),
                          Divider(
                            height: 1,
                            color: isDark ? AppColors.border : const Color(0xFFEEEEEE),
                          ),
                          _ProfileMenuItem(
                            title: 'Temas',
                            subtitle: 'Altere a aparência do app.',
                            icon: Icons.palette_outlined,
                            trailing: Switch(
                              value: isDark,
                              onChanged: (_) => ref.read(themeNotifierProvider.notifier).toggle(),
                              activeColor: AppColors.blue,
                            ),
                            onTap: () => _showThemeDialog(context, ref, isDark, textColor),
                          ),
                          Divider(
                            height: 1,
                            color: isDark ? AppColors.border : const Color(0xFFEEEEEE),
                          ),
                          _ProfileMenuItem(
                            title: 'Sobre',
                            subtitle: 'Versão e informações do app.',
                            icon: Icons.info_outline,
                            onTap: () => _showAboutDialog(context, isDark, textColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Account Dialog ───────────────────────────────────────────────
  void _showAccountDialog(BuildContext context, bool isDark, Color textColor) {
    final nameCtrl = TextEditingController(text: _userName);
    final passCtrl = TextEditingController();
    final bgColor = isDark ? AppColors.surface : Colors.white;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Minha Conta', style: AppTextStyles.h3.copyWith(color: textColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StyledTextField(
              controller: nameCtrl,
              label: 'Nome',
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            _StyledTextField(
              controller: passCtrl,
              label: 'Nova senha',
              isDark: isDark,
              obscureText: true,
            ),
          ],
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
            onPressed: () {
              setState(() => _userName = nameCtrl.text.trim().isNotEmpty
                  ? nameCtrl.text.trim()
                  : _userName);
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Salvar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─── Theme Dialog ─────────────────────────────────────────────────
  void _showThemeDialog(BuildContext context, WidgetRef ref, bool isDark, Color textColor) {
    final bgColor = isDark ? AppColors.surface : Colors.white;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Tema', style: AppTextStyles.h3.copyWith(color: textColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ThemeOption(
              label: '🌙  Escuro',
              selected: isDark,
              isDark: isDark,
              onTap: () {
                ref.read(themeNotifierProvider.notifier).setTheme(ThemeMode.dark);
                Navigator.of(ctx).pop();
              },
            ),
            const SizedBox(height: 8),
            _ThemeOption(
              label: '☀️  Claro',
              selected: !isDark,
              isDark: isDark,
              onTap: () {
                ref.read(themeNotifierProvider.notifier).setTheme(ThemeMode.light);
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Fechar',
              style: TextStyle(color: isDark ? AppColors.textSecondary : Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  // ─── About Dialog ─────────────────────────────────────────────────
  void _showAboutDialog(BuildContext context, bool isDark, Color textColor) {
    final bgColor = isDark ? AppColors.surface : Colors.white;
    final subColor = isDark ? AppColors.textSecondary : Colors.grey[600]!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Sobre o Pokenion', style: AppTextStyles.h3.copyWith(color: textColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.catching_pokemon, color: AppColors.blue, size: 36),
              ),
            ),
            const SizedBox(height: 16),
            _AboutRow(
              label: 'Versão',
              value: '1.0.0',
              isDark: isDark,
            ),
            const SizedBox(height: 8),
            _AboutRow(
              label: 'Build',
              value: '2026.06.07',
              isDark: isDark,
            ),
            const SizedBox(height: 16),
            Text(
              'Política de Privacidade',
              style: TextStyle(
                color: AppColors.blue,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Você já possui a versão mais recente! 🎉'),
                      backgroundColor: AppColors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                icon: const Icon(Icons.update, color: Colors.white),
                label: const Text('Procurar Atualizações', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Fechar',
              style: TextStyle(color: isDark ? AppColors.textSecondary : Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Helper Widgets ───────────────────────────────────────────────────────────

class _ProfileMenuItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Widget? trailing;

  const _ProfileMenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimary : AppColors.textDark;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Icon(icon, color: AppColors.blue, size: 22),
      title: Text(
        title,
        style: AppTextStyles.labelBold.copyWith(color: textColor),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall.copyWith(
          color: isDark ? AppColors.textSecondary : Colors.grey[600],
        ),
      ),
      trailing: trailing ??
          Icon(
            Icons.chevron_right,
            color: isDark ? AppColors.textSecondary : Colors.grey,
          ),
      onTap: onTap,
    );
  }
}

class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isDark;
  final bool obscureText;

  const _StyledTextField({
    required this.controller,
    required this.label,
    required this.isDark,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: isDark ? AppColors.textPrimary : AppColors.textDark),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isDark ? AppColors.textSecondary : Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: isDark ? AppColors.border : const Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.label,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.blue.withOpacity(0.15)
              : (isDark ? AppColors.surface2 : const Color(0xFFF5F5F5)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.blue : (isDark ? AppColors.border : const Color(0xFFE0E0E0)),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.blue : (isDark ? AppColors.textPrimary : AppColors.textDark),
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            if (selected)
              const Icon(Icons.check_circle, color: AppColors.blue, size: 20),
          ],
        ),
      ),
    );
  }
}

class _AboutRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _AboutRow({required this.label, required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.textPrimary : AppColors.textDark;
    final subColor = isDark ? AppColors.textSecondary : Colors.grey[600]!;
    return Row(
      children: [
        Text('$label: ', style: AppTextStyles.caption.copyWith(color: subColor)),
        Text(value, style: AppTextStyles.bodySmall.copyWith(color: textColor, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
