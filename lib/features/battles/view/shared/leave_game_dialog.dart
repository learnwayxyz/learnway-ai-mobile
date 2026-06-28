import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:learnwayv2/features/main_activity/cubit/main_activity_cubit.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/core/di/locator.dart';

class LeaveGameDialog extends StatelessWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onLeave;
  final String? title;
  final String? description;

  const LeaveGameDialog({
    super.key,
    this.onCancel,
    this.onLeave,
    this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 280,
        height: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: onCancel ?? () => Navigator.of(context).pop(),
                  child: Image(
                    image: AssetImage(Assets.images.cancelButtonIcon.path),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    title ?? l10n.leaveGameConfirmation,
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      description!,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                        letterSpacing: 0.20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: onCancel ?? () => Navigator.of(context).pop(),
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD5D7DA),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Center(
                          child: Text(
                            l10n.cancel,
                            style: TextStyle(
                              color: const Color(0xFF535862),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1.14,
                              letterSpacing: 0.20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: GestureDetector(
                      onTap:
                          onLeave ??
                          () {
                            Navigator.of(context).pop();

                            locator.get<MainActivityCubit>().navigateTo(1);
                            context.router.pushAndPopUntil(
                              const MainActivityRoute(),
                              predicate: (route) => false,
                            );
                          },
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFFB42318),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Center(
                          child: Text(
                            l10n.leaveButton,
                            style: TextStyle(
                              color: const Color(0xFFFDFDFD),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1.14,
                              letterSpacing: 0.20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onCancel,
    VoidCallback? onLeave,
    String? title,
    String? description,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LeaveGameDialog(
        onCancel: onCancel,
        onLeave: onLeave,
        title: title,
        description: description,
      ),
    );
  }
}
