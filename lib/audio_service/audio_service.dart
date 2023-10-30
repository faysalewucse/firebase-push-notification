import 'package:audioplayers/audioplayers.dart';

class AudioService{
  final player = AudioPlayer();

  void playSound() async {
    await player.play(AssetSource('notify.wav'));
    player.onPlayerComplete.listen((event) {
      player.play(AssetSource('notify.wav'));
    });
  }

  void stopSound() async {
    print("Rendered");
    await player.stop();
  }
}