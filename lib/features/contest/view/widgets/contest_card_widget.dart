import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/contest/model/all_contest_model.dart';
import 'package:learnwayv2/features/home/enums/card_type.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';
import 'package:learnwayv2/shared/widgets/card_component/over_lays/lesson_overlays.dart';

class ContestCard extends StatelessWidget {
  const ContestCard({
    super.key,
    required this.contest,
    required this.onTap,
    required this.onActionButtonTap,
    this.cardMargin = const EdgeInsets.only(bottom: 16),
    this.cardPadding = const EdgeInsets.all(16),
    this.imageHeight = 160,
    this.borderRadius = 12.0,
    this.failedToStartContest = false,
    this.isRetrying = false,
  });

  final Contest contest;
  final Function onTap;
  final Function onActionButtonTap;
  final EdgeInsets cardMargin;
  final EdgeInsets cardPadding;
  final double imageHeight;
  final double borderRadius;
  final bool failedToStartContest;
  final bool isRetrying;

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('dd MMM yyyy').format(dateTime).toUpperCase();
  }

  String _getActionButtonText(bool hasAlreadyJoined) {
    switch (contest.contestStatus) {
      case ContestStatus.ongoing:
        if (hasAlreadyJoined ||
            (contest.userState?.hasStarted ?? false) ||
            (contest.userState?.hasCompleted ?? false)) {
          return 'View Results';
        }
        return 'Start Quiz';
      case ContestStatus.upcoming:
        return 'See Details';
      case ContestStatus.finished:
        return 'View Results';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: InkWell(
        onTap: () => onTap(),
        borderRadius: BorderRadius.circular(borderRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  child: SizedBox(
                    width: double.infinity,
                    height: imageHeight,
                    child: (contest.bannerImageUrl?.isNotEmpty ?? false)
                        ? Image.network(
                            contest.bannerImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.gray200,
                                child: Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: AppColors.gray600,
                                    size: 40,
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            color: AppColors.gray200,
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: AppColors.gray600,
                                size: 40,
                              ),
                            ),
                          ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 11,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      color: contest.contestStatus == ContestStatus.ongoing
                          ? Color(0xff045839).withValues(alpha: .7)
                          : contest.contestStatus == ContestStatus.upcoming
                          ? Color(0xff0A5581).withValues(alpha: .7)
                          : Color(0xff7F1B17).withValues(alpha: .7),
                    ),
                    child: Text(
                      contest.contestStatus.name[0].toUpperCase() +
                          contest.contestStatus.name.substring(1),
                      style: AppTextStyles.xsSemiBold(
                        context,
                        color: contest.contestStatus == ContestStatus.ongoing
                            ? AppColors.success100
                            : contest.contestStatus == ContestStatus.upcoming
                            ? AppColors.blueLight100
                            : AppColors.error100,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            VSpace(16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        contest.contestStatus.name,
                        style: AppTextStyles.sm(context).copyWith(
                          color: AppColors.gray600,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      _formatDate(DateTime.tryParse(contest.startDate ?? '')),
                      style: AppTextStyles.sm(context).copyWith(
                        color: AppColors.gray600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                VSpace(8),
                Text(
                  contest.title ?? '',
                  style: AppTextStyles.baseBold(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                VSpace(12),
                Divider(color: AppColors.gray300, thickness: 1, height: 1),
                VSpace(12),
                Row(
                  children: [
                    contest.contestStatus == ContestStatus.upcoming
                        ? _buildInfoContainer(
                            context: context,
                            icon: Image(
                              image: AssetImage(
                                Assets.images.contestDiamond.path,
                              ),
                              height: 18,
                              width: 18,
                            ),
                            label: 'Fees',
                            value: contest.entryFee.toString(),
                          )
                        : contest.contestStatus == ContestStatus.finished
                        ? SizedBox.shrink()
                        : _buildInfoContainer(
                            context: context,
                            icon: Image.asset(
                              Assets.images.contestDiamond.path,
                              height: 18,
                              width: 18,
                            ),
                            label: 'Fees',
                            value: contest.entryFee.toString(),
                          ),

                    contest.contestStatus == ContestStatus.upcoming
                        ? SizedBox(width: 12)
                        : contest.contestStatus == ContestStatus.finished
                        ? SizedBox(width: 0)
                        : SizedBox(width: 12),
                    contest.contestStatus == ContestStatus.upcoming
                        ? SizedBox.shrink()
                        : contest.contestStatus == ContestStatus.finished
                        ? _participantInfo(context)
                        : _participantInfo(context),
                    Spacer(),
                    failedToStartContest
                        ? ButtonFactory.blackButton(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            onPressed: () {
                              if (!isRetrying) {
                                onActionButtonTap();
                              }
                            },
                            child: isRetrying
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Try Again',
                                    style: AppTextStyles.smBold(
                                      context,
                                    ).copyWith(color: Colors.white),
                                  ),
                          )
                        : ButtonFactory.blackButton(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            onPressed: () {
                              onActionButtonTap();
                            },
                            text: _getActionButtonText(contest.hasJoined),
                            textStyle: AppTextStyles.smBold(
                              context,
                            ).copyWith(color: Colors.white),
                          ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoContainer({
    required Widget icon,
    required String label,
    required String value,
    required BuildContext context,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.blueGray100,
        borderRadius: BorderRadius.circular(60),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$label:',
                style: AppTextStyles.smBold(
                  context,
                ).copyWith(fontSize: 10, color: AppColors.gray600),
              ),
              icon,
              HSpace(2),
              Flexible(
                child: Text(
                  value,
                  style: AppTextStyles.smBold(context),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _participantInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),

      decoration: BoxDecoration(
        color: AppColors.blueGray100,
        borderRadius: BorderRadius.circular(60),
      ),
      child: Row(
        children: [
          SvgPicture.asset(Assets.icons.participantIcon, height: 18, width: 18),
          HSpace(4),
          Text(
            contest.participantCount.toString(),
            style: AppTextStyles.smBold(context),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class ContestListBuilder extends StatefulWidget {
  const ContestListBuilder({
    super.key,
    required this.contests,
    this.onContestTap,
    this.onActionButtonTap,
    this.padding = const EdgeInsets.all(16),
    this.physics,
    this.shrinkWrap = false,
    this.scrollController,
    this.failedContestId,
    this.isRetrying = false,
    this.hideJoinedAndCompleted = false,
  });

  final List<Contest> contests;
  final Function(Contest)? onContestTap;
  final Function(Contest)? onActionButtonTap;
  final EdgeInsets padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final ScrollController? scrollController;
  final String? failedContestId;
  final bool isRetrying;
  final bool hideJoinedAndCompleted;

  @override
  State<ContestListBuilder> createState() => _ContestListBuilderState();
}

class _ContestListBuilderState extends State<ContestListBuilder> {
  final Map<String, DateTime?> _endDateCache = {};
  List<Contest>? _cachedFilteredContests;
  List<Contest>? _previousContests;
  bool? _previousHideJoinedAndCompleted;

  DateTime? _getEndDate(Contest contest) {
    final contestId = contest.id ?? '';
    if (!_endDateCache.containsKey(contestId)) {
      _endDateCache[contestId] = contest.endDate != null
          ? DateTime.tryParse(contest.endDate!)
          : null;
    }
    return _endDateCache[contestId];
  }

  bool _shouldHideContest(Contest contest, DateTime now) {
    final isFinishedAndPastEndDate =
        contest.contestStatus == ContestStatus.finished &&
        (_getEndDate(contest)?.isBefore(now) ?? false);

    return isFinishedAndPastEndDate;
  }

  List<Contest> _getFilteredContests() {
    if (_cachedFilteredContests != null &&
        _previousContests == widget.contests &&
        _previousHideJoinedAndCompleted == widget.hideJoinedAndCompleted) {
      return _cachedFilteredContests!;
    }

    if (_previousContests != widget.contests) {
      _endDateCache.clear();
    }

    final sortedcontests = [...widget.contests]
      ..sort((a, b) {
        if (a.type == ContestType.private && b.type != ContestType.private) {
          return -1;
        }
        if (a.type != ContestType.private && b.type == ContestType.private) {
          return 1;
        }
        return 0;
      });

    final now = DateTime.now();
    final availableContests = widget.hideJoinedAndCompleted
        ? sortedcontests
              .where((contest) => !_shouldHideContest(contest, now))
              .toList()
        : sortedcontests;

    _cachedFilteredContests = availableContests;
    _previousContests = widget.contests;
    _previousHideJoinedAndCompleted = widget.hideJoinedAndCompleted;

    return availableContests;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.contests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 64,
              color: AppColors.gray400,
            ),
            VSpace(16),
            Text(
              'No contests available',
              style: AppTextStyles.base(
                context,
              ).copyWith(color: AppColors.gray600),
            ),
          ],
        ),
      );
    }

    final availableContests = _getFilteredContests();

    if (availableContests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 64,
              color: AppColors.gray400,
            ),
            VSpace(16),
            Text(
              'No contests available',
              style: AppTextStyles.base(
                context,
              ).copyWith(color: AppColors.gray600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: widget.padding,
      physics: widget.physics,
      controller: widget.scrollController,
      shrinkWrap: widget.shrinkWrap,
      itemCount: availableContests.length,
      itemBuilder: (context, index) {
        final contest = availableContests[index];

        if (contest.type == ContestType.private) {
          // Determine button text based on contest status
          String buttonText = 'Enter Contest';
          if (contest.userState?.hasCompleted == true) {
            buttonText = 'View Results';
          }

          return CardFactory.lessonCard(
            title: contest.title,
            margin: EdgeInsets.only(bottom: 20),
            cardType: CardType.others,
            dynamicOverlays: {
              CardType.others: [
                OverlayConfig(
                  assetPath: Assets.images.lockContest.path,
                  right: 5,
                  bottom: 30,
                  height: 110,
                  width: 110,
                  fit: BoxFit.contain,
                ),
              ],
            },
            buttonText: buttonText,
            subtitle: 'Join privately to battle',
            gradient: AppColors.purpleGradient,
            onButtonPressed: () => widget.onActionButtonTap?.call(contest),
          );
        }

        if (contest.type != ContestType.private) {
          return ContestCard(
            contest: contest,
            onTap: () => widget.onContestTap?.call(contest),
            onActionButtonTap: () => widget.onActionButtonTap?.call(contest),
            failedToStartContest: widget.failedContestId == contest.id,
            isRetrying:
                widget.failedContestId == contest.id && widget.isRetrying,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
