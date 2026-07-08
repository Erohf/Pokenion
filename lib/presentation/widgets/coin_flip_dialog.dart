import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_text_styles.dart';

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
            style: AppTextStyles.h2,
            decoration: InputDecoration(
              filled: true,
              fillColor: context.palette.surface2,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _start,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
            child: const Text('Lançar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
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
              child: OutlinedButton(
                onPressed: () => setState(() => _phase = _Phase.setup),
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.palette.textPrimary,
                  side: BorderSide(color: context.palette.border),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('De novo'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Fechar', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _coin(bool heads) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: heads ? AppColors.blue : context.palette.surfaceVariant,
        border: Border.all(color: AppColors.blueLight, width: 3),
      ),
      alignment: Alignment.center,
      child: Text(
        heads ? 'C' : 'K',
        style: AppTextStyles.h1.copyWith(
            color: heads ? Colors.white : AppColors.textDark),
      ),
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
          child: Text('$value', style: AppTextStyles.h1.copyWith(color: color)),
        ),
        const SizedBox(height: 6),
        Text(label, style: AppTextStyles.label),
      ],
    );
  }
}
