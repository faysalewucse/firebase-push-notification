import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_push_notification/main.dart';
import 'package:firebase_push_notification/notification_service/action_button_handler.dart';
import 'package:flutter/material.dart';


class NotificationController {

  void initializeAwesomeNotification() {
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

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      // onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
      // onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
      // onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
    );
  }

  void showNotification(RemoteMessage message) {
    audioService.playSound();

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
  static Future<void> onActionReceivedMethod(ReceivedAction event) async {
    if (event.buttonKeyPressed == "REJECT") {
      audioService.stopSound();
      print("second set for reject");
    } else if (event.buttonKeyPressed == "ACCEPT") {
      ActionButtonHandler().acceptButtonHandler();
    } else {
      audioService.stopSound();
    }
  }
}
