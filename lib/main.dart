import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_push_notification/audio_service/audio_service.dart';
import 'package:firebase_push_notification/firebase_api.dart';
import 'package:firebase_push_notification/notification_service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:volume_controller/volume_controller.dart';

double mobileCurrentVol = 0.0;
AudioService audioService = AudioService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  mobileCurrentVol = await VolumeController().getVolume();
  mobileCurrentVol = double.parse(mobileCurrentVol.toStringAsFixed(2));
  await Firebase.initializeApp();
  FirebaseApi().initNotification();
  NotificationController().initializeAwesomeNotification();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState

    AudioService().stopSound();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Push Notification"),
      ),
      body: Center(
        child: Icon(
          Icons.notifications_active,
          size: 50,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }
}