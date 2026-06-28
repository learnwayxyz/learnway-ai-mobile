import 'dart:developer' as dev;
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/badges/bloc/badge_bloc.dart';
import 'package:learnwayv2/features/badges/bloc/badge_event.dart';
import 'package:learnwayv2/features/badges/bloc/badge_state.dart';
import 'package:learnwayv2/features/badges/models/badge_model.dart';
import 'package:learnwayv2/features/badges/models/badge_tier_item.dart';
import 'package:learnwayv2/features/badges/widgets/badge_category_section.dart';
import 'package:learnwayv2/features/badges/widgets/badge_shimmer_loader.dart';
import 'package:learnwayv2/features/badges/widgets/badge_styles.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/shared/widgets/screen_connectivity_wrapper.dart';

@RoutePage()
class BadgesScreen extends StatefulWidget {
  const BadgesScreen({super.key});

  @override
  State<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen>
    with ScreenLoadStateMixin<BadgesScreen> {
  @override
  String get routeName => '/badges';

  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadBadges();
  }

  void _loadBadges() async {
    final userId = LocalStorageService.getUserSync()?.id;
    dev.log('User id: $userId');
    if (userId != null && userId.isNotEmpty) {
      locator.get<BadgeBloc>().add(LoadUserBadges(userId));
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenConnectivityWrapper(
      routeName: routeName,
      onRetry: () => _loadBadges(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBarFactory.standardAppBar(
          title: AppLocalizations.of(context)!.badges,
          barHeight: 0,
        ),
        body: BlocListener<BadgeBloc, BadgeState>(
          listener: (context, state) {
            if (state is BadgeLoaded) {
              markAsLoaded();
            }

            if (state is BadgeInitial) {
              dev.log('Badges initial state');
              _loadBadges();
            }
          },
          child: BlocBuilder<BadgeBloc, BadgeState>(
            builder: (context, state) {
              if (state is BadgeLoading) {
                return const SafeArea(child: BadgeShimmerLoader());
              }
              if (state is BadgeInitial) {
                dev.log('Badges initial state');
                _loadBadges();
              }
              // Show error state
              if (state is BadgeError) {
                return SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const VSpace(16),
                          Text(
                            AppLocalizations.of(context)!.failedToLoadBadges,
                            style: AppTextStyles.mdBold(context),
                          ),
                          const VSpace(8),
                          Text(
                            state.message,
                            style: AppTextStyles.sm(context),
                            textAlign: TextAlign.center,
                          ),
                          const VSpace(20),
                          ElevatedButton(
                            onPressed: () => _loadBadges(),
                            child: Text(AppLocalizations.of(context)!.retry),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              // Show loaded data
              if (state is BadgeLoaded) {
                return _buildContent(
                  state.badgesByCategory,
                  state.earnedBadges,
                  state.totalEarned,
                  state.totalBadges,
                );
              }

              // Default: show empty state
              return SafeArea(
                child: Center(
                  child: Text(AppLocalizations.of(context)!.noBadgesAvailable),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    Map<String, List<BadgeTierItem>> badgesByCategory,
    List<BadgeModel> earnedBadges,
    int earnedCount,
    int totalCount,
  ) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VSpace(20),
                _buildHeaderSection(earnedCount, totalCount),
                const VSpace(17),
                _buildTabButtons(),
                const VSpace(20),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              children: [
                _buildBadgeList(
                  badgesByCategory: badgesByCategory,
                  showEarnedOnly: false,
                ),
                _buildEarnedBadgesList(earnedBadges),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(int earnedCount, int totalCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.badgesYouveEarned,
          style: AppTextStyles.mdBold(context),
        ),
        const VSpace(4),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$earnedCount of $totalCount ',
                style: AppTextStyles.smBold(
                  context,
                  color: AppColors.primaryMain,
                ),
              ),
              TextSpan(
                text: AppLocalizations.of(context)!.achievementsCollected,
                style: AppTextStyles.sm(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabButtons() {
    return Row(
      children: [
        _buildTabButton(
          label: AppLocalizations.of(context)!.allBadges,
          isSelected: _currentPage == 0,
          onTap: () => _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
        ),
        const HSpace(10),
        _buildTabButton(
          label: AppLocalizations.of(context)!.earnedBadges,
          isSelected: _currentPage == 1,
          onTap: () => _pageController.animateToPage(
            1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: isSelected ? (Colors.black) : AppColors.blueGray100,
          borderRadius: BorderRadius.circular(60),
        ),
        child: Text(
          label,
          style: isSelected
              ? (AppTextStyles.sm(context, color: AppColors.white))
              : AppTextStyles.sm(context, color: AppColors.gray700),
        ),
      ),
    );
  }

  /// Build the "All Badges" tab (categorized view)
  Widget _buildBadgeList({
    required Map<String, List<BadgeTierItem>> badgesByCategory,
    required bool showEarnedOnly,
  }) {
    dev.log(
      'Building badge list ${badgesByCategory.map((e, v) => MapEntry(e, v[v.length - 1].badgeType))}',
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...badgesByCategory.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: BadgeCategorySection(
                  categoryTitle: entry.key,
                  badges: entry.value,
                  showEarnedOnly: showEarnedOnly,
                ),
              ),
            ),
            const VSpace(20),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyEarnedState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 80,
              color: AppColors.gray400,
            ),
            const VSpace(24),
            Text(
              AppLocalizations.of(context)!.noBadgesEarnedYet,
              style: AppTextStyles.lgBold(context),
              textAlign: TextAlign.center,
            ),
            const VSpace(12),
            Text(
              AppLocalizations.of(context)!.completeChallengesForBadge,
              style: AppTextStyles.sm(context, color: AppColors.gray600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build the earned badges list (from /api/v2/badges/user/{userId})
  /// Shows all earned badges in one white container (no categorization)
  Widget _buildEarnedBadgesList(List<BadgeModel> earnedBadges) {
    if (earnedBadges.isEmpty) {
      return _buildEmptyEarnedState();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: BadgeStyles.cardBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.yourEarnedBadges,
                    style: BadgeStyles.categoryTitle,
                  ),
                  const VSpace(20),
                  Container(height: 1, color: BadgeStyles.dividerColor),
                  const VSpace(44),
                  _buildEarnedBadgesGrid(earnedBadges),
                ],
              ),
            ),
            const VSpace(20),
          ],
        ),
      ),
    );
  }

  /// Build grid of earned badges (2 column layout)
  Widget _buildEarnedBadgesGrid(List<BadgeModel> badges) {
    return Column(
      children: List.generate((badges.length / 2).ceil(), (index) {
        final firstBadgeIndex = index * 2;
        final secondBadgeIndex = firstBadgeIndex + 1;

        return Padding(
          padding: EdgeInsets.only(
            bottom: secondBadgeIndex < badges.length ? 20 : 0,
          ),
          child: Row(
            children: [
              Expanded(child: _buildEarnedBadgeCard(badges[firstBadgeIndex])),
              if (secondBadgeIndex < badges.length)
                Expanded(child: _buildEarnedBadgeCard(badges[secondBadgeIndex]))
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        );
      }),
    );
  }

  /// Build single earned badge card
  Widget _buildEarnedBadgeCard(BadgeModel badge) {
    return GestureDetector(
      onTap: () => context.router.push(
        BadgeDetailsRoute(badgeType: badge.badgeType ?? ''),
      ),
      child: SizedBox(
        width: 160,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Badge icon with SVG support
            _buildBadgeIcon(badge.iconPath),
            const VSpace(22),
            Text(
              badge.name,
              style: BadgeStyles.badgeTitle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              badge.description,
              style: BadgeStyles.badgeDescription,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Build badge icon with SVG support
  Widget _buildBadgeIcon(String imageUrl) {
    // Placeholder widget
    Widget placeholder = Container(
      width: 101.03,
      height: 101.03,
      decoration: BoxDecoration(
        color: AppColors.gray200,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.emoji_events, size: 50, color: AppColors.gray400),
    );

    // Empty or invalid URL
    if (imageUrl.isEmpty) {
      return placeholder;
    }

    // Handle network images (from API)
    if (imageUrl.startsWith('http')) {
      if (imageUrl.endsWith('.svg')) {
        // Use SvgPicture.network for SVG files
        return SizedBox(
          width: 101.03,
          height: 101.03,
          child: SvgPicture.network(
            imageUrl,
            placeholderBuilder: (context) => placeholder,
            fit: BoxFit.contain,
          ),
        );
      } else {
        // Use CachedNetworkImage for PNG/JPG
        return SizedBox(
          width: 101.03,
          height: 101.03,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.contain,
            placeholder: (context, url) => placeholder,
            errorWidget: (context, url, error) => placeholder,
          ),
        );
      }
    }

    // Handle local assets (fallback)
    if (imageUrl.endsWith('.svg')) {
      return SizedBox(
        width: 101.03,
        height: 101.03,
        child: SvgPicture.asset(imageUrl, fit: BoxFit.contain),
      );
    } else {
      return SizedBox(
        width: 101.03,
        height: 101.03,
        child: Image.asset(imageUrl, fit: BoxFit.contain),
      );
    }
  }
}
