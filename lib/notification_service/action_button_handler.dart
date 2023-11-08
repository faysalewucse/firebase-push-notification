import 'package:firebase_push_notification/audio_service/volume_service.dart';
import 'package:firebase_push_notification/main.dart';
import 'package:http/http.dart' as http;

class ActionButtonHandler{
  acceptButtonHandler() async{
    VolumeService().setVolume(0.7);
    final response = await http.get(Uri.parse('https://reqres.in/api/users/2'));

    if (response.statusCode == 200) {
      VolumeService().setVolume(mobileCurrentVol);
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load data');
    }

    audioService.stopSound();
  }
}
