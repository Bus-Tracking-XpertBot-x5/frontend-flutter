// notifications.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Model representing a single notification
class NotificationModel {
  final String title;
  final String body;
  final DateTime receivedAt;

  NotificationModel({
    required this.title,
    required this.body,
    DateTime? receivedAt,
  }) : receivedAt = receivedAt ?? DateTime.now();
}

/// GetX controller to manage notifications list
class NotificationController extends GetxController {
  final notifications = [].obs;

  void addNotification(NotificationModel n) {
    notifications.insert(0, n);
  }

  void markAllRead() {
    notifications.clear();
  }
}

/// Service to handle FCM and local notifications
class NotificationService {
  static String? token;
  static final _plugin = FlutterLocalNotificationsPlugin();

  /// Initialize local notifications plugin
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    await _plugin.initialize(
      const InitializationSettings(android: androidSettings),
    );
  }

  /// Display a local notification
  static Future showLocal(String title, String body) async {
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'buslink_channel',
          'BusLink Notifications',
          channelDescription: 'Bus updates and alerts',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  /// Initialize Firebase Cloud Messaging
  static Future initFCM() async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      token = await messaging.getToken();
      print('FCM Token: $token');
    }

    // Register controller
    final controller = Get.put(NotificationController());

    FirebaseMessaging.onMessage.listen((msg) {
      final n = NotificationModel(
        title: msg.notification?.title ?? 'No Title',
        body: msg.notification?.body ?? 'No Body',
      );
      controller.addNotification(n);
      showLocal(n.title, n.body);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      final n = NotificationModel(
        title: msg.notification?.title ?? '',
        body: msg.notification?.body ?? '',
      );
      controller.addNotification(n);
    });

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  }

  /// Handle background messages
  static Future _backgroundHandler(RemoteMessage msg) async {
    final controller = Get.find();
    final n = NotificationModel(
      title: msg.notification?.title ?? '',
      body: msg.notification?.body ?? '',
    );
    controller.addNotification(n);
  }
}

/// Main application entry
void main() async {
  await NotificationService.init();
  await NotificationService.initFCM();
  runApp(const MyApp());
}

/// Root widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const NotificationsPage(),
    );
  }
}

/// Notifications page displaying list
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find();
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Obx(() {
        final list = controller.notifications;
        if (list.isEmpty) {
          return const Center(child: Text('No notifications'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: list.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (ctx, idx) {
            final n = list[idx];
            return ListTile(
              leading: const Icon(Icons.notifications),
              title: Text(n.title),
              subtitle: Text(n.body),
              trailing: Text(
                TimeOfDay.fromDateTime(n.receivedAt).format(context),
                style: const TextStyle(fontSize: 12),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.mark_email_read),
        onPressed: controller.markAllRead,
        tooltip: 'Mark All as Read',
      ),
    );
  }
}
