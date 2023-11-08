import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_push_notification/audio_service/audio_service.dart';
import 'package:firebase_push_notification/audio_service/volume_service.dart';
import 'package:firebase_push_notification/main.dart';
import 'package:firebase_push_notification/notification_service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:volume_controller/volume_controller.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('---->> ${message.notification!.title.toString()}');

  audioService.playSound();

  VolumeService().initVolumeController();

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

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fcMToken = await _firebaseMessaging.getToken();
    print('Token: $fcMToken');
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    initPushNotification();
  }

  Future<void> initPushNotification() async {
    // FirebaseMessaging.instance.getInitialMessage().then(
    //   (message) {
    //     // NotificationController().showNotification(message);
    //   },
    // );

    // 2. This method only call when App in foreground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          NotificationController().showNotification(message);
          // LocalNotificationService.display(message);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    // FirebaseMessaging.onMessageOpenedApp.listen(
    //   (message) {
    //     print("FirebaseMessaging.onMessageOpenedApp.listen");
    //     NotificationController().showNotification(message);
    //   },
    // );
  }
}
