import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_push_notification/audio_service/audio_service.dart';
import 'package:flutter/material.dart';

class NotificationController {
  static AudioService audioService = AudioService();

  void initializeAwesomeNotification() {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
    );

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    AwesomeNotifications().setListeners(
        onActionReceivedMethod:         NotificationController.onActionReceivedMethod,
        // onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
        // onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
        // onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
    );
  }

  void showNotification(RemoteMessage message) {
    audioService.playSound();
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 1,
            channelKey: "basic_channel",
            title: message.notification!.title,
            autoDismissible: false,
            actionType: ActionType.Default,
            displayOnForeground: true,
            displayOnBackground: true),
        actionButtons: [
          NotificationActionButton(
              key: 'DISMISS',
              label: 'Dismiss',
              actionType: ActionType.DismissAction)
        ]);
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    print("Dismissed Clicked");
    audioService.stopSound();
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    print("Dismissed Clicked");
    AwesomeNotifications().cancelAll();
    audioService.stopSound();
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {}
}
