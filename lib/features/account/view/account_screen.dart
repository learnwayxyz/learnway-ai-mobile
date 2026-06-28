import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:core/src/config/env/env.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/app/app.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/account/cubit/profile_cubit.dart';
import 'package:core/src/config/env/api_config_service.dart';
import 'package:learnwayv2/services/revenue_cat_service.dart';
import 'package:learnwayv2/features/account/widgets/account_sections.dart';
import 'package:learnwayv2/features/account/widgets/alert_dialogs.dart';
import 'package:learnwayv2/features/wallet/cubit/kyc_cubit.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:learnwayv2/shared/widgets/social_alert_dialog.dart';

@RoutePage()
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _isPremium = false;

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchUserData();
    _isPremium = RevenueCatService.instance.isPremiumUser;
    RevenueCatService.instance.premiumStatusNotifier.addListener(
      _onPremiumChanged,
    );
  }

  void _onPremiumChanged() {
    final premium = RevenueCatService.instance.isPremiumUser;
    if (mounted && premium != _isPremium) {
      setState(() => _isPremium = premium);
    }
  }

  @override
  void dispose() {
    RevenueCatService.instance.premiumStatusNotifier.removeListener(
      _onPremiumChanged,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.account,
                  style: AppTextStyles.xlBold(context),
                ),
                VSpace(20),
                BlocConsumer<ProfileCubit, ProfileState>(
                  listener: (context, state) {
                    if (state.isDeleted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(
                              context,
                            )!.accountDeletedSuccessfully,
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );

                      Future.delayed(Duration(milliseconds: 1500), () {
                        if (!context.mounted) return;
                        context.read<ProfileCubit>().resetState();
                        appRouter.pushAndPopUntil(
                          const OnboardingInitialRoute(),
                          predicate: (route) => false,
                        );
                      });
                    }

                    if (state.hasDeleteError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.deleteErrorMessage ??
                                AppLocalizations.of(context)!.deleteFailed,
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }

                    if (state.hasError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.errorMessage ??
                                AppLocalizations.of(context)!.anErrorOccurred,
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state.isLoading && !state.hasUser) {
                      return AccountSections(
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ],
                      );
                    }
                    if (state.hasError && !state.hasUser) {
                      return AccountSections(
                        children: [
                          AccountImageTile(
                            imageUrl: 'https://via.placeholder.com/120',
                            username: AppLocalizations.of(
                              context,
                            )!.errorLoadingUser,
                            email: AppLocalizations.of(context)!.pleaseTryAgain,
                            onImageTap: () {
                              context.router.push(const ProfileRoute());
                            },
                          ),
                        ],
                      );
                    }
                    if (state.hasUser) {
                      return AccountSections(
                        children: [
                          Stack(
                            children: [
                              AccountImageTile(
                                imageUrl: _getProfileImageUrl(state),
                                username: state.user!.username ?? 'User',
                                email: state.user!.email ?? 'No email',
                                onImageTap: () {
                                  context.router.push(const ProfileRoute());
                                },
                              ),
                              if (state.isDeleting)
                                Positioned.fill(
                                  child: Container(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                          VSpace(8),
                                          Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.deletingAccount,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          AccountTiles(
                            icon: 'assets/icons/profile-circle.svg',
                            title: AppLocalizations.of(context)!.profile,
                            onTap: () {
                              context.router.push(const ProfileRoute());
                            },
                          ),
                          AccountTiles(
                            icon: 'assets/icons/security-user.svg',
                            title: AppLocalizations.of(
                              context,
                            )!.kycVerification,
                            onTap: () async {
                              await _handleKycVerification(context);
                            },
                          ),
                        ],
                      );
                    }
                    return AccountSections(
                      children: [
                        AccountImageTile(
                          imageUrl: 'https://via.placeholder.com/120',
                          username: AppLocalizations.of(context)!.loading,
                          email: AppLocalizations.of(context)!.loading,
                          onImageTap: () {
                            context.router.push(const ProfileRoute());
                          },
                        ),
                        AccountTiles(
                          icon: 'assets/icons/profile-circle.svg',
                          title: AppLocalizations.of(context)!.profile,
                          onTap: () {
                            context.router.push(const ProfileRoute());
                          },
                        ),
                        AccountTiles(
                          icon: 'assets/icons/security-user.svg',
                          title: AppLocalizations.of(context)!.kycVerification,
                          onTap: () async {
                            await _handleKycVerification(context);
                          },
                        ),
                      ],
                    );
                  },
                ),
                const VSpace(20),
                // IndependentTile(
                //   icon: Assets.icons.switchThemeIcon,
                //   backgroundColor: isDark ? AppColors.gray900 : Colors.white,
                //   title: 'Theme',
                //   onTap: () {
                //     context.router.push(const ChangeThemeRoute());
                //   },
                // ),
                // const VSpace(20),
                AccountSections(
                  children: [
                    AccountTiles(
                      icon: Assets.icons.accountMedal,
                      title: AppLocalizations.of(context)!.badgesAndAchievement,
                      onTap: () {
                        context.router.push(const BadgesRoute());
                      },
                    ),
                    // AccountTiles(
                    //   icon: Assets.icons.activity,
                    //   title: 'Learning Progress',
                    //   onTap: () {
                    //     context.router.push(const LearningProgressRoute());
                    //   },
                    // ),
                  ],
                ),
                const VSpace(20),
                IndependentTile(
                  icon: 'assets/icons/setting-5.svg',
                  title: AppLocalizations.of(context)!.preferences,
                  onTap: () {
                    context.router.push(const PreferenceRoute());
                  },
                ),
                const VSpace(20),
                IndependentTile(
                  icon: 'assets/icons/security-safe.svg',
                  title: AppLocalizations.of(context)!.security,
                  onTap: () {
                    context.router.push(const SecurityRoute());
                  },
                ),
                if (!_isPremium &&
                    locator.isRegistered<RevenueConfigResponse>() &&
                    locator
                        .get<RevenueConfigResponse>()
                        .enableRevenueService) ...[
                  const VSpace(20),
                  IndependentTile(
                    icon: 'assets/icons/money_receive.svg',
                    title: 'Subscribe to Premium',
                    onTap: () async {
                      await context.router.push(const PayWallRoute());
                      _onPremiumChanged();
                    },
                  ),
                ],
                if (_isPremium) ...[
                  const VSpace(20),
                  IndependentTile(
                    icon: 'assets/icons/money_receive.svg',
                    title: 'Manage Subscription',
                    onTap: () async {
                      await context.router.push(
                        const ManageSubscriptionRoute(),
                      );
                      _onPremiumChanged();
                    },
                  ),
                ],
                const VSpace(20),
                AccountSections(
                  children: [
                    AccountTiles(
                      icon: 'assets/icons/route-square.svg',
                      title: AppLocalizations.of(context)!.referAndEarn,
                      onTap: () {
                        context.router.push(const InviteFriendsRoute());
                      },
                    ),
                    AccountTiles(
                      icon: Assets.icons.shareAppIcon,
                      title: AppLocalizations.of(context)!.shareApp,
                      onTap: () {
                        _shareApp();
                      },
                    ),
                    AccountTiles(
                      icon: Assets.icons.rateIcon,
                      title: AppLocalizations.of(context)!.rateUs,
                      onTap: () {
                        _rateApp();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                IndependentTile(
                  icon: Assets.icons.lwIcon,
                  backgroundColor: Colors.white,
                  title: AppLocalizations.of(context)!.supportAndLegal,
                  onTap: () {
                    context.router.push(const AboutUsRoute());
                  },
                ),
                const VSpace(20),
                Text(
                  AppLocalizations.of(context)!.ourSocial,
                  style: AppTextStyles.smRegular(context),
                ),
                const VSpace(20),
                AccountSections(
                  children: [
                    SocialTile(
                      icon: Assets.icons.telegramIcon,
                      title: AppLocalizations.of(context)!.telegram,
                      subtitle: '@LearnWayApp',
                      onTap: () {
                        SocialAlertDialog.show(
                          context: context,
                          platform: 'Telegram',
                          handle: '@LearnWayApp',
                          description: '',
                          appUrl: Env.telegramAppUrl,
                          webUrl: Env.telegramAppUrl,
                          onStayInApp: () {
                            context.router.pop();
                          },
                        );
                      },
                    ),
                    SocialTile(
                      icon: Assets.icons.xIcon,
                      title: AppLocalizations.of(context)!.twitterX,
                      subtitle: '@LearnwayApp',
                      onTap: () {
                        SocialAlertDialog.show(
                          context: context,
                          platform: 'Twitter/X',
                          handle: '@LearnwayApp',
                          description: '',
                          appUrl: Env.twitterAppUrl,
                          webUrl: Env.twitterAppUrl,
                          onStayInApp: () {
                            context.router.pop();
                          },
                        );
                      },
                    ),
                    SocialTile(
                      icon: Assets.icons.linkedIn,
                      title: AppLocalizations.of(context)!.linkedin,
                      subtitle: '@LearnwayApp',
                      onTap: () {
                        SocialAlertDialog.show(
                          context: context,
                          platform: 'LinkedIn',
                          handle: '@LearnwayApp',
                          description: '',
                          appUrl: Env.linkedinAppUrl,
                          webUrl: Env.linkedinWebUrl,
                          onStayInApp: () {
                            context.router.pop();
                          },
                        );
                      },
                    ),
                  ],
                ),
                VSpace(20),
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    return IndependentTile(
                      icon: Assets.icons.logout,
                      title:
                          state.logoutAccountStatus ==
                              LogoutAccountStatus.loggingOut
                          ? AppLocalizations.of(context)!.loggingOutEllipsis
                          : AppLocalizations.of(context)!.logout,
                      onTap:
                          state.isDeleting ||
                              state.logoutAccountStatus ==
                                  LogoutAccountStatus.loggingOut
                          ? null
                          : () {
                              _showLogoutConfirmation(context);
                            },
                    );
                  },
                ),
                VSpace(20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getProfileImageUrl(ProfileState state) {
    if (state.hasSelectedImage &&
        state.selectedImagePath!.startsWith('assets/')) {
      return state.selectedImagePath!;
    }

    if (state.hasSelectedImage &&
        !state.selectedImagePath!.startsWith('assets/')) {
      if (state.user?.profileImageUrl != null &&
          state.user!.profileImageUrl!.isNotEmpty) {
        return state.user!.profileImageUrl!;
      }
    }

    if (state.user?.profileImageUrl != null &&
        state.user!.profileImageUrl!.isNotEmpty) {
      return state.user!.profileImageUrl!;
    }

    if (state.user?.profileThumbnailUrl != null &&
        state.user!.profileThumbnailUrl!.isNotEmpty) {
      return state.user!.profileThumbnailUrl!;
    }

    return 'https://via.placeholder.com/120';
  }

  Future<void> _handleKycVerification(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.checkingKycStatus,
                style: AppTextStyles.baseMedium(context),
              ),
            ],
          ),
        ),
      ),
    );

    final kycCubit = locator<KycCubit>();
    await kycCubit.initialize();
    final kycState = kycCubit.state;

    if (!mounted) return;

    // Dismiss loading dialog
    Navigator.of(context, rootNavigator: true).pop();

    if (kycState.isVerified) {
      await context.router.push(const KycDoneRoute());
    } else if (kycState.isInReview) {
      await context.router.push(const KycInReviewRoute());
    } else {
      await context.router.push(const KycNotDoneRoute());
    }
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDeleteConfirmationDialog(
      context,
      context.read<ProfileCubit>().state,
      title: AppLocalizations.of(context)!.areYouLoggingOut,
      description: AppLocalizations.of(context)!.logoutDescription,
      imagePath: Assets.images.logOut.path,
      actionType: AccountActionType.logout,
      onConfirm: () {
        locator.get<ProfileCubit>().logout();
      },
    );
  }

  void _shareApp() {
    const appLink = 'https://onelink.to/q3ypvq';
    const shareText =
        'Check out LearnWay - the ultimate learning platform! Join me and start your learning journey today.\n\n$appLink';

    SharePlus.instance.share(
      ShareParams(text: shareText, subject: 'Join me on LearnWay!'),
    );
  }

  //shareText, subject: 'Join me on LearnWay!'
  void _rateApp() async {
    const String appStoreUrl =
        'https://apps.apple.com/us/app/learnway-learn-engage-earn/id6743034005';
    const String playStoreUrl =
        'https://play.google.com/store/apps/details?id=xyz.learnway.app&hl=en';

    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await _launchUrl(appStoreUrl);
      } else {
        await _launchUrl(playStoreUrl);
      }
    } catch (e) {
      _showRateAppDialog();
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showRateAppDialog();
    }
  }

  void _showRateAppDialog() {
    final isIOS = defaultTargetPlatform == TargetPlatform.iOS;
    final storeUrl = isIOS
        ? 'https://apps.apple.com/us/app/learnway-learn-engage-earn/id6743034005'
        : 'https://play.google.com/store/apps/details?id=xyz.learnway.app&hl=en';
    final storeName = isIOS ? 'App Store' : 'Google Play Store';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.rateLearnWay),
        content: Text(
          AppLocalizations.of(context)!.rateAppDescription(storeName, storeUrl),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _copyToClipboard(storeUrl);
            },
            child: Text(AppLocalizations.of(context)!.copyLink),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.storeUrlCopied),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
