import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize([Future<String?> Function()? getToken]) {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap logic here
      },
    );

    _createNotificationChannel();
  }

  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> registerDeviceToken(
      Future<String?> Function() getToken) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        debugPrint('Device Token: $token');
        // TODO: Send token to backend using getToken() to get auth token
      }
    } catch (e) {
      debugPrint('Error registering device token: $e');
    }
  }

  static void listenToRealtimeNotifications(String userId) {
    try {
      final ref = FirebaseDatabase.instance.ref('notifications/$userId');
      ref.onChildAdded.listen((event) {
        if (event.snapshot.value != null) {
          try {
            final data = Map<String, dynamic>.from(event.snapshot.value as Map);
            // Construct a RemoteMessage-like object or just call show directly if adapted
            // For now, let's just show a local notification manually
            _showLocalNotification(
              title: data['title'] ?? 'New Notification',
              body: data['body'] ?? '',
              payload: data.toString(),
            );
          } catch (e) {
            debugPrint('Error parsing RTDB notification: $e');
          }
        }
      });
    } catch (e) {
      debugPrint('Error listening to RTDB: $e');
    }
  }

  static Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  static Future<void> show(RemoteMessage message) async {
    try {
      await _showLocalNotification(
        title: message.notification?.title ??
            message.data['title'] ??
            'New Notification',
        body: message.notification?.body ?? message.data['body'] ?? '',
        payload: message.data.toString(),
      );
    } catch (e) {
      // Ignore error
    }
  }
}
