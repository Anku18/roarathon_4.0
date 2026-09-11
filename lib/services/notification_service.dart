import 'dart:async';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/notification_model.dart';
import '../state/app_state.dart';

/// Top-level handler — required by FCM for background/terminated messages.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase is already initialised before this is called.
  debugPrint('[FCM-BG] ${message.notification?.title}: ${message.notification?.body}');
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  // Resolved lazily so the singleton is usable even if Firebase failed to init.
  FirebaseMessaging get _messaging => FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  static const _channelId = 'roarathon_notifications';
  static const _channelName = 'Investo Alerts';
  static const _channelDesc = 'Market alerts, streak reminders & mission updates';

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  AppState? _appState;

  /// Call once from [main] after Firebase.initializeApp().
  Future<void> init(AppState appState) async {
    _appState = appState;

    // ── 1. Request permission ──────────────────────────────────────────────
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    debugPrint('[FCM] Permission: ${settings.authorizationStatus}');

    // ── 2. Android local notification channel ─────────────────────────────
    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.high,
      playSound: true,
    );

    final androidPlugin =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(androidChannel);

    // Initialise flutter_local_notifications
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    // Permission is already requested via FCM above, so don't prompt again.
    const darwinInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: darwinInit,
      macOS: darwinInit,
    );
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );

    // ── 3. FCM token ───────────────────────────────────────────────────────
    // Throws on iOS when no APNs token is available (e.g. the simulator).
    try {
      _fcmToken = await _messaging.getToken();
      debugPrint('[FCM] Token: $_fcmToken');
    } catch (e) {
      debugPrint('[FCM] Could not get token: $e');
    }

    _messaging.onTokenRefresh.listen((token) {
      _fcmToken = token;
      debugPrint('[FCM] Token refreshed: $token');
    });

    // ── 4. Foreground messages ─────────────────────────────────────────────
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // ── 5. Notification tap when app was in background ─────────────────────
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // ── 6. Notification tap when app was terminated ────────────────────────
    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      _addNotificationFromMessage(initial);
    }

    // ── 7. Subscribe to default topics ────────────────────────────────────
    try {
      await _messaging.subscribeToTopic('all_users');
    } catch (e) {
      debugPrint('[FCM] Could not subscribe to topic: $e');
    }
  }

  // ── Handlers ──────────────────────────────────────────────────────────────

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('[FCM-FG] ${message.notification?.title}');
    final notification = _addNotificationFromMessage(message);
    if (notification == null) return;

    // Show a local notification banner while app is in foreground
    await _localNotifications.show(
      Random().nextInt(100000),
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('[FCM] App opened via notification');
    _addNotificationFromMessage(message);
  }

  void _onLocalNotificationTap(NotificationResponse response) {
    // Could navigate to notifications screen here via a global navigator key
    debugPrint('[FCM] Local notification tapped: ${response.payload}');
  }

  AppNotification? _addNotificationFromMessage(RemoteMessage message) {
    final notif = message.notification;
    if (notif == null) return null;

    final data = message.data;
    final typeStr = data['type'] as String? ?? 'general';
    final type = NotificationType.values.firstWhere(
      (e) => e.name == typeStr,
      orElse: () => NotificationType.general,
    );

    final appNotif = AppNotification(
      id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: notif.title ?? 'Investo',
      body: notif.body ?? '',
      type: type,
      timestamp: DateTime.now(),
    );

    _appState?.addNotification(appNotif);
    return appNotif;
  }

  /// Inject a local/demo notification (used for testing without a real FCM push).
  void injectDemoNotification(AppState state, {NotificationType type = NotificationType.general}) {
    final demos = {
      NotificationType.marketAlert: ('📈 Market Alert', 'NIFTY is up 1.2% — take the pre-market quiz!'),
      NotificationType.streak: ('🔥 Streak Reminder', "Don't break your streak! Check in today."),
      NotificationType.mission: ('🎯 Mission Completed', 'You earned 50 Sherpoints for completing a mission.'),
      NotificationType.referral: ('👥 Referral Update', 'Rahul just funded his account. You earned a bonus!'),
      NotificationType.general: ('🔔 Investo', 'Welcome to Investo! Start earning today.'),
    };
    final (title, body) = demos[type]!;
    state.addNotification(AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      type: type,
      timestamp: DateTime.now(),
    ));
  }
}
