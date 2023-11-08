import 'package:audioplayers/audioplayers.dart';

class AudioService{
  final player = AudioPlayer();

  void playSound() async {
    await player.play(AssetSource('preview.mp3'));
  }

  void stopSound() async {
    await player.stop();
  }
}