import 'package:audioplayers/src/audioplayer.dart';
import 'package:flutter/material.dart';

class StopAudio extends StatefulWidget {
  final AudioPlayer audioPlayer;

  const StopAudio({super.key, required this.audioPlayer});

  @override
  State<StopAudio> createState() => _StopAudioState();
}

class _StopAudioState extends State<StopAudio> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      print("rendered");

      await widget.audioPlayer.stop();
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stop"),
      ),
    );
  }
}
