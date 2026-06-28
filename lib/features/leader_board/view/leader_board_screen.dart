import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/leader_board/cubit/leader_board_cubit.dart';
import 'package:learnwayv2/features/leader_board/models/leaderboard_entry_model.dart';
import 'package:learnwayv2/features/leader_board/models/leaderboard_user.dart';
import 'package:learnwayv2/features/leader_board/models/my_position_model.dart';
import 'package:learnwayv2/features/leader_board/widgets/leaderboard_widgets.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';

import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/utilities/ui_utils.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/shared/widgets/custom_tabs.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          locator<LeaderBoardCubit>()..loadAllTimeLeaderboard(),
      child: const _LeaderboardScreenContent(),
    );
  }
}

class _LeaderboardScreenContent extends StatefulWidget {
  const _LeaderboardScreenContent();

  @override
  State<_LeaderboardScreenContent> createState() =>
      _LeaderboardScreenContentState();
}

class _LeaderboardScreenContentState extends State<_LeaderboardScreenContent> {
  final ScrollController _scrollController = ScrollController();
  String _currentPeriod = 'alltime';
  String? _currentUsername;
  final Map<int, GlobalKey> _itemKeys = {};
  LeaderboardUser _convertToLeaderboardUser(
    LeaderboardEntryModel entry, {
    bool isCurrentUser = false,
  }) {
    return LeaderboardUser(
      rank: entry.rank,
      name: entry.username,
      score: entry.totalGems,
      avatar: entry.profileImageUrl ?? Assets.avatars.male1.path,
      xp: entry.totalXP.toString(),
      isCurrentUser: isCurrentUser,
    );
  }

  void _onTabChanged(String period) {
    setState(() {
      _currentPeriod = period;
      _itemKeys.clear();
    });

    _loadLeaderboard(period);
  }

  void _loadLeaderboard(String period, {bool forceRefresh = false}) {
    final cubit = context.read<LeaderBoardCubit>();
    switch (period) {
      case 'alltime':
        cubit.loadAllTimeLeaderboard(forceRefresh: forceRefresh);
        break;
      case 'monthly':
        cubit.loadMonthlyLeaderboard(forceRefresh: forceRefresh);
        break;
      case 'weekly':
        cubit.loadWeeklyLeaderboard(forceRefresh: forceRefresh);
        break;
    }
  }

  Future<void> _onRefresh() async {
    _loadLeaderboard(_currentPeriod, forceRefresh: true);
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _scrollToCurrentUserPosition(List<LeaderboardUser> currentUsers) async {
    await Future.delayed(Duration(milliseconds: 500));

    final listUsers = currentUsers.where((user) => user.rank > 3).toList();
    final currentUserIndex = listUsers.indexWhere((user) => user.isCurrentUser);

    if (currentUserIndex == -1) {
      return;
    }

    final itemKey = _itemKeys[currentUserIndex];
    if (itemKey == null || itemKey.currentContext == null) {
      return;
    }

    try {
      await Scrollable.ensureVisible(
        itemKey.currentContext!,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        alignment: 0.3,
      );
      log('Successfully scrolled to current user');
    } catch (e) {
      log(' Error scrolling: $e');
    }
  }

  Future<void> _loadCurrentUsername() async {
    final username = LocalStorageService.getUserSync()?.username;
    if (mounted) {
      setState(() {
        _currentUsername = username;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentUsername();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, responsiveInfo) {
        return Scaffold(
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    pinned: false,
                    floating: false,
                    leading: Padding(
                      padding: FigmaConverter.padding(
                        context,
                        left: 8,
                        top: 8,
                        bottom: 8,
                        right: 8,
                      ),
                    ),
                    backgroundColor: Color(0xffF8F9FC),
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.leaderboard,
                            style: AppTextStyles.mdBold(context).copyWith(
                              fontSize: FigmaConverter.fontSize(context, 24),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: FigmaConverter.symmetricPadding(
                        context,
                        horizontal: 16,
                      ),
                      child: CustomTabs(
                        tabs: [
                          TabItem(
                            value: 'alltime',
                            label: AppLocalizations.of(context)!.allTime,
                            selectedColor: AppColors.gray900,
                            unselectedColor: AppColors.gray200,
                            selectedTextColor: Colors.white,
                            unselectedTextColor: AppColors.gray700,
                          ),
                          TabItem(
                            value: 'monthly',
                            label: AppLocalizations.of(context)!.monthly,
                            selectedColor: AppColors.gray900,
                            unselectedColor: AppColors.gray200,
                            selectedTextColor: Colors.white,
                            unselectedTextColor: AppColors.gray700,
                          ),
                          TabItem(
                            value: 'weekly',
                            label: AppLocalizations.of(context)!.weekly,
                            selectedColor: AppColors.gray900,
                            unselectedColor: AppColors.gray200,
                            selectedTextColor: Colors.white,
                            unselectedTextColor: AppColors.gray700,
                          ),
                        ],
                        selectedValue: _currentPeriod,
                        onTabSelected: (value) {
                          _onTabChanged(value);
                        },
                        padding: EdgeInsets.zero,
                        spacing: FigmaConverter.width(context, 10.0),
                        borderRadius: FigmaConverter.width(context, 60.0),
                        defaultPadding: FigmaConverter.symmetricPadding(
                          context,
                          horizontal: 15,
                          vertical: 0,
                        ),
                        defaultTextStyle: AppTextStyles.smBold(context),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: BlocBuilder<LeaderBoardCubit, LeaderBoardState>(
                      builder: (context, state) {
                        if (state is LeaderBoardLoading) {
                          return const LeaderboardShimmerLoader();
                        }

                        if (state is LeaderBoardError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.failedToLoadLeaderboard,
                                    style: AppTextStyles.mdSemiBold(context),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    state.message,
                                    style: AppTextStyles.smRegular(context),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () =>
                                        _onTabChanged(_currentPeriod),
                                    child: Text(
                                      AppLocalizations.of(context)!.retry,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        if (state is LeaderBoardLoaded) {
                          final currentUsers = state.leaderboard.entries
                              .map(
                                (entry) => _convertToLeaderboardUser(
                                  entry,
                                  isCurrentUser:
                                      _currentUsername != null &&
                                      entry.username == _currentUsername,
                                ),
                              )
                              .toList();
                          log(
                            'Loaded ${currentUsers.map((e) => e.rank).toList()} users for period: $_currentPeriod',
                          );

                          return Padding(
                            padding: FigmaConverter.symmetricPadding(
                              context,
                              horizontal: 16,
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: FigmaConverter.height(context, 22),
                                ),
                                PodiumSection(
                                  users: currentUsers,
                                  responsiveInfo: responsiveInfo,
                                ),
                                SizedBox(
                                  height: FigmaConverter.height(context, 20),
                                ),
                                if (state.myPosition != null)
                                  _BuildCurrentUserContainer(
                                    currentUsers,
                                    state.myPosition!,
                                    _currentPeriod,
                                    () => _scrollToCurrentUserPosition(
                                      currentUsers,
                                    ),
                                    responsiveInfo,
                                  ),
                                SizedBox(
                                  height: FigmaConverter.height(context, 10),
                                ),
                                BuildLeaderBoardList(
                                  users: currentUsers,
                                  scrollController: _scrollController,
                                  responsiveInfo: responsiveInfo,
                                  itemKeys: _itemKeys,
                                ),
                              ],
                            ),
                          );
                        }

                        return SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BuildCurrentUserContainer extends StatelessWidget {
  const _BuildCurrentUserContainer(
    this.users,
    this.myPosition,
    this.period,
    this.onLeaderboardPressed,
    this.responsiveInfo,
  );
  final List<LeaderboardUser> users;
  final MyPositionModel myPosition;
  final String period;
  final VoidCallback? onLeaderboardPressed;
  final ResponsiveInfo responsiveInfo;

  @override
  Widget build(BuildContext context) {
    int userRank = 0;
    int userXP = 0;

    switch (period) {
      case 'weekly':
        userRank = myPosition.weekly?.rank ?? 0;
        userXP = myPosition.weekly?.totalXP ?? 0;
        break;
      case 'monthly':
        userRank = myPosition.monthly?.rank ?? 0;
        userXP = myPosition.monthly?.totalXP ?? 0;
        break;
      case 'alltime':
        userRank = myPosition.alltime?.rank ?? 0;
        userXP = myPosition.alltime?.totalXP ?? 0;
        break;
    }
    log('User Rank: $userRank, User XP: $userXP for period: $period');

    return GestureDetector(
      onTap: () {
        onLeaderboardPressed?.call();
      },
      child: Container(
        padding: FigmaConverter.padding(
          context,
          left: 16,
          right: 16,
          top: 15,
          bottom: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(
            FigmaConverter.width(context, 60),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: FigmaConverter.width(context, 12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.yourCurrentRank,
                    style: AppTextStyles.baseBold(context, color: Colors.white)
                        .copyWith(
                          fontSize: FigmaConverter.fontSize(
                            context,
                            14,
                            min: 12,
                            max: 18,
                          ),
                        ),
                  ),
                ],
              ),
            ),
            Text(
              userRank > 0 ? '$userRank' : '--',
              style: AppTextStyles.baseBold(context, color: Colors.white)
                  .copyWith(
                    fontSize: FigmaConverter.fontSize(
                      context,
                      16,
                      min: 14,
                      max: 18,
                    ),
                  ),
            ),
            SizedBox(width: FigmaConverter.width(context, 8)),
            Container(
              padding: FigmaConverter.padding(
                context,
                left: 8,
                right: 8,
                top: 8,
                bottom: 8,
              ),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: responsiveInfo.isTablet
                    ? FigmaConverter.width(context, 28)
                    : FigmaConverter.width(context, 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildLeaderBoardList extends StatelessWidget {
  const BuildLeaderBoardList({
    super.key,
    required this.users,
    required this.scrollController,
    required this.responsiveInfo,
    required this.itemKeys,
  });

  final List<LeaderboardUser> users;
  final ScrollController scrollController;
  final ResponsiveInfo responsiveInfo;
  final Map<int, GlobalKey> itemKeys;

  @override
  Widget build(BuildContext context) {
    final listUsers = users.where((user) => user.rank > 3).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(FigmaConverter.width(context, 25)),
      ),
      child: ListView.separated(
        controller: null,
        itemCount: listUsers.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => Divider(
          thickness: 1,
          color: AppColors.blueGray100,
          indent: 16,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          final user = listUsers[index];
          final isCurrentUser = user.isCurrentUser;
          if (!itemKeys.containsKey(index)) {
            itemKeys[index] = GlobalKey();
          }

          return Container(
            key: itemKeys[index],
            height: FigmaConverter.height(context, 70, min: 60, max: 90),
            padding: FigmaConverter.symmetricPadding(
              context,
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? const Color(0xFF6C5CE7).withValues(alpha: 0.1)
                  : Colors.transparent,
              border: isCurrentUser
                  ? Border.all(color: const Color(0xFF6C5CE7), width: 2)
                  : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  "${user.rank}.",
                  style:
                      AppTextStyles.smSemiBold(
                        context,
                        color: isCurrentUser
                            ? const Color(0xFF6C5CE7)
                            : AppColors.blueGray900,
                      ).copyWith(
                        fontSize: FigmaConverter.fontSize(
                          context,
                          14,
                          min: 12,
                          max: 16,
                        ),
                      ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: responsiveInfo.isTablet
                      ? FigmaConverter.width(context, 26)
                      : FigmaConverter.width(context, 22),
                  backgroundColor: Colors.grey[300],
                  backgroundImage: user.avatar.startsWith('http')
                      ? NetworkImage(user.avatar)
                      : AssetImage(user.avatar) as ImageProvider,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    user.name,
                    style:
                        AppTextStyles.baseMedium(
                          context,
                          color: isCurrentUser
                              ? const Color(0xFF6C5CE7)
                              : AppColors.blueGray900,
                        ).copyWith(
                          fontSize: FigmaConverter.fontSize(
                            context,
                            14,
                            min: 12,
                            max: 16,
                          ),
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    Image(image: AssetImage(Assets.images.smallXp.path)),
                    Text(
                      formatScore(user.xp),
                      style:
                          AppTextStyles.baseSemiBold(
                            context,
                            color: isCurrentUser
                                ? const Color(0xFF6C5CE7)
                                : Colors.grey[600],
                          ).copyWith(
                            fontSize: FigmaConverter.fontSize(
                              context,
                              14,
                              min: 12,
                              max: 18,
                            ),
                          ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
