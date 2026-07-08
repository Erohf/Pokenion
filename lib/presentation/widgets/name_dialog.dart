import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/audio/sfx.dart';
import 'pixel.dart';

/// Shows a single text-field dialog and returns the trimmed non-empty value,
/// or null if cancelled/empty.
Future<String?> showNameDialog(
  BuildContext context, {
  required String title,
  String hint = '',
  String confirm = 'Salvar',
  String? initial,
}) async {
  final controller = TextEditingController(text: initial ?? '');
  final result = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: ctx.palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: ctx.palette.borderStrong, width: 2),
      ),
      title: Text(title, style: AppTextStyles.h3),
      content: TextField(
        controller: controller,
        autofocus: true,
        style: TextStyle(color: ctx.palette.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textDim),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: ctx.palette.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
          ),
        ),
        onSubmitted: (v) => Navigator.pop(ctx, v),
      ),
      actions: [
        TextButton(
          onPressed: () {
            sfx(Sfx.back);
            Navigator.pop(ctx);
          },
          child: Text('Cancelar',
              style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
        ),
        PixelButton(
          onTap: () => Navigator.pop(ctx, controller.text),
          color: AppColors.blue,
          sound: Sfx.confirm,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Text(confirm,
              style: AppTextStyles.buttonText.copyWith(color: Colors.white)),
        ),
      ],
    ),
  );
  final trimmed = result?.trim();
  return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
}
