import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:learnwayv2/app/app.dart';
import 'package:learnwayv2/core/di/locator.dart';

import 'package:learnwayv2/features/notifications/cubit/notification_cubit.dart';
import 'package:learnwayv2/features/notifications/data/notification_data_source.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/services/notification_service/local_notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Background message: ${message.messageId}');
}

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  static FCMService get instance => _instance;
  FCMService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  bool _isInitialized = false;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _openedAppSubscription;
  StreamSubscription<String>? _tokenRefreshSubscription;

  RemoteMessage? _pendingInitialMessage;

  Future<void> initialize({bool requestPermission = false}) async {
    if (_isInitialized) {
      log('FCM already initialized');
      return;
    }

    try {
      final settings = await _firebaseMessaging.getNotificationSettings();
      final isAuthorized =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;

      if (!isAuthorized && !requestPermission) {
        log('FCM: Notifications not authorized, skipping initialization');
        return;
      }

      if (requestPermission && !isAuthorized) {
        final status = await _requestPermissions();
        if (status != AuthorizationStatus.authorized &&
            status != AuthorizationStatus.provisional) {
          log('FCM: Permission denied, skipping initialization');
          return;
        }
      }

      await _getToken();
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );
      _tokenRefreshSubscription = _firebaseMessaging.onTokenRefresh.listen(
        _handleTokenRefresh,
      );

      _foregroundSubscription = FirebaseMessaging.onMessage.listen(
        _handleForegroundMessage,
      );

      _openedAppSubscription = FirebaseMessaging.onMessageOpenedApp.listen(
        (message) =>
            _handleNotificationTap(message, isFromTerminatedState: false),
      );

      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _pendingInitialMessage = initialMessage;
        log(
          'Stored initial message for later handling: ${initialMessage.messageId}',
        );
      }

      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      _isInitialized = true;
      log('FCM Service initialized successfully');
    } catch (e, stackTrace) {
      log('FCM initialization failed: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<AuthorizationStatus> _requestPermissions() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      log('FCM Permission: ${settings.authorizationStatus}');
      return settings.authorizationStatus;
    } catch (e) {
      log('Permission request failed: $e');
      return AuthorizationStatus.denied;
    }
  }

  Future<String?> _getToken() async {
    try {
      if (Platform.isIOS) {
        final apnsToken = await _firebaseMessaging.getAPNSToken();
        log(
          '[FCM] APNS token: ${apnsToken ?? 'null — will rely on onTokenRefresh'}',
        );
        if (apnsToken == null) {
          return null;
        }
      }

      _fcmToken = await _firebaseMessaging.getToken();

      if (_fcmToken != null) {
        log('[FCM] Token obtained: ${_fcmToken!.substring(0, 20)}...');
        await _sendTokenToBackend(_fcmToken!);
      } else {
        log('[FCM] getToken() returned null');
      }

      return _fcmToken;
    } catch (e, stackTrace) {
      log('Token retrieval failed: $e', stackTrace: stackTrace);
      return null;
    }
  }

  Future<void> _sendTokenToBackend(String token) async {
    log('@logand: _sendTokenToBackend');
    try {
      if (!locator.isRegistered<NotificationDataSource>()) {
        log('NotificationDataSource is not registered, skipping token send');
        return;
      }
      await locator.get<NotificationDataSource>().sendTokenDevice(token);
    } catch (e) {
      log('Failed to send token to backend: $e');
    }
  }

  void _handleTokenRefresh(String newToken) {
    log('FCM Token refreshed');
    _fcmToken = newToken;
    _sendTokenToBackend(newToken);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    log('Foreground message: ${message.messageId}');
    log('Title: ${message.notification?.title ?? "N/A"}');
    log('Body: ${message.notification?.body ?? "N/A"}');

    final title = message.notification?.title;
    final body = message.notification?.body;
    if (title != null && body != null) {
      LocalNotificationService().showNotification(
        id: message.hashCode,
        title: title,
        body: body,
        payload: _encodePayload(message.data),
      );
    }
  }

  void _handleNotificationTap(
    RemoteMessage message, {
    bool isFromTerminatedState = false,
  }) {
    log('Notification tapped: ${message.messageId}');

    _navigateBasedOnType(
      message.data,
      isFromTerminatedState: isFromTerminatedState,
    );
  }

  void _navigateBasedOnType(
    Map<String, dynamic> data, {
    required bool isFromTerminatedState,
  }) {
    if (data.isEmpty) return;
    navigateToNotificationDetail(
      data,
      isFromTerminatedState: isFromTerminatedState,
    );
  }

  Future<void> navigateToNotificationDetail(
    Map<String, dynamic> data, {
    required bool isFromTerminatedState,
  }) async {
    final notificationId = data['notificationId']?.toString();

    void fallbackNavigation() {
      if (isFromTerminatedState) {
        appRouter.replaceAll([MainActivityRoute(), NotificationsRoute()]);
      } else {
        appRouter.push(NotificationsRoute());
      }
    }

    if (notificationId == null) {
      log('No notificationId found in payload');
      fallbackNavigation();
      return;
    }

    try {
      final notificationCubit = locator.get<NotificationCubit>();

      var notification = notificationCubit.findNotificationById(notificationId);
      if (notification == null) {
        log('Notification not in cache, loading notifications...');
        await notificationCubit.loadNotifications();
        notification = notificationCubit.findNotificationById(notificationId);
      }

      if (notification != null) {
        log('Navigating to notification detail: ${notification.id}');
        await notificationCubit.markAsRead(notification.id);

        if (isFromTerminatedState) {
          appRouter.replaceAll([
            MainActivityRoute(),
            NotificationsRoute(),
            NotificationDetailRoute(notification: notification),
          ]);
        } else {
          appRouter.push(NotificationDetailRoute(notification: notification));
        }
      } else {
        log('Notification not found, navigating to notifications list');
        fallbackNavigation();
      }
    } catch (e, stackTrace) {
      log('Error handling notification navigation: $e', stackTrace: stackTrace);
      fallbackNavigation();
    }
  }

  Future<void> handlePendingNotification() async {
    if (_pendingInitialMessage != null) {
      log(
        'Handling pending initial message: ${_pendingInitialMessage!.messageId}',
      );

      if (!locator.isRegistered<NotificationCubit>()) {
        log(
          'NotificationCubit not yet registered, delaying notification handling',
        );
        return;
      }

      final message = _pendingInitialMessage!;
      _pendingInitialMessage = null;

      _handleNotificationTap(message, isFromTerminatedState: true);
    }
  }

  String _encodePayload(Map<String, dynamic> data) {
    return data.entries.map((e) => '${e.key}:${e.value}').join('|');
  }

  Future<bool> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      log('Subscribed to topic: $topic');
      return true;
    } catch (e) {
      log('Topic subscription failed ($topic): $e');
      return false;
    }
  }

  Future<bool> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      log('Unsubscribed from topic: $topic');
      return true;
    } catch (e) {
      log('Topic unsubscription failed ($topic): $e');
      return false;
    }
  }

  Future<bool> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      _fcmToken = null;
      log('FCM token deleted');
      return true;
    } catch (e) {
      log('Token deletion failed: $e');
      return false;
    }
  }

  Future<bool> areNotificationsEnabled() async {
    try {
      final settings = await _firebaseMessaging.getNotificationSettings();
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      log('Failed to check notification settings: $e');
      return false;
    }
  }

  Future<bool> resendTokenToBackend() async {
    log('Attempting to resend FCM token to backend');
    try {
      final token = await _getToken();
      return token != null;
    } catch (e) {
      log('Failed to resend token: $e');
      return false;
    }
  }

  Future<NotificationSettings> getNotificationSettings() async {
    return await _firebaseMessaging.getNotificationSettings();
  }

  Future<void> dispose() async {
    await _foregroundSubscription?.cancel();
    await _openedAppSubscription?.cancel();
    await _tokenRefreshSubscription?.cancel();
    _isInitialized = false;
    log('FCM Service disposed');
  }
}
