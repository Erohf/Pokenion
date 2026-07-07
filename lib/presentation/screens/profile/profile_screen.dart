import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/ad_banner.dart';
import '../../widgets/battle_menu.dart';

/// Preset avatars (no gallery plugin needed). Stored in Auth.photoPath as a key.
const _avatarPresets = <String, IconData>{
  'trainer': Icons.person,
  'pokeball': Icons.catching_pokemon,
  'bolt': Icons.bolt,
  'star': Icons.star,
  'fire': Icons.local_fire_department,
  'shield': Icons.shield,
};

IconData _avatarIcon(String? key) => _avatarPresets[key] ?? Icons.person;

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final plan = ref.watch(settingsProvider).plan;
    final showAds = plan.showsAds;

    return Scaffold(
      backgroundColor: AppColors.bg,
      bottomNavigationBar: const _BottomBar(),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            children: [
              if (showAds) const AdBanner(margin: EdgeInsets.only(bottom: 16)),
              _Header(auth: auth, planLabel: plan.label, onEditPhoto: () => _editPhoto(context, ref)),
              const SizedBox(height: 20),
              _Card(
                child: Column(
                  children: [
                    _MenuItem(
                      title: 'Alterar nome',
                      subtitle: 'Atualize o nome exibido na sua conta.',
                      icon: Icons.badge_outlined,
                      onTap: () => context.push('/profile/name'),
                    ),
                    const _Divider(),
                    _MenuItem(
                      title: 'Planos',
                      subtitle: 'Altere seu plano e remova anúncios.',
                      icon: Icons.star_outline,
                      onTap: () => context.push('/plans'),
                    ),
                    const _Divider(),
                    _MenuItem(
                      title: 'Temas',
                      subtitle: 'Altere a aparência do app.',
                      icon: Icons.palette_outlined,
                      onTap: () => context.push('/profile/themes'),
                    ),
                    const _Divider(),
                    _MenuItem(
                      title: 'Sobre',
                      subtitle: 'Versão e informações do Pokenion.',
                      icon: Icons.info_outline,
                      onTap: () => context.push('/profile/about'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (auth.isGoogleLinked)
                _DangerButton(
                  label: 'Sair da conta',
                  icon: Icons.logout,
                  onPressed: () => _confirmLogout(context, ref),
                )
              else
                _PrimaryButton(
                  label: 'Vincular conta Google',
                  icon: Icons.link,
                  onPressed: () => ref.read(authProvider.notifier).signInWithGoogle(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editPhoto(BuildContext context, WidgetRef ref) async {
    final current = ref.read(authProvider).photoPath;
    final chosen = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Escolha um avatar', style: AppTextStyles.h3),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  for (final entry in _avatarPresets.entries)
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx, entry.key),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: current == entry.key
                            ? AppColors.blue
                            : AppColors.surface2,
                        child: Icon(entry.value,
                            color: current == entry.key ? Colors.white : AppColors.blue),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (chosen != null) ref.read(authProvider.notifier).updatePhoto(chosen);
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Sair da conta', style: AppTextStyles.h3),
        content: Text('Deseja realmente sair? Você voltará à tela de login.',
            style: AppTextStyles.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancelar',
                style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Sair', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (ok == true) ref.read(authProvider.notifier).signOut();
  }
}

class _Header extends StatelessWidget {
  final AuthState auth;
  final String planLabel;
  final VoidCallback onEditPhoto;
  const _Header({required this.auth, required this.planLabel, required this.onEditPhoto});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(
        children: [
          GestureDetector(
            onTap: onEditPhoto,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.blue.withValues(alpha: 0.14),
                  child: Icon(_avatarIcon(auth.photoPath), size: 44, color: AppColors.blue),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: AppColors.blue, shape: BoxShape.circle),
                    child: const Icon(Icons.edit, size: 12, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome back!', style: AppTextStyles.bodyBold),
                const SizedBox(height: 2),
                Text(auth.name.isEmpty ? 'Treinador' : auth.name, style: AppTextStyles.h3),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(auth.isGoogleLinked ? Icons.verified : Icons.person_outline,
                        color: auth.isGoogleLinked ? AppColors.green : AppColors.textSecondary,
                        size: 16),
                    const SizedBox(width: 6),
                    Text(
                      auth.isGoogleLinked ? 'Conta vinculada' : 'Modo visitante',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: auth.isGoogleLinked ? AppColors.green : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(planLabel, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sub-screens ──────────────────────────────────────────────────────────────
class ChangeNameScreen extends ConsumerStatefulWidget {
  const ChangeNameScreen({super.key});
  @override
  ConsumerState<ChangeNameScreen> createState() => _ChangeNameScreenState();
}

class _ChangeNameScreenState extends ConsumerState<ChangeNameScreen> {
  late final TextEditingController _controller =
      TextEditingController(text: ref.read(authProvider).name);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      _snack(context, 'Informe um nome para continuar.', AppColors.red);
      return;
    }
    ref.read(authProvider.notifier).updateName(name);
    _snack(context, 'Nome atualizado.', AppColors.green);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return _SubScaffold(
      title: 'Alterar nome',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Nome da conta', style: AppTextStyles.labelBold),
                const SizedBox(height: 12),
                TextField(
                  controller: _controller,
                  style: const TextStyle(color: AppColors.textPrimary),
                  textCapitalization: TextCapitalization.words,
                  onSubmitted: (_) => _save(),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline, color: AppColors.blue),
                    hintText: 'Digite seu nome',
                    hintStyle: const TextStyle(color: AppColors.textDim),
                    filled: true,
                    fillColor: AppColors.surface2,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _PrimaryButton(label: 'Salvar nome', icon: Icons.check, onPressed: _save),
        ],
      ),
    );
  }
}

class ThemesScreen extends ConsumerWidget {
  const ThemesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(settingsProvider).themeMode;
    return _SubScaffold(
      title: 'Temas',
      child: _Card(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            _ThemeItem(
              title: 'Tema escuro',
              subtitle: 'Interface com fundo escuro.',
              icon: Icons.dark_mode_outlined,
              selected: themeMode == ThemeMode.dark,
              onTap: () => ref.read(settingsProvider.notifier).setTheme(ThemeMode.dark),
            ),
            const _Divider(),
            _ThemeItem(
              title: 'Tema claro',
              subtitle: 'Em breve — o modo claro será liberado numa próxima versão.',
              icon: Icons.light_mode_outlined,
              selected: themeMode == ThemeMode.light,
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('O tema claro será adicionado em breve.'),
                  backgroundColor: AppColors.surface2,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return _SubScaffold(
      title: 'Sobre',
      child: Column(
        children: [
          _Card(
            child: Column(
              children: [
                const _InfoRow(label: 'Versão atual', value: '1.0 (30/11/23)'),
                const _Divider(),
                _AboutTile(
                  title: 'Política de privacidade',
                  subtitle: 'Leia sobre nossa política.',
                  onTap: () {},
                ),
                const _Divider(),
                _AboutTile(
                  title: 'Procurar atualizações',
                  subtitle: 'Deixe seu app sempre atualizado!',
                  trailing: const Icon(Icons.refresh, color: AppColors.blue),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Você já possui a versão mais recente.'),
                      backgroundColor: AppColors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared widgets ───────────────────────────────────────────────────────────
class _SubScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  const _SubScaffold({required this.title, required this.child});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(title, style: AppTextStyles.h3),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: child,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const _Card({required this.child, this.padding = const EdgeInsets.all(16)});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  const _MenuItem({required this.title, required this.subtitle, required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: Icon(icon, color: AppColors.blue, size: 22),
      title: Text(title, style: AppTextStyles.labelBold),
      subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}

class _ThemeItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _ThemeItem({required this.title, required this.subtitle, required this.icon, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Icon(icon, color: AppColors.blue, size: 22),
      title: Text(title, style: AppTextStyles.labelBold),
      subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
      trailing: selected
          ? const Icon(Icons.check_circle, color: AppColors.green)
          : const Icon(Icons.radio_button_unchecked, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}

class _AboutTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;
  const _AboutTile({required this.title, required this.subtitle, this.trailing, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: AppTextStyles.labelBold),
      subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.labelBold),
                const SizedBox(height: 2),
                Text(value, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) => const Divider(height: 1, color: AppColors.border);
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  const _PrimaryButton({required this.label, required this.icon, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: AppTextStyles.buttonText.copyWith(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

class _DangerButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  const _DangerButton({required this.label, required this.icon, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.logout, color: AppColors.red),
        label: Text(label, style: AppTextStyles.buttonText.copyWith(color: AppColors.red)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.red),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

void _snack(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
