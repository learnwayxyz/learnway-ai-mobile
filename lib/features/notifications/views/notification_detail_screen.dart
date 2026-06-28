import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:learnwayv2/features/notifications/model/notification_model.dart';
import 'package:learnwayv2/features/notifications/utils/time_formatter.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';

@RoutePage()
class NotificationDetailScreen extends StatelessWidget {
  const NotificationDetailScreen({super.key, required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBarFactory.standardAppBar(
        title: 'Notification',
        barHeight: 10,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [const VSpace(20), _buildNotificationContent(context)],
        ),
      ),
    );
  }

  String _getAppBarTitle() {
    final type = notification.type.toLowerCase();
    if (type.contains('learn') ||
        type.contains('earn') ||
        type.contains('lesson') ||
        type.contains('achievement')) {
      return 'Learn and Earn Notification';
    } else if (type.contains('contest')) {
      return 'Contest Notification';
    } else if (type.contains('battle')) {
      return 'Battle Notification';
    } else if (type.contains('announcement') || type.contains('system')) {
      return 'Announcements';
    } else {
      return 'Notification';
    }
  }

  IconData _getTypeIcon() {
    final type = notification.type.toLowerCase();

    if (type.contains('learn') ||
        type.contains('earn') ||
        type.contains('lesson') ||
        type.contains('achievement')) {
      return Icons.school;
    } else if (type.contains('contest')) {
      return Icons.emoji_events;
    } else if (type.contains('battle')) {
      return Icons.sports_kabaddi;
    } else if (type.contains('announcement') || type.contains('system')) {
      return Icons.campaign;
    } else {
      return Icons.notifications;
    }
  }

  Widget _buildNotificationContent(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary25,
                ),
                child: Icon(_getTypeIcon(), color: Colors.white, size: 25),
              ),
              SizedBox(width: 10),
              Text(
                insertNewlines(notification.title, 20),
                style: AppTextStyles.mdBold(context),
              ),
              Spacer(),
              Text(
                getFormattedTime(notification),
                style: AppTextStyles.smRegular(context),
              ),
            ],
          ),
          const VSpace(20),
          Divider(),
          const VSpace(12),
          Text(
            notification.message,
            style: AppTextStyles.smRegular(
              context,
              color: const Color(0xFF181D27),
            ),
          ),
        ],
      ),
    );
  }

  String insertNewlines(String text, int characterLimit) {
    if (text.length <= characterLimit) {
      return text;
    }

    List<String> lines = [];
    int start = 0;

    while (start < text.length) {
      int end = start + characterLimit;

      if (end >= text.length) {
        lines.add(text.substring(start));
        break;
      }
      int lastSpace = text.lastIndexOf(' ', end);

      if (lastSpace > start) {
        lines.add(text.substring(start, lastSpace));
        start = lastSpace + 1;
      } else {
        lines.add(text.substring(start, end));
        start = end;
      }
    }

    return lines.join('\n');
  }
}
