import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../gen/assets.gen.dart';
import '../../l10n/app_localizations.dart';

class SocialAlertDialog extends StatelessWidget {
  final String platform;
  final String handle;
  final String description;
  final String? appUrl;
  final String? webUrl;
  final VoidCallback onStayInApp;
  final VoidCallback? onProceed;

  const SocialAlertDialog({
    super.key,
    required this.platform,
    required this.handle,
    required this.description,
    this.appUrl,
    this.webUrl,
    required this.onStayInApp,
    this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 316,
        height: 342,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 22,
              right: 22,
              child: GestureDetector(
                onTap: () => context.router.maybePop(),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xff252b37), width: 2),
                  ),
                  child: Icon(Icons.close, size: 12, color: Color(0xff252b37)),
                ),
              ),
            ),
            Positioned(
              top: 52,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child: SvgPicture.asset(
                    _getPlatformIcon(),
                    width: 70,
                    height: 70,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 146,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 240,
                  child: Column(
                    children: [
                      Text(
                        _getLocalizedTitle(context),
                        style: AppTextStyles.md(context),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.socialDialogDescription,
                        style: AppTextStyles.smRegular(
                          context,
                          color: Color(0xFF414651),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 29,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 240,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            context.router.maybePop();
                            onStayInApp();
                          },
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.gray700
                                  : const Color(0xFFD5D7DA),
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.stayInApp,
                                style: AppTextStyles.smSemiBold(
                                  context,
                                  color: Color(0xFF535862),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _handleProceed(context),
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0A0D12),
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.proceed,
                                style: const TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFFDFDFD),
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPlatformIcon() {
    switch (platform.toLowerCase()) {
      case 'telegram':
        return 'assets/icons/telegram_icon.svg';
      case 'twitter/x':
      case 'x (twitter)':
        return Assets.icons.xIcon;
      case 'linkedin':
        return Assets.icons.linkedIn;
      default:
        return Assets.icons.lwIcon;
    }
  }

  String _getLocalizedTitle(BuildContext context) {
    switch (platform.toLowerCase()) {
      case 'telegram':
        return AppLocalizations.of(context)!.doYouWantToViewOurTelegramChannel;
      case 'twitter/x':
      case 'x (twitter)':
        return AppLocalizations.of(context)!.doYouWantToViewOurTwitterProfile;
      case 'linkedin':
        return AppLocalizations.of(context)!.doYouWantToViewOurLinkedinProfile;
      default:
        return 'Do you want to view our $platform profile?';
    }
  }

  Future<void> _handleProceed(BuildContext context) async {
    context.router.maybePop();

    try {
      // Try to open the app first, then fallback to web
      if (appUrl != null) {
        final Uri appUri = Uri.parse(appUrl!);
        try {
          if (await canLaunchUrl(appUri)) {
            await launchUrl(appUri, mode: LaunchMode.externalApplication);
            return;
          }
        } catch (e) {
          debugPrint('Failed to launch app URL: $e');
        }
      }

      // Fallback to web URL
      if (webUrl != null) {
        final Uri webUri = Uri.parse(webUrl!);
        try {
          if (await canLaunchUrl(webUri)) {
            await launchUrl(webUri, mode: LaunchMode.externalApplication);
            return;
          }
        } catch (e) {
          debugPrint('Failed to launch web URL: $e');
        }
      }

      // If both fail, show a message or call the custom onProceed callback
      debugPrint(
        'Unable to launch URLs. App may not be installed or URLs are invalid.',
      );
      onProceed?.call();
    } catch (e) {
      debugPrint('Error launching URLs: $e');
      onProceed?.call();
    }
  }

  static void show({
    required BuildContext context,
    required String platform,
    required String handle,
    required String description,
    String? appUrl,
    String? webUrl,
    required VoidCallback onStayInApp,
    VoidCallback? onProceed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => SocialAlertDialog(
        platform: platform,
        handle: handle,
        description: description,
        appUrl: appUrl,
        webUrl: webUrl,
        onStayInApp: onStayInApp,
        onProceed: onProceed,
      ),
    );
  }
}
