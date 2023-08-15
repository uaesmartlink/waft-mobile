part of 'firebase_cloud_messaging.dart';

Future<void> _createNotification({
  required String title,
  required String body,
  int? id,
  bool? locked,
}) async {
  final math.Random random = math.Random();
  final int randomNumber = random.nextInt(100);
  await awesomeNotifications.createNotification(
      content: NotificationContent(
    id: id ?? randomNumber,
    channelKey: 'actions_channel',
    title: title,
    locked: locked ?? false,
    body: body,
    criticalAlert: true,
    displayOnBackground: true,
    displayOnForeground: true,
    wakeUpScreen: true,
    notificationLayout: NotificationLayout.BigText,
  ));
}
