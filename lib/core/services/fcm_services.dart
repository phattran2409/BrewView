import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';

// Global function để xử lý background messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class FcmServices {
  static final FcmServices _instance = FcmServices._internal();
  factory FcmServices() => _instance;
  FcmServices._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  BuildContext? _context;

  // Getter cho FCM token
  String? get fcmToken => _fcmToken;

  Future<void> initializeFCM({BuildContext? context}) async {
    _context = context;

    // Initialize local notifications
    await _initializeLocalNotifications();

    // Setup Firebase messaging
    await _setupFirebaseMessaging();

    // Get and store FCM token
    await _getFCMToken();

    // Setup message handlers
    _setupMessageHandlers();

    print("FCM Service initialized successfully");
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    const androidChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);
  }

  Future<void> _setupFirebaseMessaging() async {
    // Request permission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // Set background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _getFCMToken() async {
    try {
      _fcmToken = await _messaging.getToken();
      print("FCM Token: $_fcmToken");

      // Listen for token refresh
      _messaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        print("FCM Token refreshed: $newToken");
        // TODO: Send new token to your backend
        _sendTokenToBackend(newToken);
      });

      // Send initial token to backend
      if (_fcmToken != null) {
        await _sendTokenToBackend(_fcmToken!);
      }
    } catch (e) {
      print("Error getting FCM token: $e");
    }
  }

  void _setupMessageHandlers() {
    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received foreground message: ${message.messageId}');
      _handleForegroundMessage(message);
    });

    // Handle notification taps when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked from background!');
      _handleNotificationTap(message);
    });

    // Handle notification taps when app is terminated
    _handleInitialMessage();
  }

  Future<void> _handleInitialMessage() async {
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      print('Message clicked from terminated app!');
      _handleNotificationTap(initialMessage);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // Show local notification when app is in foreground
    _showLocalNotification(message);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'BrewView',
      message.notification?.body ?? 'Bạn có thông báo mới',
      notificationDetails,
      payload: jsonEncode(message.data),
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      final data = jsonDecode(response.payload!);
      _navigateBasedOnData(data);
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    _navigateBasedOnData(message.data);
  }

  void _navigateBasedOnData(Map<String, dynamic> data) {
    if (_context == null) return;

    final String? type = data['type'];
    final String? routePath = data['route'];

    switch (type) {
      case 'payment_success':
        _context!.push('/premium');
        break;
      case 'payment_failed':
        _context!.push('/payment');
        break;
      case 'subscription_expired':
        _context!.push('/premium');
        break;
      case 'new_feature':
        if (routePath != null) {
          _context!.push(routePath);
        }
        break;
      default:
        // Default navigation or stay on current screen
        break;
    }
  }

  Future<void> _sendTokenToBackend(String token) async {
    try {
      // TODO: Implement API call to send token to your backend
      print("Sending token to backend: $token");

      // Example API call structure:
      // final response = await ApiService.updateFCMToken(token);
      // if (response.isSuccess) {
      //   print("Token sent successfully");
      // }
    } catch (e) {
      print("Error sending token to backend: $e");
    }
  }

  // Public method to manually refresh token
  Future<String?> refreshToken() async {
    try {
      await _messaging.deleteToken();
      _fcmToken = await _messaging.getToken();
      if (_fcmToken != null) {
        await _sendTokenToBackend(_fcmToken!);
      }
      return _fcmToken;
    } catch (e) {
      print("Error refreshing FCM token: $e");
      return null;
    }
  }

  // Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      print("Subscribed to topic: $topic");
    } catch (e) {
      print("Error subscribing to topic: $e");
    }
  }

  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      print("Unsubscribed from topic: $topic");
    } catch (e) {
      print("Error unsubscribing from topic: $e");
    }
  }

  // Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    final settings = await _messaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  // Request notification permission again
  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  // Clear all notifications
  Future<void> clearAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // Set context for navigation
  void setContext(BuildContext context) {
    _context = context;
  }

  // Dispose resources
  void dispose() {
    _context = null;
  }
}
