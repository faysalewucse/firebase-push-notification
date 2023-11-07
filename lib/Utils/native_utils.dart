import 'package:flutter/services.dart';

var audioChannel = const MethodChannel("rootX/playAudio");

startAudio() {
  audioChannel.invokeMethod('playAudio');
}
stopAudio() {
  audioChannel.invokeMethod('stopAudio');
}