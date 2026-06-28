import 'dart:developer';

import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/services/notification_service/fcm_service.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

class NotificationPermissionSheet extends StatelessWidget {
  const NotificationPermissionSheet({super.key});

  static Future<bool> shouldShowPermissionSheet({bool? hasDeviceToken}) async {
    try {
      if (hasDeviceToken == false) {
        return true;
      }

      final hasAsked = await SharedPreferencesStore.getNotification();
      return !hasAsked;
    } catch (e) {
      log('Error checking notification permission: $e');
      return false;
    }
  }

  static Future<void> markAsAsked() async {
    await SharedPreferencesStore.saveNotification();
  }

  static Future<void> show(BuildContext context, {bool? hasDeviceToken}) async {
    log('NotificationPermissionSheet.show() hasDeviceToken: $hasDeviceToken');

    if (hasDeviceToken == false) {
      final fcmService = FCMService();
      final isAlreadyAuthorized = await fcmService.areNotificationsEnabled();

      if (isAlreadyAuthorized) {
        log('User has permission but no token on backend, resending token');
        await fcmService.resendTokenToBackend();
        return;
      }

      if (!context.mounted) return;
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        isDismissible: true,
        enableDrag: true,
        builder: (context) => const NotificationPermissionSheet(),
      );
      return;
    }

    if (hasDeviceToken == true) {
      log('User already has $hasDeviceToken');
      return;
    }

    final shouldShow = await shouldShowPermissionSheet(
      hasDeviceToken: hasDeviceToken,
    );
    if (!shouldShow || !context.mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => const NotificationPermissionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const VSpace(24),
              SizedBox(
                height: 200,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    ClipOval(
                      child: Container(
                        width: 200,
                        height: 200,
                        color: AppColors.primary50,
                        child: Image.asset(
                          Assets.images.paddedNotificationEdited.path,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const VSpace(24),
              Text(
                'Stay Updated!',
                style: AppTextStyles.xxlSemiBold(context),
                textAlign: TextAlign.center,
              ),
              const VSpace(18),
              Text(
                'Enable notifications to get reminders about your learning streak, new challenges, and rewards!',
                style: AppTextStyles.base(context).copyWith(
                  color: AppColors.activeButtonColor.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const VSpace(60),
              SizedBox(
                width: double.infinity,
                child: ButtonFactory.blackButton(
                  mainAxisAlignment: MainAxisAlignment.center,
                  onPressed: () => _handleEnableNotifications(context),
                  child: Text(
                    'Enable Notifications',
                    style: AppTextStyles.base(
                      context,
                    ).copyWith(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => _handleSkip(context),
                child: Text(
                  'Skip for now',
                  style: AppTextStyles.base(
                    context,
                  ).copyWith(color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleEnableNotifications(BuildContext context) async {
    try {
      await FCMService().initialize(requestPermission: true);
      await markAsAsked();
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to enable notifications: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleSkip(BuildContext context) async {
    await markAsAsked();
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
