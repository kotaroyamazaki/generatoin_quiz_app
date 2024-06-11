// audio_manager.dart
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generation_quiz_app/provider/sound_notifier.dart';

final audioManagerProvider = Provider<AudioManager>((ref) {
  return AudioManager(ref);
});

class AudioManager {
  final Ref ref;
  final AudioPlayer _player;

  AudioManager(this.ref) : _player = AudioPlayer();

  Future<void> play(Source source) async {
    final isSoundOn = ref.read(soundProvider);
    if (isSoundOn) {
      await _player.play(source);
    }
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
