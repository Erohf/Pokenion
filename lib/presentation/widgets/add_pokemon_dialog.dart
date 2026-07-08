import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/audio/sfx.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/models/card.dart';

/// Confirmation dialog with an editable LIFE selector (proto "AddPokemon").
/// Returns the chosen HP, or null if cancelled.
Future<int?> showAddPokemonDialog(BuildContext context, PokemonCard card) {
  return showDialog<int>(
    context: context,
    builder: (_) => _AddPokemonDialog(card: card),
  );
}

class _AddPokemonDialog extends StatefulWidget {
  final PokemonCard card;
  const _AddPokemonDialog({required this.card});
  @override
  State<_AddPokemonDialog> createState() => _AddPokemonDialogState();
}

class _AddPokemonDialogState extends State<_AddPokemonDialog> {
  late int _hp = widget.card.baseHp ?? widget.card.hp ?? 60;
  bool _editing = false;
  late final TextEditingController _controller =
      TextEditingController(text: '$_hp');

  void _setHp(int v) => setState(() => _hp = v.clamp(0, 9999));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.palette.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Deseja adicionar essa carta?',
                style: AppTextStyles.h3, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Text('LIFE', style: AppTextStyles.lifeLabel),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _RoundBtn(icon: Icons.remove, onTap: () => _setHp(_hp - 10)),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => setState(() => _editing = true),
                  child: Container(
                    width: 110,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: context.palette.surface2,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: _editing
                        ? TextField(
                            controller: _controller,
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            textAlign: TextAlign.center,
                            style: AppTextStyles.hpValue.copyWith(color: context.palette.textPrimary),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onSubmitted: (v) => setState(() {
                              _hp = (int.tryParse(v) ?? _hp).clamp(0, 9999);
                              _editing = false;
                            }),
                          )
                        : Text('$_hp',
                            style: AppTextStyles.hpValue.copyWith(color: context.palette.textPrimary)),
                  ),
                ),
                const SizedBox(width: 12),
                _RoundBtn(icon: Icons.add, onTap: () => _setHp(_hp + 10)),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.palette.surface2,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(12),
              child: widget.card.imageUrl == null
                  ? const Icon(Icons.catching_pokemon, size: 80, color: AppColors.blue)
                  : CachedNetworkImage(
                      imageUrl: widget.card.imageUrl!,
                      fit: BoxFit.contain,
                      errorWidget: (_, __, ___) => const Icon(
                          Icons.catching_pokemon, size: 80, color: AppColors.blue),
                    ),
            ),
            const SizedBox(height: 8),
            Text(widget.card.name, style: AppTextStyles.label),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      sfx(Sfx.back);
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.palette.textPrimary,
                      side: BorderSide(color: context.palette.border),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      sfx(Sfx.confirm);
                      final v = _editing ? int.tryParse(_controller.text) ?? _hp : _hp;
                      Navigator.pop(context, v.clamp(0, 9999));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('Confirmar',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(color: context.palette.surface2, shape: BoxShape.circle),
        child: Icon(icon, color: AppColors.blue, size: 22),
      ),
    );
  }
}
