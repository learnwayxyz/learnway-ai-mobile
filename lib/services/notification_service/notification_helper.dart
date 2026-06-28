import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:learnwayv2/services/notification_service/local_notification_service.dart';

/// Helper class for common notification scenarios in LearnWay
class NotificationHelper {
  static final LocalNotificationService _notificationService =
      LocalNotificationService();

  /// Show a streak reminder notification
  static Future<void> showStreakReminder() async {
    await _notificationService.showNotification(
      id: 1,
      title: '🔥 Don\'t Break Your Streak!',
      body: 'Complete today\'s lesson to maintain your learning streak',
      payload: 'streak_reminder',
    );
  }

  /// Show a lesson completion notification
  static Future<void> showLessonCompleted({
    required String lessonTitle,
    required int xpEarned,
  }) async {
    await _notificationService.showNotification(
      id: 2,
      title: '🎉 Lesson Completed!',
      body: 'You completed "$lessonTitle" and earned $xpEarned XP',
      payload: 'lesson_completed',
    );
  }

  /// Show a battle challenge notification
  static Future<void> showBattleChallenge({
    required String opponentName,
  }) async {
    await _notificationService.showNotification(
      id: 3,
      title: '⚔️ Battle Challenge!',
      body: '$opponentName has challenged you to a battle',
      payload: 'battle_challenge',
    );
  }

  /// Show an achievement unlocked notification
  static Future<void> showAchievementUnlocked({
    required String achievementName,
  }) async {
    await _notificationService.showNotification(
      id: 4,
      title: '🏆 Achievement Unlocked!',
      body: 'You earned the "$achievementName" badge',
      payload: 'achievement_unlocked',
    );
  }

  /// Schedule a daily reminder at a specific time
  static Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    await _notificationService.scheduleDailyNotification(
      id: 100,
      title: '📚 Time to Learn!',
      body: 'Your daily lesson is waiting for you',
      hour: hour,
      minute: minute,
      payload: 'daily_reminder',
    );
  }

  /// Schedule a streak reset warning (23:00 daily)
  static Future<void> scheduleStreakResetWarning() async {
    await _notificationService.scheduleDailyNotification(
      id: 101,
      title: '⏰ Streak Reset Warning!',
      body: 'Your streak will reset at midnight. Complete today\'s lesson now!',
      hour: 23,
      minute: 0,
      payload: 'streak_warning',
    );
  }

  /// Cancel all scheduled notifications
  static Future<void> cancelAllNotifications() async {
    await _notificationService.cancelAllNotifications();
  }

  /// Cancel a specific notification
  static Future<void> cancelNotification(int id) async {
    await _notificationService.cancelNotification(id);
  }

  /// Request notification permissions (iOS)
  static Future<bool> requestPermissions() async {
    return await _notificationService.requestPermissions();
  }

  /// Get list of pending notifications
  static Future<List<PendingNotificationRequest>>
  getPendingNotifications() async {
    return await _notificationService.getPendingNotifications();
  }
}
