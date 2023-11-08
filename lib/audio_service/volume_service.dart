import 'package:firebase_push_notification/main.dart';
import 'package:volume_controller/volume_controller.dart';

class VolumeService {
  void initVolumeController() {
    double _volume = -1;

    VolumeController().listener((volume) {
      try {
        if (_volume > -1 && _volume != volume) {
          _volume = double.parse(volume.toString());
          audioService.stopSound();
        } else {
          _volume = volume;
        }
      } catch (error) {
        print("Volume parse error");
      }
    });

    setVolume(0.9);

  }

  void setVolume(double volume){
    VolumeController().setVolume(volume, showSystemUI: false);
  }
}
