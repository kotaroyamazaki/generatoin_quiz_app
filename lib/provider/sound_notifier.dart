// sound_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final soundProvider = StateNotifierProvider<SoundNotifier, bool>((ref) {
  return SoundNotifier();
});

class SoundNotifier extends StateNotifier<bool> {
  SoundNotifier() : super(true);

  void toggleSound() {
    state = !state;
  }

  void enableSound() {
    state = true;
  }

  void disableSound() {
    state = false;
  }
}
