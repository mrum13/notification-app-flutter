import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_app/utils/received_notification.dart';
import 'package:rxdart/subjects.dart';

final selectNotificationSubject = BehaviorSubject<String?>();
final didReceiveLocalNotificationSubject =
   BehaviorSubject<ReceivedNotification>();
 
class NotificationHelper {
  static const _channelId = "01";
  static const _channelName = "channel_01";
  static const _channelDesc = "dicoding channel";
  static NotificationHelper? _instance;
 
  NotificationHelper._internal() {
    _instance = this;
  }
  factory NotificationHelper() => _instance ?? NotificationHelper._internal();
 
  // Kita akan membuat beberapa fungsi jenis notifikasi di dalam kelas ini
  Future<void> initNotifications(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
 var initializationSettingsAndroid =
     const AndroidInitializationSettings('app_icon');
 
 var initializationSettingsIOS = DarwinInitializationSettings(
     requestAlertPermission: false,
     requestBadgePermission: false,
     requestSoundPermission: false,
     onDidReceiveLocalNotification:
         (int id, String? title, String? body, String? payload) async {
       didReceiveLocalNotificationSubject.add(ReceivedNotification(
           id: id, title: title, body: body, payload: payload));
     });
 
 var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
 
 await flutterLocalNotificationsPlugin.initialize(initializationSettings,
     onDidReceiveNotificationResponse: (NotificationResponse details) async {
   final payload = details.payload;
   if (payload != null) {
     print('notification payload: $payload');
   }
   selectNotificationSubject.add(payload);
 });
}
}