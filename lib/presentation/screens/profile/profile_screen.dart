import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/app_card.dart';
import '../../widgets/battle_menu.dart';

final profileNameProvider = StateProvider<String>((ref) => 'Lucas Andrade');

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(profileNameProvider);
    final colors = _ProfileColors.fromContext(context);

    return Scaffold(
      backgroundColor: colors.background,
      bottomNavigationBar: const SizedBox(
        height: 136,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(bottom: 16, top: 8),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: BattleMenu(),
            ),
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            children: [
              _AdBanner(colors: colors),
              const SizedBox(height: 16),
              _ProfileHeader(userName: userName, colors: colors),
              const SizedBox(height: 24),
              AppCard(
                padding: EdgeInsets.zero,
                color: colors.card,
                borderColor: colors.border,
                child: Column(
                  children: [
                    _ProfileMenuItem(
                      title: 'Alterar nome',
                      subtitle: 'Atualize o nome exibido na sua conta.',
                      icon: Icons.badge_outlined,
                      onTap: () => context.push('/profile/name'),
                    ),
                    _Divider(colors: colors),
                    _ProfileMenuItem(
                      title: 'Alterar senha',
                      subtitle: 'Defina uma nova senha de acesso.',
                      icon: Icons.lock_outline,
                      onTap: () => context.push('/profile/password'),
                    ),
                    _Divider(colors: colors),
                    _ProfileMenuItem(
                      title: 'Planos',
                      subtitle: 'Gerencie benefícios e recursos do app.',
                      icon: Icons.star_outline,
                      onTap: () => context.push('/plans'),
                    ),
                    _Divider(colors: colors),
                    _ProfileMenuItem(
                      title: 'Temas',
                      subtitle: 'Altere a aparência do app.',
                      icon: Icons.palette_outlined,
                      onTap: () => context.push('/profile/themes'),
                    ),
                    _Divider(colors: colors),
                    _ProfileMenuItem(
                      title: 'Sobre',
                      subtitle: 'Versão e informações do Pokenion.',
                      icon: Icons.info_outline,
                      onTap: () => context.push('/profile/about'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeNameScreen extends ConsumerStatefulWidget {
  const ChangeNameScreen({super.key});

  @override
  ConsumerState<ChangeNameScreen> createState() => _ChangeNameScreenState();
}

class _ChangeNameScreenState extends ConsumerState<ChangeNameScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(profileNameProvider));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = _ProfileColors.fromContext(context);

    return _ProfileSubScreenScaffold(
      title: 'Alterar nome',
      colors: colors,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionCard(
            colors: colors,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Nome da conta',
                    style:
                        AppTextStyles.labelBold.copyWith(color: colors.text)),
                const SizedBox(height: 12),
                _ProfileTextField(
                  controller: _controller,
                  colors: colors,
                  hintText: 'Digite seu nome',
                  icon: Icons.person_outline,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _save(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _PrimaryButton(
            label: 'Salvar nome',
            icon: Icons.check,
            onPressed: () => _save(context),
          ),
        ],
      ),
    );
  }

  void _save(BuildContext context) {
    final nextName = _controller.text.trim();
    if (nextName.isEmpty) {
      _showSnack(context, 'Informe um nome para continuar.', AppColors.red);
      return;
    }

    ref.read(profileNameProvider.notifier).state = nextName;
    _showSnack(context, 'Nome atualizado com sucesso.', AppColors.green);
    context.pop();
  }
}

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = _ProfileColors.fromContext(context);

    return _ProfileSubScreenScaffold(
      title: 'Alterar senha',
      colors: colors,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionCard(
            colors: colors,
            child: Column(
              children: [
                _ProfileTextField(
                  controller: _currentPasswordController,
                  colors: colors,
                  hintText: 'Senha atual',
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                _ProfileTextField(
                  controller: _newPasswordController,
                  colors: colors,
                  hintText: 'Nova senha',
                  icon: Icons.password_outlined,
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                _ProfileTextField(
                  controller: _confirmPasswordController,
                  colors: colors,
                  hintText: 'Confirmar nova senha',
                  icon: Icons.verified_user_outlined,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _save(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _PrimaryButton(
            label: 'Salvar senha',
            icon: Icons.check,
            onPressed: () => _save(context),
          ),
        ],
      ),
    );
  }

  void _save(BuildContext context) {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      _showSnack(context, 'Preencha todos os campos.', AppColors.red);
      return;
    }

    if (newPassword.length < 6) {
      _showSnack(context, 'A nova senha deve ter pelo menos 6 caracteres.',
          AppColors.red);
      return;
    }

    if (newPassword != confirmPassword) {
      _showSnack(context, 'A confirmação não confere com a nova senha.',
          AppColors.red);
      return;
    }

    _showSnack(context, 'Senha atualizada com sucesso.', AppColors.green);
    context.pop();
  }
}

class ThemesScreen extends ConsumerWidget {
  const ThemesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final colors = _ProfileColors.fromContext(context);

    return _ProfileSubScreenScaffold(
      title: 'Temas',
      colors: colors,
      child: _SectionCard(
        colors: colors,
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            _ThemeMenuItem(
              title: 'Tema escuro',
              subtitle: 'Interface com fundo escuro.',
              icon: Icons.dark_mode_outlined,
              selected: themeMode == ThemeMode.dark,
              onTap: () => ref
                  .read(themeNotifierProvider.notifier)
                  .setTheme(ThemeMode.dark),
            ),
            _Divider(colors: colors),
            _ThemeMenuItem(
              title: 'Tema claro',
              subtitle: 'Interface com fundo claro.',
              icon: Icons.light_mode_outlined,
              selected: themeMode == ThemeMode.light,
              onTap: () => ref
                  .read(themeNotifierProvider.notifier)
                  .setTheme(ThemeMode.light),
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
    final colors = _ProfileColors.fromContext(context);

    return _ProfileSubScreenScaffold(
      title: 'Sobre',
      colors: colors,
      child: Column(
        children: [
          _SectionCard(
            colors: colors,
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.blue.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.catching_pokemon,
                      color: AppColors.blue, size: 40),
                ),
                const SizedBox(height: 16),
                Text('Pokenion',
                    style: AppTextStyles.h2.copyWith(color: colors.text)),
                const SizedBox(height: 4),
                Text(
                  'Organize decks, acompanhe batalhas e personalize sua experiência.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(color: colors.subtext),
                ),
                const SizedBox(height: 20),
                _InfoRow(label: 'Versão', value: '1.0.0', colors: colors),
                const SizedBox(height: 8),
                _InfoRow(label: 'Build', value: '2026.06.07', colors: colors),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _PrimaryButton(
            label: 'Procurar atualizações',
            icon: Icons.update,
            onPressed: () => _showSnack(
              context,
              'Você já possui a versão mais recente.',
              AppColors.green,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSubScreenScaffold extends StatelessWidget {
  final String title;
  final _ProfileColors colors;
  final Widget child;

  const _ProfileSubScreenScaffold({
    required this.title,
    required this.colors,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.text),
          onPressed: () => context.pop(),
        ),
        title:
            Text(title, style: AppTextStyles.h2.copyWith(color: colors.text)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: child,
        ),
      ),
    );
  }
}

class _AdBanner extends StatelessWidget {
  final _ProfileColors colors;

  const _AdBanner({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.adBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text('AD', style: AppTextStyles.h1.copyWith(color: colors.adText)),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String userName;
  final _ProfileColors colors;

  const _ProfileHeader({
    required this.userName,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: colors.card,
      borderColor: colors.border,
      child: Row(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: AppColors.blue.withValues(alpha: 0.14),
            child: const Icon(Icons.person, size: 48, color: AppColors.blue),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bem-vindo!',
                    style:
                        AppTextStyles.bodyBold.copyWith(color: colors.subtext)),
                const SizedBox(height: 2),
                Text(userName,
                    style: AppTextStyles.h3.copyWith(color: colors.text)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.verified,
                        color: AppColors.green, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Conta vinculada',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Plano Freemium',
                  style: AppTextStyles.caption.copyWith(color: colors.subtext),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _ProfileColors.fromContext(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Icon(icon, color: AppColors.blue, size: 22),
      title: Text(title,
          style: AppTextStyles.labelBold.copyWith(color: colors.text)),
      subtitle: Text(subtitle,
          style: AppTextStyles.bodySmall.copyWith(color: colors.subtext)),
      trailing: Icon(Icons.chevron_right, color: colors.subtext),
      onTap: onTap,
    );
  }
}

class _ThemeMenuItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeMenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _ProfileColors.fromContext(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Icon(icon, color: AppColors.blue, size: 22),
      title: Text(title,
          style: AppTextStyles.labelBold.copyWith(color: colors.text)),
      subtitle: Text(subtitle,
          style: AppTextStyles.bodySmall.copyWith(color: colors.subtext)),
      trailing: selected
          ? const Icon(Icons.check_circle, color: AppColors.green)
          : Icon(Icons.radio_button_unchecked, color: colors.subtext),
      onTap: onTap,
    );
  }
}

class _ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final _ProfileColors colors;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  const _ProfileTextField({
    required this.controller,
    required this.colors,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      style: TextStyle(color: colors.text),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.blue),
        hintText: hintText,
        hintStyle: TextStyle(color: colors.subtext),
        filled: true,
        fillColor: colors.input,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final _ProfileColors colors;
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _SectionCard({
    required this.colors,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: colors.card,
      borderColor: colors.border,
      padding: padding,
      child: child,
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: AppTextStyles.buttonText),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final _ProfileColors colors;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$label: ',
            style: AppTextStyles.caption.copyWith(color: colors.subtext)),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            color: colors.text,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  final _ProfileColors colors;

  const _Divider({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, color: colors.border);
  }
}

class _ProfileColors {
  final Color background;
  final Color card;
  final Color input;
  final Color border;
  final Color text;
  final Color subtext;
  final Color adBackground;
  final Color adText;

  const _ProfileColors({
    required this.background,
    required this.card,
    required this.input,
    required this.border,
    required this.text,
    required this.subtext,
    required this.adBackground,
    required this.adText,
  });

  factory _ProfileColors.fromContext(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return const _ProfileColors(
        background: AppColors.bg,
        card: AppColors.surface,
        input: AppColors.surface2,
        border: AppColors.border,
        text: AppColors.textPrimary,
        subtext: AppColors.textSecondary,
        adBackground: AppColors.surfaceVariant,
        adText: AppColors.textDark,
      );
    }

    return const _ProfileColors(
      background: Color(0xFFF5F5F5),
      card: Colors.white,
      input: Color(0xFFF7F7F9),
      border: AppColors.borderVariant,
      text: AppColors.textDark,
      subtext: Color(0xFF6B6F76),
      adBackground: Color(0xFFE4E5E7),
      adText: Color(0xFF6B6F76),
    );
  }
}

void _showSnack(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
