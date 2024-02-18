import 'package:audioplayers/audioplayers.dart';
import 'package:pomodoro/util/constants.dart'; 

class AudioController {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playAudio(String sound) async {
    await _player.play(AssetSource(sound));
  }

  Future<void> playGongo() async {
    await playAudio(gongoSound);
  }

  Future<void> playPanicGongo() async {
    await playAudio(panicGongoSound);
  }

  Future<void> playMovMenu() async {
    await playAudio(movMenu);
  }

  Future<void> playStop() async {
    await playAudio(stopSound);
  }

  Future<void> playStart() async {
    await playAudio(startSound);
  }

  Future<void> playPause() async {
    await playAudio(pauseSound);
  }
}
