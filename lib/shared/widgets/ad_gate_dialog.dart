import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/services/ad_service.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

class AdGateDialog {
  AdGateDialog._();

  static Future<bool> show(
    BuildContext context, {
    String title = 'Watch an ad for extra gems',
    String description =
        'Watch a quick ad to continue, or go premium for an ad-free experience.',
    String watchAdButtonText = 'Get Gems',
  }) async {
    final isPremiumUser = await AdService.instance.isPremiumUser();
    if (isPremiumUser) return true;

    if (!context.mounted) return false;

    final result = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.7,
            end: 1.0,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.elasticOut)),
          child: Center(
            child: _AdGateContent(
              title: title,
              description: description,
              watchAdButtonText: watchAdButtonText,
            ),
          ),
        );
      },
    );

    return result ?? false;
  }
}

class _AdGateContent extends StatefulWidget {
  const _AdGateContent({this.title, this.description, this.watchAdButtonText});

  final String? title;
  final String? description;
  final String? watchAdButtonText;

  @override
  State<_AdGateContent> createState() => _AdGateContentState();
}

class _AdGateContentState extends State<_AdGateContent> {
  bool _isLoadingAd = false;

  Future<void> _watchAd() async {
    setState(() => _isLoadingAd = true);

    bool rewardEarned = false;
    final completer = Completer<bool>();

    await AdService.instance.showRewardedAd(
      onUserEarnedReward: (amount) {
        rewardEarned = true;
      },
      onAdClosed: () {
        if (!completer.isCompleted) completer.complete(rewardEarned);
      },
      onAdNotAvailable: () {
        if (!completer.isCompleted) completer.complete(true);
      },
    );

    final result = await completer.future;

    if (!mounted) return;
    setState(() => _isLoadingAd = false);
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const VSpace(20),
            Text(
              widget.title ?? 'Watch an ad for extra gems',
              style: AppTextStyles.mdBold(context),
              textAlign: TextAlign.center,
            ),
            const VSpace(8),
            Text(
              widget.description ??
                  'Watch a quick ad to continue, or go premium for an ad-free experience.',
              style: AppTextStyles.smRegular(
                context,
              ).copyWith(color: AppColors.gray500),
              textAlign: TextAlign.center,
            ),
            const VSpace(28),
            SizedBox(
              width: double.infinity,
              child: ButtonFactory.blackButton(
                mainAxisAlignment: MainAxisAlignment.center,
                onPressed: _isLoadingAd ? () {} : _watchAd,
                isLoading: _isLoadingAd,
                text: widget.watchAdButtonText ?? 'Get Gems',
              ),
            ),
            const VSpace(12),
            SizedBox(
              width: double.infinity,
              child: ButtonFactory.whiteButton(
                mainAxisAlignment: MainAxisAlignment.center,
                text: 'Get Premium',
                hasBorder: true,
                borderColor: AppColors.primaryColor,
                style: AppTextStyles.base(
                  context,
                ).copyWith(color: AppColors.primaryColor),
                onPressed: () async {
                  await context.router.push(const PayWallRoute());
                  if (!context.mounted) return;
                  final isPremium = await AdService.instance.isPremiumUser();
                  if (isPremium && context.mounted) {
                    Navigator.of(context).pop(true);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
