import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/audio/sfx.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_text_styles.dart';
import 'pixel.dart';

Future<void> showCoinFlipDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => const _CoinFlipDialog(),
  );
}

enum _Phase { setup, flipping, result }

class _CoinFlipDialog extends StatefulWidget {
  const _CoinFlipDialog();
  @override
  State<_CoinFlipDialog> createState() => _CoinFlipDialogState();
}

class _CoinFlipDialogState extends State<_CoinFlipDialog>
    with SingleTickerProviderStateMixin {
  final _rng = Random();
  final _controller = TextEditingController(text: '1');
  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..addStatusListener((s) {
      if (s == AnimationStatus.completed && mounted) {
        setState(() => _phase = _Phase.result);
      }
    });

  _Phase _phase = _Phase.setup;
  int _count = 1;
  int _heads = 0;
  int _tails = 0;

  @override
  void dispose() {
    _controller.dispose();
    _anim.dispose();
    super.dispose();
  }

  void _start() {
    sfx(Sfx.coin);
    final n = (int.tryParse(_controller.text) ?? 1).clamp(1, 100);
    _heads = 0;
    _tails = 0;
    for (var i = 0; i < n; i++) {
      if (_rng.nextBool()) {
        _heads++;
      } else {
        _tails++;
      }
    }
    setState(() {
      _count = n;
      _phase = _Phase.flipping;
    });
    _anim.forward(from: 0);
  }

  void _skip() {
    _anim.stop();
    setState(() => _phase = _Phase.result);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: context.palette.borderStrong, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Coin Flip', style: AppTextStyles.h3),
            const SizedBox(height: 20),
            switch (_phase) {
              _Phase.setup => _buildSetup(),
              _Phase.flipping => _buildFlipping(),
              _Phase.result => _buildResult(),
            },
          ],
        ),
      ),
    );
  }

  Widget _buildSetup() {
    return Column(
      children: [
        Text('Quantas moedas? (máx. 100)', style: AppTextStyles.body),
        const SizedBox(height: 12),
        SizedBox(
          width: 120,
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            style: GoogleFonts.silkscreen(
                fontSize: 20, color: context.palette.textPrimary),
            decoration: InputDecoration(
              filled: true,
              fillColor: context.palette.surface2,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: context.palette.borderStrong, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.blue, width: 2),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        PixelButton(
          onTap: _start,
          color: AppColors.blue,
          width: double.infinity,
          height: 48,
          sound: null, // _start plays the coin sound
          child: Text('Lançar',
              style: AppTextStyles.buttonText.copyWith(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildFlipping() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _anim,
          builder: (context, _) {
            final angle = _anim.value * pi * 12; // several spins
            final showHeads = (angle ~/ pi) % 2 == 0;
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(angle),
              child: _coin(showHeads),
            );
          },
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: _skip,
          child: Text('Pular',
              style: AppTextStyles.label.copyWith(color: AppColors.blue)),
        ),
      ],
    );
  }

  Widget _buildResult() {
    return Column(
      children: [
        Text('$_count moeda${_count == 1 ? '' : 's'}', style: AppTextStyles.body),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _tally('Cara', _heads, AppColors.blue),
            _tally('Coroa', _tails, AppColors.textSecondary),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: PixelButton(
                onTap: () => setState(() => _phase = _Phase.setup),
                color: context.palette.surface2,
                height: 46,
                child: Text('De novo',
                    style: AppTextStyles.buttonText
                        .copyWith(color: context.palette.textPrimary)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: PixelButton(
                onTap: () => Navigator.pop(context),
                color: AppColors.blue,
                height: 46,
                sound: Sfx.back,
                child: Text('Fechar',
                    style:
                        AppTextStyles.buttonText.copyWith(color: Colors.white)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _coin(bool heads) {
    // Heads = pokéball (app palette); tails = flat silver back with "K".
    final child = heads
        ? const PixelPokeball(size: 90)
        : Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFB9BDC7),
              border: Border.all(color: const Color(0xFF6E7280), width: 4),
            ),
            alignment: Alignment.center,
            child: Text(
              'K',
              style: GoogleFonts.silkscreen(
                  fontSize: 30, color: const Color(0xFF4A4E5A), height: 1),
            ),
          );
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: context.palette.shadow,
            offset: const Offset(0, 5),
            blurRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _tally(String label, int value, Color color) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.15),
            border: Border.all(color: color, width: 2),
          ),
          child: Text('$value',
              style: GoogleFonts.silkscreen(
                  fontSize: 24, color: color, height: 1)),
        ),
        const SizedBox(height: 6),
        Text(label, style: AppTextStyles.label),
      ],
    );
  }
}
