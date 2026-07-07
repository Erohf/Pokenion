import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 3),
              // Logo (placeholder wordmark until a real logo exists).
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.blue.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.catching_pokemon,
                    color: AppColors.blue, size: 56),
              ),
              const SizedBox(height: 20),
              Text('Pokénion', style: AppTextStyles.h1.copyWith(fontSize: 34)),
              const SizedBox(height: 8),
              Text(
                'Seu companheiro de batalhas Pokémon TCG',
                textAlign: TextAlign.center,
                style: AppTextStyles.body,
              ),
              const Spacer(flex: 4),
              _GoogleButton(
                onPressed: () => ref.read(authProvider.notifier).signInWithGoogle(),
              ),
              const SizedBox(height: 14),
              TextButton(
                onPressed: () => _startVisitorFlow(context, ref),
                child: Text(
                  'Continuar como visitante',
                  style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startVisitorFlow(BuildContext context, WidgetRef ref) async {
    final dismissed = ref.read(settingsProvider).visitorWarningDismissed;
    if (!dismissed) {
      final proceed = await _showVisitorWarning(context, ref);
      if (proceed != true) return;
    }
    if (!context.mounted) return;
    final name = await _askName(context);
    if (name == null || name.trim().isEmpty) return;
    await ref.read(authProvider.notifier).continueAsVisitor(name.trim());
  }

  Future<bool?> _showVisitorWarning(BuildContext context, WidgetRef ref) {
    bool dontShow = false;
    return showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Continuar sem conta?', style: AppTextStyles.h3),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Seus dados ficarão salvos apenas neste dispositivo. Se você '
                'apagar o app ou entrar em outro aparelho, perderá tudo. Você '
                'poderá vincular uma conta Google depois.',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => setState(() => dontShow = !dontShow),
                child: Row(
                  children: [
                    Checkbox(
                      value: dontShow,
                      onChanged: (v) => setState(() => dontShow = v ?? false),
                      activeColor: AppColors.blue,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Text('Não mostrar novamente',
                        style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Cancelar',
                  style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (dontShow) {
                  await ref.read(settingsProvider.notifier).dismissVisitorWarning();
                }
                if (ctx.mounted) Navigator.pop(ctx, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Continuar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _askName(BuildContext context) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Como podemos te chamar?', style: AppTextStyles.h3),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: AppColors.textPrimary),
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Seu nome',
            hintStyle: const TextStyle(color: AppColors.textDim),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
            ),
          ),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Continuar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _GoogleButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: const Text('G',
              style: TextStyle(
                  color: Color(0xFF4285F4),
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
        ),
        label: Text('Entrar com o Google', style: AppTextStyles.buttonText.copyWith(fontSize: 15)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
