import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:learnwayv2/services/notification_service/fcm_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class LocalNotificationService {
  static final LocalNotificationService _instance =
      LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  // Notification channel IDs
  static const String _defaultChannelId = 'learnway_channel';
  static const String _scheduledChannelId = 'learnway_scheduled_channel';
  static const String _dailyChannelId = 'learnway_daily_channel';

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_initialized) {
      log('LocalNotificationService already initialized');
      return;
    }

    try {
      // Initialize timezone data
      tz.initializeTimeZones();

      // Android settings
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      // iOS settings - don't request permission during initialization
      // Permission will be requested on the home screen
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // Initialize plugin
      final initialized = await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      if (initialized != true) {
        log('Notification initialization returned false');
      }

      // Create Android notification channels
      await _createNotificationChannels();

      _initialized = true;
      log('LocalNotificationService initialized successfully');
    } catch (e, stackTrace) {
      log('Notification initialization failed: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Create Android notification channels
  Future<void> _createNotificationChannels() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin == null) {
      log('Android plugin not available');
      return;
    }

    // Default channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _defaultChannelId,
        'LearnWay Notifications',
        description: 'General notifications for LearnWay app',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      ),
    );

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _scheduledChannelId,
        'LearnWay Scheduled Notifications',
        description: 'Scheduled notifications for LearnWay app',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      ),
    );

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _dailyChannelId,
        'LearnWay Daily Reminders',
        description: 'Daily reminder notifications for learning streaks',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      ),
    );

    log('Android notification channels created');
  }

  Future<bool> requestPermissions() async {
    try {
      final iosPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();

      if (iosPlugin == null) {
        log('iOS plugin not available');
        return true;
      }

      final granted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      log('iOS notification permissions granted: $granted');
      return granted ?? false;
    } catch (e) {
      log('Permission request failed: $e');
      return false;
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? channelId,
  }) async {
    if (!_initialized) {
      log('Service not initialized, initializing now...');
      await initialize();
    }

    try {
      final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          channelId ?? _defaultChannelId,
          'LearnWay Notifications',
          channelDescription: 'General notifications for LearnWay app',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
          icon: '@drawable/ic_notification',
          styleInformation: BigTextStyleInformation(body),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _notificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );

      log('Notification shown: $title');
    } catch (e, stackTrace) {
      log('Failed to show notification: $e', stackTrace: stackTrace);
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    try {
      final scheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);

      final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          _scheduledChannelId,
          'LearnWay Scheduled Notifications',
          channelDescription: 'Scheduled notifications for LearnWay app',
          importance: Importance.high,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(body),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );

      log('Notification scheduled for: $scheduledDate');
    } catch (e, stackTrace) {
      log('Failed to schedule notification: $e', stackTrace: stackTrace);
    }
  }

  /// Schedule a daily notification at a specific time
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    try {
      final scheduledTime = _nextInstanceOfTime(hour, minute);

      final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          _dailyChannelId,
          'LearnWay Daily Reminders',
          channelDescription:
              'Daily reminder notifications for learning streaks',
          importance: Importance.high,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(body),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );

      log('Daily notification scheduled for: $hour:$minute');
    } catch (e, stackTrace) {
      log('Failed to schedule daily notification: $e', stackTrace: stackTrace);
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      await _notificationsPlugin.cancel(id);
      log('Notification cancelled: $id');
    } catch (e) {
      log('Failed to cancel notification: $e');
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await _notificationsPlugin.cancelAll();
      log('All notifications cancelled');
    } catch (e) {
      log('Failed to cancel all notifications: $e');
    }
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      final pending = await _notificationsPlugin.pendingNotificationRequests();
      return pending;
    } catch (e) {
      log('Failed to get pending notifications: $e');
      return [];
    }
  }

  Future<List<ActiveNotification>> getActiveNotifications() async {
    try {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidPlugin == null) {
        return [];
      }

      final active = await androidPlugin.getActiveNotifications();
      return active;
    } catch (e) {
      log('Failed to get active notifications: $e');
      return [];
    }
  }

  void _onNotificationTapped(NotificationResponse response) async {
    log(
      'Notification tapped - ID: ${response.id}, Payload: ${response.payload}',
    );

    final payload = response.payload;
    if (payload == null || payload.isEmpty) {
      log('No payload found');
      return;
    }

    // Check if app was launched by this notification tap
    final launchDetails = await _notificationsPlugin
        .getNotificationAppLaunchDetails();
    final isFromTerminated = launchDetails?.didNotificationLaunchApp ?? false;

    _handleNotificationNavigation(
      payload,
      isFromTerminatedState: isFromTerminated,
    );
  }

  void _handleNotificationNavigation(
    String payload, {
    required bool isFromTerminatedState,
  }) {
    final data = <String, String>{};
    for (final pair in payload.split('|')) {
      final parts = pair.split(':');
      if (parts.length >= 2) {
        data[parts[0]] = parts.sublist(1).join(':');
      }
    }

    FCMService().navigateToNotificationDetail(
      data,
      isFromTerminatedState: isFromTerminatedState,
    );
  }

  /// Calculate next instance of a specific time (for daily notifications)
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the scheduled time has passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }
}
