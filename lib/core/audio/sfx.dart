import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// The app's UI sound effects (synthesized chiptune, bundled in assets/audio).
enum Sfx {
  tap('tap.wav'),
  confirm('confirm.wav'),
  back('back.wav'),
  coin('coin.wav'),
  evolve('evolve.wav'),
  battleStart('battle_start.wav');

  const Sfx(this.file);
  final String file;
}

/// Fire-and-forget sound playback with a small player pool so quick taps
/// don't cut each other off. Failures are swallowed — sound is a garnish,
/// never something that should break an interaction.
class SfxPlayer {
  SfxPlayer._();
  static final SfxPlayer instance = SfxPlayer._();

  static const _poolSize = 4;
  final List<AudioPlayer> _pool = [
    for (var i = 0; i < _poolSize; i++)
      AudioPlayer()..setReleaseMode(ReleaseMode.stop),
  ];
  int _next = 0;

  bool muted = false;

  Future<void> play(Sfx sfx) async {
    if (muted) return;
    final player = _pool[_next];
    _next = (_next + 1) % _poolSize;
    try {
      await player.stop();
      await player.play(AssetSource('audio/${sfx.file}'), volume: 0.65);
    } catch (e) {
      debugPrint('sfx error: $e');
    }
  }
}

/// Shorthand: `sfx(Sfx.tap)`.
void sfx(Sfx s) => SfxPlayer.instance.play(s);
