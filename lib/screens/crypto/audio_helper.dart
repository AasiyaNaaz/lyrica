import 'package:audioplayers/audioplayers.dart';

class AudioHelper {
  static AudioPlayer? _currentPlayer;

  static Future<void> playNote(int midiNote) async {
    await stop();

    final player = AudioPlayer();
    _currentPlayer = player;
    try {
      await player.play(AssetSource('notes/$midiNote.wav'));
      await player.onPlayerComplete.first;
    } finally {
      await player.dispose();
      if (_currentPlayer == player) {
        _currentPlayer = null;
      }
    }
    try {
  print('Playing note 60');
  await player.play(AssetSource('notes/60.wav'));
  await player.onPlayerComplete.first;
} catch (e) {
  print('Error playing note 60: $e');
} finally {
  await player.dispose();
  if (_currentPlayer == player) _currentPlayer = null;
  print('Disposed player for note 60');
}

  }

static Future<void> playMelody(List<int> melody, {void Function(int)? onNotePlayed}) async {
  for (var i = 0; i < melody.length; i++) {
    if (_currentPlayer == null) break;
    await playNote(melody[i]);
    if (onNotePlayed != null) onNotePlayed(i); // synchronous call (no await)
  }
}



  static Future<void> stop() async {
    if (_currentPlayer != null) {
      await _currentPlayer!.stop();
      await _currentPlayer!.dispose();
      _currentPlayer = null;
    }
  }
}
