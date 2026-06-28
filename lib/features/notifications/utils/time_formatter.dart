import 'package:intl/intl.dart';
import 'package:learnwayv2/features/notifications/model/notification_model.dart';

String getFormattedTime(NotificationModel notification) {
  try {
    final dateTime = DateTime.parse(notification.createdAt).toLocal();
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);
    final notificationMidnight = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );

    final difference = todayMidnight.difference(notificationMidnight).inDays;

    if (difference == 0) {
      return DateFormat('h:mma').format(dateTime).toLowerCase();
    } else if (difference == 1) {
      return 'Yesterday';
    } else {
      return '$difference days ago';
    }
  } catch (e) {
    return notification.createdAt;
  }
}
