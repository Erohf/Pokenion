import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import '../../../core/audio/sfx.dart';
import '../../widgets/ad_banner.dart';
import '../../widgets/battle_menu.dart';
import '../../widgets/pixel.dart';

/// Preset avatars. Stored in Auth.photoPath as a preset key. Real photos taken
/// from the camera/gallery are stored as a `b64:<base64>` string instead, so the
/// same field works across web and mobile without touching the filesystem.
const _avatarPresets = <String, IconData>{
  'trainer': Icons.person,
  'pokeball': Icons.catching_pokemon,
  'bolt': Icons.bolt,
  'star': Icons.star,
  'fire': Icons.local_fire_department,
  'shield': Icons.shield,
};

const _photoPrefix = 'b64:';

IconData _avatarIcon(String? key) => _avatarPresets[key] ?? Icons.person;

/// Returns an image provider when [key] holds a real photo (camera/gallery
/// `b64:` image or a remote http URL such as a Google account photo). Returns
/// null for avatar preset keys, which are rendered as icons instead.
ImageProvider? _photoProvider(String? key) {
  if (key == null) return null;
  if (key.startsWith('http')) return NetworkImage(key);
  if (key.startsWith(_photoPrefix)) {
    try {
      return MemoryImage(base64Decode(key.substring(_photoPrefix.length)));
    } catch (_) {
      return null;
    }
  }
  return null;
}

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final plan = ref.watch(settingsProvider).plan;
    final showAds = plan.showsAds;

    return Scaffold(
      backgroundColor: context.palette.bg,
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
                      title: 'Eventos próximos',
                      subtitle: 'Torneios e trocas de TCG perto de você.',
                      icon: Icons.map_outlined,
                      onTap: () => context.push('/events'),
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
                  onPressed: () => _confirmLogout(context, ref, visitor: false),
                )
              else ...[
                _PrimaryButton(
                  label: 'Sincronizar com conta Google',
                  icon: Icons.link,
                  onPressed: () => ref.read(authProvider.notifier).signInWithGoogle(),
                ),
                const SizedBox(height: 12),
                _DangerButton(
                  label: 'Sair (modo visitante)',
                  icon: Icons.logout,
                  onPressed: () => _confirmLogout(context, ref, visitor: true),
                ),
              ],
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
      backgroundColor: context.palette.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Foto de perfil', style: AppTextStyles.h3),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _PhotoSourceButton(
                      icon: Icons.photo_camera_outlined,
                      label: 'Câmera',
                      onTap: () => Navigator.pop(ctx, '__camera__'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PhotoSourceButton(
                      icon: Icons.photo_library_outlined,
                      label: 'Galeria',
                      onTap: () => Navigator.pop(ctx, '__gallery__'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text('Ou escolha um avatar', style: AppTextStyles.labelBold),
              const SizedBox(height: 12),
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
                            : context.palette.surface2,
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
    if (chosen == null || !context.mounted) return;
    if (chosen == '__camera__') {
      await _pickPhoto(context, ref, ImageSource.camera);
    } else if (chosen == '__gallery__') {
      await _pickPhoto(context, ref, ImageSource.gallery);
    } else {
      ref.read(authProvider.notifier).updatePhoto(chosen);
    }
  }

  Future<void> _pickPhoto(BuildContext context, WidgetRef ref, ImageSource source) async {
    try {
      final file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 80,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      await ref.read(authProvider.notifier).updatePhoto('$_photoPrefix${base64Encode(bytes)}');
    } catch (e) {
      if (context.mounted) {
        showPixelSnack(
          context,
          source == ImageSource.camera
              ? 'Não foi possível acessar a câmera.'
              : 'Não foi possível acessar a galeria.',
          accent: AppColors.red,
        );
      }
      debugPrint('image_picker error: $e');
    }
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref,
      {required bool visitor}) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.palette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: context.palette.borderStrong, width: 2),
        ),
        title: Text(visitor ? 'Sair do modo visitante' : 'Sair da conta',
            style: AppTextStyles.h3),
        content: Text(
            visitor
                ? 'Você está no modo visitante e seus dados não estão vinculados a nenhuma conta. '
                    'Ao sair, TODOS os seus dados (decks, perfil e preferências) serão perdidos permanentemente. '
                    'Para não perdê-los, sincronize com uma conta Google antes.'
                : 'Deseja realmente sair? Você voltará à tela de login.',
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
                Builder(builder: (context) {
                  final photo = _photoProvider(auth.photoPath);
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: context.palette.borderStrong, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: context.palette.shadow,
                          offset: const Offset(3, 3),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 38,
                      backgroundColor: AppColors.blue.withValues(alpha: 0.14),
                      backgroundImage: photo,
                      child: photo == null
                          ? Icon(_avatarIcon(auth.photoPath),
                              size: 42, color: AppColors.blue)
                          : null,
                    ),
                  );
                }),
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
                  style: TextStyle(color: context.palette.textPrimary),
                  textCapitalization: TextCapitalization.words,
                  onSubmitted: (_) => _save(),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline, color: AppColors.blue),
                    hintText: 'Digite seu nome',
                    hintStyle: const TextStyle(color: AppColors.textDim),
                    filled: true,
                    fillColor: context.palette.surface2,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: context.palette.border),
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
              subtitle: 'Interface com fundo claro.',
              icon: Icons.light_mode_outlined,
              selected: themeMode == ThemeMode.light,
              onTap: () => ref.read(settingsProvider.notifier).setTheme(ThemeMode.light),
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
                  onTap: () => showPixelSnack(
                      context, 'Você já possui a versão mais recente.',
                      accent: AppColors.green),
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
      backgroundColor: context.palette.bg,
      appBar: AppBar(
        backgroundColor: context.palette.bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.palette.textPrimary),
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
    return PixelBox(
      width: double.infinity,
      padding: padding,
      radius: 14,
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
  Widget build(BuildContext context) => Divider(height: 1, color: context.palette.border);
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  const _PrimaryButton({required this.label, required this.icon, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return PixelButton(
      onTap: onPressed,
      color: AppColors.blue,
      width: double.infinity,
      height: 50,
      sound: Sfx.confirm,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(label,
              style: AppTextStyles.buttonText.copyWith(color: Colors.white)),
        ],
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
    return PixelButton(
      onTap: onPressed,
      color: context.palette.surface,
      borderColor: AppColors.red,
      width: double.infinity,
      height: 50,
      sound: Sfx.back,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.red, size: 20),
          const SizedBox(width: 8),
          Text(label,
              style: AppTextStyles.buttonText.copyWith(color: AppColors.red)),
        ],
      ),
    );
  }
}

class _PhotoSourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _PhotoSourceButton({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: context.palette.surface2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.palette.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.blue, size: 26),
            const SizedBox(height: 6),
            Text(label, style: AppTextStyles.label),
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

void _snack(BuildContext context, String message, Color color) =>
    showPixelSnack(context, message, accent: color);
