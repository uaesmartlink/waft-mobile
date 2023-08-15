import 'dart:async';
import 'dart:math' as math;

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sport/app/core/constants/globals.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/utils/logger.dart';

part 'channels.dart';
part 'notifications.dart';

AwesomeNotifications awesomeNotifications = AwesomeNotifications();

class NotificationService {
  NotificationService._internal();
  static NotificationService instance = NotificationService._internal();
  Future<String> getFcmToken() async {
    try {
      return await FirebaseMessaging.instance.getToken() ?? "unknown";
    } catch (_) {
      return "unknown";
    }
  }

  Future<void> deleteToken() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (_) {}
  }

  Future<bool> isSupported() async {
    return await FirebaseMessaging.instance.isSupported();
  }

  Future<void> requestPermission() async {
    await FirebaseMessaging.instance.requestPermission();
    final bool result = await awesomeNotifications
        .requestPermissionToSendNotifications(permissions: [
      NotificationPermission.FullScreenIntent,
      NotificationPermission.CriticalAlert,
      NotificationPermission.Alert,
      NotificationPermission.Sound,
      NotificationPermission.Badge,
      NotificationPermission.Vibration,
      NotificationPermission.Light,
    ]);
    logger(result.toString(), name: "requestPermissionToSendNotifications");
  }

  Future<void> initializeNotifications() async {
    try {
      await Firebase.initializeApp();

      await initializeAwesomeNotifications();
      await _onMessage();
    } catch (e) {
      logger(e.toString());
    }
  }

  Future<void> initializeAwesomeNotifications() async {
    logger("initializeAwesomeNotifications");
    await awesomeNotifications.initialize(
      null, //  'resource://drawable/ic_launcher',
      channels,
      channelGroups: groups,
      debug: appMode != AppMode.release,
    );
  }

  Future<void> cancelNotifcation(int id) async {
    await awesomeNotifications.cancel(id);
  }

  Future<void> _onMessage() async {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        try {
          _createNotification(
            title: message.notification!.title.toString(),
            body: message.notification!.body.toString(),
          );
        } catch (e) {
          logger(e.toString());
        }
      },
    );
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  try {
    await initializeAwesomeNotificationsForBackground();
    _createNotification(
      title: message.notification!.title.toString(),
      body: message.notification!.body.toString(),
    );
  } catch (e) {
    logger(e.toString());
  }
}

@pragma('vm:entry-point')
Future<void> initializeAwesomeNotificationsForBackground() async {
  logger("initializeAwesomeNotifications");
  await awesomeNotifications.initialize(
    null, //  'resource://drawable/ic_launcher',
    channels,
    channelGroups: groups,
    debug: appMode != AppMode.release,
  );
}
