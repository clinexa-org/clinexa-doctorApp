import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/env.dart';

/// Handles FCM token registration and local notification display.
///
/// Initialize after Firebase.initializeApp() and after user login.
class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static final FirebaseDatabase _database = FirebaseDatabase.instance;

  static bool _initialized = false;

  /// Initialize the notification service.
  /// Call this after the user logs in with a valid auth token.
  static Future<void> initialize(Future<String?> Function() getToken) async {
    if (_initialized) return;

    try {
      // 1. Request Permission
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('NotificationService: Permission denied');
        return;
      }

      // 2. Get FCM Token and Register with Backend
      String? fcmToken = await _firebaseMessaging.getToken();
      if (fcmToken != null) {
        await _registerDeviceToken(getToken, fcmToken);
      }

      // 3. Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _registerDeviceToken(getToken, newToken);
      });

      // 4. Initialize Local Notifications (for foreground display)
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );
      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTap,
      );

      // 5. Create notification channel for Android
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
      );
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      // 6. Handle Foreground Messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        showLocalNotification(message);
      });

      _initialized = true;
      debugPrint('NotificationService: Initialized successfully');
    } catch (e) {
      debugPrint('NotificationService: Initialization failed - $e');
    }
  }

  /// Register FCM token with the backend.
  static Future<void> _registerDeviceToken(
    Future<String?> Function() getToken,
    String fcmToken,
  ) async {
    try {
      final authToken = await getToken();
      if (authToken == null) {
        debugPrint(
            'NotificationService: No auth token, skipping FCM registration');
        return;
      }

      final baseUrl = Env.baseUrl;
      await Dio().post(
        '$baseUrl/auth/device-token',
        data: {
          'token': fcmToken,
          'platform':
              defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android',
        },
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
      );
      debugPrint('NotificationService: FCM Token registered');
    } catch (e) {
      debugPrint('NotificationService: Failed to register FCM token - $e');
    }
  }

  /// Public method to force re-register device token (call after login)
  static Future<void> registerDeviceToken(
      Future<String?> Function() getToken) async {
    try {
      String? fcmToken = await _firebaseMessaging.getToken();
      if (fcmToken != null) {
        await _registerDeviceToken(getToken, fcmToken);
      }
    } catch (e) {
      debugPrint('NotificationService: Failed to register device token - $e');
    }
  }

  /// Start listening to real-time notifications from Firebase RTDB
  /// This replaces Socket.io for foreground updates on Vercel
  static void listenToRealtimeNotifications(String userId) {
    if (userId.isEmpty) return;

    debugPrint(
        'NotificationService: Listening to RTDB notifications for user $userId');

    final ref = _database.ref('notifications/$userId');

    // Listen for new notifications added
    ref.limitToLast(1).onChildAdded.listen((event) {
      if (event.snapshot.value == null) return;

      try {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);

        // Check if notification is recent (within last minute) to avoid showing old ones
        // or check 'read' status if you implement that
        final createdAtStr = data['createdAt'];
        if (createdAtStr != null) {
          final createdAt = DateTime.parse(createdAtStr);
          if (DateTime.now().difference(createdAt).inMinutes > 2) {
            return; // Skip old notifications
          }
        }

        final title = data['title'] ?? 'New Notification';
        final body = data['body'] ?? '';

        debugPrint('NotificationService: Received RTDB notification: $title');

        _showLocalNotification(
            title,
            body,
            data['data'] != null
                ? Map<String, dynamic>.from(data['data'])
                : null);
      } catch (e) {
        debugPrint('NotificationService: Error parsing RTDB data: $e');
      }
    });
  }

  /// Display a local notification (helper)
  static void _showLocalNotification(String title, String body,
      [Map<String, dynamic>? payload]) {
    _localNotifications.show(
        DateTime.now().millisecond, // Unique ID
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: payload.toString());
  }

  /// Display a local notification when a message is received in foreground.
  static void showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      _showLocalNotification(
          notification.title ?? '', notification.body ?? '', message.data);
    }
  }

  /// Handle notification tap.
  static void _onNotificationTap(NotificationResponse response) {
    // TODO: Navigate to appropriate screen based on notification payload
    debugPrint('Notification tapped: ${response.payload}');
  }

  /// Reset initialization state (call on logout).
  static void reset() {
    _initialized = false;
    // Note: Stream subscriptions should ideally be cancelled here if stored
  }
}
