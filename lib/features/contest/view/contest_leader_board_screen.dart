import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/contest/cubit/leader_board_cubit.dart';
import 'package:learnwayv2/features/contest/model/contest_leaderboard_response.dart';
import 'package:learnwayv2/features/contest/view/widgets/contest_leaderboard_shimmer.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/services/websocket/websocket_service.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';

@RoutePage()
class ContestLeaderBoardScreen extends StatefulWidget {
  const ContestLeaderBoardScreen({
    super.key,
    required this.contestId,
    this.arguments,
  });
  final String contestId;
  final Map<String, dynamic>? arguments;

  @override
  State<ContestLeaderBoardScreen> createState() =>
      _ContestLeaderBoardSScreenState();
}

class _ContestLeaderBoardSScreenState extends State<ContestLeaderBoardScreen> {
  final ScrollController _scrollController = ScrollController();
  late final LeaderBoardCubit _leaderBoardCubit;

  List<LeaderboardUser> _convertToLeaderboardUsers(
    List<ContestLeaderboardParticipant> response,
  ) {
    final users = response
        .where((user) => user.hasCompleted && user.rank != null)
        .map((user) {
          return LeaderboardUser(
            avatar: user.profileImageUrl!,
            isCurrentUser: user.isCurrentUser(_leaderBoardCubit.contestId),
            name: user.username,
            rank: user.rank!,
            score: (user.score ?? 0).toInt(),
            xp: (user.xpEarned ?? 0).toString(),
          );
        })
        .toList();

    users.sort((a, b) => a.rank.compareTo(b.rank));

    return users;
  }

  void _scrollToCurrentUser(List<LeaderboardUser> leaderboardUsers) async {
    await Future.delayed(Duration(milliseconds: 100));

    final listUsers = leaderboardUsers.where((user) => user.rank > 3).toList();

    final currentUserIndex = listUsers.indexWhere((user) => user.isCurrentUser);

    if (currentUserIndex == -1 || !_scrollController.hasClients) return;

    double figmaListItemHeight = 80.0;
    double actualListItemHeight = FigmaConverter.height(
      context,
      figmaListItemHeight,
    );
    double separatorHeight = 1.0;
    double bottomMargin = 8.0;
    double totalItemHeight =
        actualListItemHeight + separatorHeight + bottomMargin;

    double position = currentUserIndex * totalItemHeight;

    double maxScrollExtent = _scrollController.position.maxScrollExtent;
    position = position.clamp(0.0, maxScrollExtent);

    _scrollController.animateTo(
      position,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    _leaderBoardCubit = LeaderBoardCubit(
      websocketService: locator.get<WebsocketService>(),
      contestId: widget.contestId,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _leaderBoardCubit.connectAndListenToLeaderboard();
    });
  }

  @override
  void dispose() {
    _leaderBoardCubit.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, responsiveInfo) {
        return Scaffold(
          appBar: AppBarFactory.standardAppBar(
            title: 'Contest Leaderboard',
            barHeight: 0,
          ),
          body: SafeArea(
            child: BlocBuilder<LeaderBoardCubit, LeaderBoardState>(
              bloc: _leaderBoardCubit,
              builder: (context, leaderboardState) {
                if (leaderboardState is LoadingLeaderBoardState) {
                  return const ContestLeaderboardShimmer();
                }

                if (leaderboardState is LeaderBoardError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Failed to load leaderboard',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            leaderboardState.message,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => _leaderBoardCubit
                                .connectAndListenToLeaderboard(),
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final List<LeaderboardUser> contestWinners =
                    leaderboardState is LeaderBoardLoaded
                    ? _convertToLeaderboardUsers(leaderboardState.participants)
                    : [];

                final int currentUserRank =
                    leaderboardState is LeaderBoardLoaded
                    ? leaderboardState.myRank
                    : 0;

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.zero,
                  itemCount:
                      3 + contestWinners.where((user) => user.rank > 3).length,
                  itemBuilder: (context, index) {
                    final listUsers = contestWinners
                        .where((user) => user.rank > 3)
                        .toList();
                    if (index == 0) {
                      return Padding(
                        padding: FigmaConverter.symmetricPadding(
                          context,
                          horizontal: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: FigmaConverter.height(context, 16),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${widget.arguments?['title'] ?? ''}',
                                  style: AppTextStyles.xs(
                                    context,
                                  ).copyWith(overflow: TextOverflow.ellipsis),
                                  maxLines: 1,
                                ),
                                Text(
                                  DateFormat('dd MMM, yyyy').format(
                                    DateTime.parse(
                                      widget.arguments?['date'] ??
                                          DateTime.now().toString(),
                                    ),
                                  ),
                                  style: AppTextStyles.xs(context).copyWith(
                                    overflow: TextOverflow.ellipsis,
                                    color: AppColors.primary25,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: FigmaConverter.height(context, 8)),
                            Text(
                              '${widget.arguments?['description'] ?? ''}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.gray900,
                              ),
                            ),
                            SizedBox(
                              height: FigmaConverter.height(context, 16),
                            ),
                          ],
                        ),
                      );
                    }
                    if (index == 1) {
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
                            _BuildPodiumSection(contestWinners, responsiveInfo),
                            SizedBox(
                              height: FigmaConverter.height(context, 20),
                            ),
                            _BuildCurrentUserContainer(
                              contestWinners,
                              () => _scrollToCurrentUser(contestWinners),
                              responsiveInfo,
                              currentUserRank,
                            ),
                            SizedBox(
                              height: FigmaConverter.height(context, 20),
                            ),
                          ],
                        ),
                      );
                    }
                    if (index == 2) {
                      return Container(
                        margin: FigmaConverter.symmetricPadding(
                          context,
                          horizontal: 32,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              FigmaConverter.width(context, 25),
                            ),
                            topRight: Radius.circular(
                              FigmaConverter.width(context, 25),
                            ),
                          ),
                        ),
                        child: SizedBox.shrink(),
                      );
                    }
                    final listIndex = index - 3;
                    final user = listUsers[listIndex];
                    final isCurrentUser = user.isCurrentUser;
                    final isLastItem = listIndex == listUsers.length - 1;

                    return Container(
                      margin: FigmaConverter.symmetricPadding(
                        context,
                        horizontal: 32,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: isLastItem
                            ? BorderRadius.only(
                                bottomLeft: Radius.circular(
                                  FigmaConverter.width(context, 25),
                                ),
                                bottomRight: Radius.circular(
                                  FigmaConverter.width(context, 25),
                                ),
                              )
                            : null,
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: FigmaConverter.height(
                              context,
                              80,
                              min: 70,
                              max: 90,
                            ),
                            margin: FigmaConverter.padding(context, bottom: 8),
                            padding: FigmaConverter.symmetricPadding(
                              context,
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: isCurrentUser
                                  ? Border.all(color: Colors.white, width: 2)
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "${user.rank}.",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isCurrentUser
                                        ? const Color(0xFF6C5CE7)
                                        : AppColors.blueGray900,
                                    fontSize: FigmaConverter.fontSize(
                                      context,
                                      14,
                                      min: 14,
                                      max: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                CircleAvatar(
                                  radius: responsiveInfo.isTablet
                                      ? FigmaConverter.width(context, 26)
                                      : FigmaConverter.width(context, 22),
                                  backgroundColor: Colors.grey[300],
                                  child: user.avatar.isNotEmpty
                                      ? ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: user.avatar,
                                            width: responsiveInfo.isTablet
                                                ? FigmaConverter.width(context, 52)
                                                : FigmaConverter.width(context, 44),
                                            height: responsiveInfo.isTablet
                                                ? FigmaConverter.width(context, 52)
                                                : FigmaConverter.width(context, 44),
                                            fit: BoxFit.cover,
                                            errorWidget:
                                                (context, url, error) => Icon(
                                                  Icons.person,
                                                  color: Colors.grey[600],
                                                ),
                                          ),
                                        )
                                      : Icon(
                                          Icons.person,
                                          color: Colors.grey[600],
                                        ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    user.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: isCurrentUser
                                          ? const Color(0xFF6C5CE7)
                                          : AppColors.blueGray900,
                                      fontSize: FigmaConverter.fontSize(
                                        context,
                                        16,
                                        min: 14,
                                        max: 18,
                                      ),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Image(
                                      image: AssetImage(
                                        Assets.images.smallXp.path,
                                      ),
                                    ),
                                    Text(
                                      user.xp,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isCurrentUser
                                            ? const Color(0xFF6C5CE7)
                                            : Colors.grey[600],
                                        fontSize: FigmaConverter.fontSize(
                                          context,
                                          16,
                                          min: 14,
                                          max: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (!isLastItem)
                            Divider(
                              thickness: 1,
                              color: AppColors.blueGray100,
                              indent: 16,
                              endIndent: 16,
                              height: 0,
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _BuildPodiumSection extends StatelessWidget {
  const _BuildPodiumSection(this.users, this.responsiveInfo);
  final List<LeaderboardUser> users;
  final ResponsiveInfo responsiveInfo;

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return SizedBox.shrink();
    }

    double firstPlaceSize = responsiveInfo.isTablet
        ? FigmaConverter.width(context, 120)
        : FigmaConverter.width(context, 117);
    double otherPlacesSize = responsiveInfo.isTablet
        ? FigmaConverter.width(context, 120)
        : FigmaConverter.width(context, 80);

    return Container(
      padding: FigmaConverter.padding(context, left: 0, right: 0, top: 20),
      decoration: BoxDecoration(
        gradient: AppColors.startLessonGradient,
        borderRadius: BorderRadius.circular(FigmaConverter.width(context, 30)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (users.length > 1) ...[
                _BuildPodiumUser(
                  user: users[1],
                  size: otherPlacesSize,
                  medalColor: Color(0xFFC0C0C0),
                  position: "2",
                  responsiveInfo: responsiveInfo,
                ),
                SizedBox(width: FigmaConverter.width(context, 25)),
              ],
              _BuildPodiumUser(
                user: users[0],
                size: firstPlaceSize,
                medalColor: Color(0xFFFFD700),
                position: users[0].rank.toString(),
                responsiveInfo: responsiveInfo,
              ),
              if (users.length > 2) ...[
                SizedBox(width: FigmaConverter.width(context, 25)),
                _BuildPodiumUser(
                  user: users[2],
                  size: otherPlacesSize,
                  medalColor: Color(0xFFCD7F32),
                  position: "3",
                  responsiveInfo: responsiveInfo,
                ),
              ],
            ],
          ),
          SizedBox(height: FigmaConverter.height(context, 20)),
        ],
      ),
    );
  }
}

class _BuildPodiumUser extends StatefulWidget {
  const _BuildPodiumUser({
    required this.medalColor,
    required this.position,
    required this.user,
    required this.size,
    required this.responsiveInfo,
  });
  final LeaderboardUser user;
  final double size;
  final Color medalColor;
  final String position;
  final ResponsiveInfo responsiveInfo;

  @override
  State<_BuildPodiumUser> createState() => _BuildPodiumUserState();
}

class _BuildPodiumUserState extends State<_BuildPodiumUser> {
  String _formatXP(String xpString) {
    String cleanXP = xpString.replaceAll(',', '');
    double xpValue = double.tryParse(cleanXP) ?? 0;

    if (xpValue >= 1000000) {
      double millions = xpValue / 1000000;
      if (millions >= 10) {
        return '${millions.toInt()}M';
      } else {
        return '${millions.toStringAsFixed(1)}M';
      }
    } else if (xpValue >= 1000) {
      double thousands = xpValue / 1000;
      if (thousands >= 10) {
        return '${thousands.toInt()}K';
      } else {
        return '${thousands.toStringAsFixed(1)}K';
      }
    } else {
      return xpValue.toInt().toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isFirstPlace = widget.position == "1";
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: widget.size / 2,
              backgroundColor: Colors.grey[300],
              child: widget.user.avatar.isNotEmpty
                  ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: widget.user.avatar,
                        width: widget.size,
                        height: widget.size,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            Icon(Icons.person, color: Colors.grey[600]),
                      ),
                    )
                  : Icon(Icons.person, color: Colors.grey[600]),
            ),
            Positioned(
              bottom: -5,
              child: Container(
                width: widget.responsiveInfo.isTablet
                    ? FigmaConverter.width(context, 35)
                    : FigmaConverter.width(context, 20),
                height: widget.responsiveInfo.isTablet
                    ? FigmaConverter.width(context, 35)
                    : FigmaConverter.width(context, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    widget.position,
                    style: TextStyle(
                      color: AppColors.gray800,
                      fontWeight: FontWeight.w600,
                      fontSize: FigmaConverter.fontSize(
                        context,
                        11,
                        min: 12,
                        max: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (isFirstPlace) ...[
              Positioned(
                bottom: -15,
                child: Image.asset(Assets.images.firstPlaceBadge.path),
              ),
            ],
          ],
        ),
        SizedBox(height: FigmaConverter.height(context, 30)),
        Text(
          widget.user.name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: FigmaConverter.fontSize(context, 14, min: 12, max: 16),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: FigmaConverter.height(context, 10)),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              FigmaConverter.width(context, 30),
            ),
          ),
          padding: FigmaConverter.padding(
            context,
            left: 10,
            right: 10,
            top: 10,
            bottom: 10,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(Assets.images.smallXp.path),
              SizedBox(width: FigmaConverter.width(context, 2)),
              Flexible(
                child: Text(
                  _formatXP(widget.user.xp),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: FigmaConverter.fontSize(
                      context,
                      14,
                      min: 12,
                      max: 16,
                    ),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BuildCurrentUserContainer extends StatelessWidget {
  const _BuildCurrentUserContainer(
    this.users,
    this.onLeaderboardPressed,
    this.responsiveInfo,
    this.currentUserRank,
  );
  final List<LeaderboardUser> users;
  final Function()? onLeaderboardPressed;
  final ResponsiveInfo responsiveInfo;
  final int currentUserRank;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: FigmaConverter.padding(
        context,
        left: 16,
        right: 16,
        top: 15,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(FigmaConverter.width(context, 60)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
                  'Your Current Rank',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: FigmaConverter.fontSize(
                      context,
                      16,
                      min: 14,
                      max: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            currentUserRank > 0 ? currentUserRank.toString() : '-',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: FigmaConverter.fontSize(context, 16, min: 14, max: 18),
            ),
          ),
          SizedBox(width: FigmaConverter.width(context, 8)),
          GestureDetector(
            onTap: onLeaderboardPressed,
            child: Container(
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
          ),
        ],
      ),
    );
  }
}

class LeaderboardUser {
  LeaderboardUser({
    required this.rank,
    required this.name,
    required this.score,
    required this.avatar,
    this.isCurrentUser = false,
    required this.xp,
  });

  final int rank;
  final String name;
  final int score;
  final String avatar;
  final bool isCurrentUser;
  final String xp;
}
