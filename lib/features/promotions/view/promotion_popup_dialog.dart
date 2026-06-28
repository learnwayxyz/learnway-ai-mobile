import 'dart:developer' as dev;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:learnwayv2/app/app.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/promotions/cubit/promotions_cubit.dart';
import 'package:learnwayv2/features/promotions/model/promotion_model.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:url_launcher/url_launcher.dart';

class PromotionPopupDialog extends StatelessWidget {
  const PromotionPopupDialog({super.key, required this.promotion});

  final PromotionModel promotion;

  static Future<void> show(BuildContext context, PromotionModel promotion) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PromotionPopupDialog(promotion: promotion),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PromotionsCubit>();
    final country = LocalStorageService.getUserSync()?.country;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PromotionHeader(
              title: promotion.title,
              onDismiss: () => _handleDismiss(context, cubit, country),
            ),
            _PromotionBody(
              description: promotion.description,
              imageUrl: promotion.imageUrl,
            ),
            _PromotionActions(
              buttonText: promotion.buttonText,
              dismissText: promotion.dismissText,
              onCta: () => _handleCta(context, cubit, country),
              onDismiss: () => _handleDismiss(context, cubit, country),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleCta(
    BuildContext context,
    PromotionsCubit cubit,
    String? country,
  ) async {
    cubit.trackEvent(promotion.id, 'CLICK', country: country);
    cubit.markPopupSeen(promotion);

    if (context.mounted) Navigator.of(context).pop();

    final actionType = promotion.actionType;
    final actionValue = promotion.actionValue;

    if (actionType == null || actionValue == null || actionValue.isEmpty) {
      return;
    }

    switch (actionType) {
      case 'external_link':
      case 'deep_link':
        final uri = Uri.tryParse(actionValue);
        if (uri != null) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      case 'internal_screen':
        _navigateToScreen(actionValue);
    }
  }

  void _handleDismiss(
    BuildContext context,
    PromotionsCubit cubit,
    String? country,
  ) {
    cubit.trackEvent(promotion.id, 'DISMISS', country: country);
    cubit.markPopupSeen(promotion);
    Navigator.of(context).pop();
  }

  void _navigateToScreen(String screenName) {
    switch (screenName.toLowerCase()) {
      case 'subscription':
      case 'manage_subscription':
        appRouter.push(const ManageSubscriptionRoute());
      case 'courses':
      case 'learn_and_earn':
        appRouter.push(const LearnAndEarnRoute());
      case 'contest':
      case 'contests':
        appRouter.push(const ContestRoute());
      case 'profile':
        appRouter.push(const ProfileRoute());
      case 'account':
        appRouter.push(const AccountRoute());
      case 'referral':
      case 'invite_friends':
        appRouter.push(const InviteFriendsRoute());
      case 'battles':
        appRouter.push(const BattlesMainEntryRoute());
      default:
        dev.log(
          'No route mapped for internal_screen value: "$screenName"',
          name: 'PromotionPopupDialog',
        );
    }
  }
}

class _PromotionHeader extends StatelessWidget {
  const _PromotionHeader({required this.onDismiss, this.title});

  final VoidCallback onDismiss;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Expanded(child: Text(title!, style: AppTextStyles.lgBold(context))),
          if (title == null) const Spacer(),
          GestureDetector(
            onTap: onDismiss,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _PromotionBody extends StatelessWidget {
  const _PromotionBody({this.description, this.imageUrl});

  final String? description;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (description == null && imageUrl == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (description != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text(
              description!,
              style: AppTextStyles.smRegular(
                context,
              ).copyWith(color: AppColors.gray700),
            ),
          ),
        if (imageUrl != null) ...[
          if (description != null) const SizedBox(height: 12),
          CachedNetworkImage(
            imageUrl: imageUrl!,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorWidget: (_, _, _) => const SizedBox.shrink(),
          ),
        ],
      ],
    );
  }
}

class _PromotionActions extends StatelessWidget {
  const _PromotionActions({
    required this.onCta,
    required this.onDismiss,
    this.buttonText,
    this.dismissText,
  });

  final VoidCallback onCta;
  final VoidCallback onDismiss;
  final String? buttonText;
  final String? dismissText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ButtonFactory.blackButton(
            text: buttonText ?? 'Learn More',
            onPressed: onCta,
            backgroundColor: AppColors.primary25,
            mainAxisAlignment: MainAxisAlignment.center,
            textStyle: AppTextStyles.smBold(
              context,
            ).copyWith(color: Colors.white),
            padding: const EdgeInsets.symmetric(vertical: 10),
          ),
          const VSpace(8),
          ButtonFactory.outlinedButton(
            mainAxisAlignment: MainAxisAlignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10),
            text: dismissText ?? 'Dismiss',
            onPressed: onDismiss,
            textStyle: AppTextStyles.smBold(
              context,
            ).copyWith(color: AppColors.primary25),
            borderColor: AppColors.primary25,
          ),
        ],
      ),
    );
  }
}
