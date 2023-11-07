import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:http/http.dart' as http;

final audioPlayer = AudioPlayer();
bool sound = false;
double mobileCurrentVol = 0.0;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('---->> ${message.notification!.title.toString()}');

  await audioPlayer.play(AssetSource('preview.mp3'));

  // VolumeController().setVolume(0.50);

  double _volume = -1;
  sound = false;

  VolumeController().listener((volume) {
    print("Current Volume :$volume");
    try {
      if (_volume > -1 && _volume != volume) {
        _volume = double.parse(volume.toString());
        audioPlayer.stop();
      } else {
        _volume = volume;
      }
    } catch (error) {
      print("Volume parse error");
    }
  });

  VolumeController().setVolume(0.9);
  print('================>>>  ${VolumeController().getVolume()}  <<<====================');

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 101,
      channelKey: "call_channel",
      color: Colors.white,
      title: message.notification!.title,
      body: message.notification!.body,
      wakeUpScreen: true,
      category: NotificationCategory.Message,
      fullScreenIntent: true,
      autoDismissible: true,
      backgroundColor: Colors.orange,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'ACCEPT',
        label: "Accept Call",
        color: Colors.green,
        autoDismissible: true,
      ),
      NotificationActionButton(
          key: 'REJECT',
          label: "Reject Call",
          color: Colors.redAccent,
          autoDismissible: true,
          actionType: ActionType.SilentBackgroundAction),
    ],
  );
}

@pragma('vm:entry-point')
Future<void> onActionReceivedMethod(ReceivedAction event) async {
  if (event.buttonKeyPressed == "REJECT") {
    sound = true;
    audioPlayer.stop();
    print("second set for reject");
  } else if (event.buttonKeyPressed == "ACCEPT") {
    // VolumeController().setVolume(0.7);
    // final response = await http.get(Uri.parse('https://reqres.in/api/users/2'));
    //
    // if (response.statusCode == 200) {
    //   debugPrint("==========response: ${response.body}", wrapWidth: 1024);
    //   VolumeController().setVolume(mobileCurrentVol);
    // } else {
    //   // If the server did not return a 200 OK response, throw an exception
    //   throw Exception('Failed to load data');
    // }

    await audioPlayer.stop();
    // Get.to(()=>StopAudio(audioPlayer: audioPlayer));
    print("call accept from home page");
  } else {
    print("print on notification from background");
    await audioPlayer.stop();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  mobileCurrentVol = await VolumeController().getVolume();
  mobileCurrentVol = double.parse(mobileCurrentVol.toStringAsFixed(2));
  print('=======>> mobile current volume: $mobileCurrentVol');
  await Firebase.initializeApp();
  FirebaseMessaging.instance
      .getToken()
      .then((value) => print('------>> device token: ${value.toString()}'));
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
          channelKey: "call_channel",
          channelName: "Call Channel",
          channelDescription: "Channel of calling",
          importance: NotificationImportance.Max,
          defaultColor: Colors.redAccent,
          ledColor: Colors.white,
          channelShowBadge: true,
          locked: true,
          // defaultRingtoneType: DefaultRingtoneType.Notification,
        )
      ],
      debug: true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
    await audioPlayer.play(AssetSource('preview.mp3'));

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 101,
        channelKey: "call_channel",
        color: Colors.white,
        title: message.notification!.title,
        body: message.notification!.body,
        wakeUpScreen: true,
        category: NotificationCategory.Message,
        fullScreenIntent: true,
        autoDismissible: true,
        backgroundColor: Colors.orange,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'ACCEPT',
          label: "Accept Call",
          color: Colors.green,
          autoDismissible: true,
        ),
        NotificationActionButton(
            key: 'REJECT',
            label: "Reject Call",
            color: Colors.redAccent,
            autoDismissible: true,
            actionType: ActionType.SilentBackgroundAction),
      ],
    );
  });
  AwesomeNotifications()
      .setListeners(onActionReceivedMethod: onActionReceivedMethod);
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
    print('================>> called from push notification screen n1');

    audioPlayer.stop();
    print('================>> called from push notification screen');

    super.initState();

    // FirebaseMessaging.instance.getInitialMessage().then(
    //   (message) {
    //     // NotificationController().showNotification(message);
    //   },
    // );
    //
    // // 2. This method only call when App in foreground it mean app must be opened
    // FirebaseMessaging.onMessage.listen(
    //   (message) {
    //     print("FirebaseMessaging.onMessage.listen");
    //     if (message.notification != null) {
    //       NotificationController().showNotification(message);
    //       // LocalNotificationService.display(message);
    //     }
    //   },
    // );
    //
    // // 3. This method only call when App in background and not terminated(not closed)
    // FirebaseMessaging.onMessageOpenedApp.listen(
    //   (message) {
    //     print("FirebaseMessaging.onMessageOpenedApp.listen");
    //     NotificationController().showNotification(message);
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Push Notification"),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SecondPage())),
          child: Icon(
            Icons.notifications_active,
            size: 50,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("2nd Page"),
      ),
      body: const Center(
        child: Icon(Icons.notification_add),
      ),
    );
  }
}
