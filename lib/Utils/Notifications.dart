import 'package:buslink_flutter/Services/Api.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static String? token;
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    print('notoifiasdf');
    await _notificationsPlugin.initialize(settings);
  }

  static Future<void> showMockNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'mock_channel',
          'Mock Notifications',
          channelDescription: 'For testing local notifications',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );
    print('notoifiasdf');

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }

  static void initFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      token = await messaging.getToken();
      print("FCM Token: $token");
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print(
          'Message also contained a notification: ${message.notification!.title}',
        );
        NotificationService.showMockNotification(
          message.notification!.title!,
          message.notification!.body!,
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked! ${message.messageId}');
    });
  }

  static Future<void> backgroundHandler(RemoteMessage message) async {
    // Handle background message
    print('Handling a background message: ${message.messageId}');
  }

  static void storeDeviceToken() async {
    final response = await Api.dio.post(
      '/user/store-device-token',
      data: {"device_token": token},
    );
    print(response.data);
  }
}
