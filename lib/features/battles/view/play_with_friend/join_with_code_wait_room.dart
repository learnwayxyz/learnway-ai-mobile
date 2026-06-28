import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:sentry/sentry.dart';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/battles/data/battle_data_source.dart';
import 'package:learnwayv2/features/battles/models/battle_room_participant.dart';
import 'package:learnwayv2/features/battles/models/join_room_response.dart';
import 'package:learnwayv2/features/battles/services/battle_event_service.dart';
import 'package:learnwayv2/features/battles/view/shared/leave_game_dialog.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/shared/loader/circular_progress_painter.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';

class PlayWithFriendJoinWaitingRoomModal extends StatefulWidget {
  final String battleId;
  final int entryFees;
  final List<JoinRoomParticipant> initialParticipants;
  final VoidCallback? onBattleStarted;

  const PlayWithFriendJoinWaitingRoomModal({
    super.key,
    required this.battleId,
    required this.entryFees,
    required this.initialParticipants,
    this.onBattleStarted,
  });

  @override
  State<PlayWithFriendJoinWaitingRoomModal> createState() =>
      _PlayWithFriendJoinWaitingRoomModalState();
}

class _PlayWithFriendJoinWaitingRoomModalState
    extends State<PlayWithFriendJoinWaitingRoomModal>
    with TickerProviderStateMixin {
  List<BattleRoomParticipant> _participants = [];
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  String? _topicName;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _controller.repeat();
    _participants = widget.initialParticipants
        .map(
          (p) => BattleRoomParticipant(
            userId: p.userId,
            role: p.role == JoinRoomRole.creator ? 'CREATOR' : 'PLAYER',
            username: p.username,
            profileImageUrl: p.profileImageUrl,
          ),
        )
        .toList();
    _initBattleEvents();
    _fetchTopicName();
  }

  Future<void> _fetchTopicName() async {
    try {
      final detail = await locator<BattleDataSource>().getBattleHistoryDetail(
        widget.battleId,
      );
      if (mounted) setState(() => _topicName = detail.topicName);
    } catch (_) {}
  }

  Future<void> _initBattleEvents() async {
    final battleService = locator<BattleEventService>();
    await battleService.connect(widget.battleId);
    battleService.participants = List.of(_participants);

    _subscriptions.addAll([
      battleService.onRoomUpdated.listen((event) {
        if (!mounted) return;
        log(
          '[JoinWaiting] room:updated — participants: ${event.participants.length}',
        );
        setState(() => _participants = event.participants);
      }),

      battleService.onRoomFull.listen((event) {
        if (!mounted) return;
        log('[JoinWaiting] room:full');
        setState(() => _participants = event.participants);
      }),

      battleService.onCountdown.listen((event) {
        log('[JoinWaiting] countdown: ${event.count}');
        Sentry.addBreadcrumb(
          Breadcrumb(
            message:
                '[JoinWaiting] Countdown received: ${event.count} — navigating to BattleReadyScreen',
            category: 'battle.countdown',
            level: SentryLevel.info,
            data: {
              'battleId': widget.battleId,
              'count': event.count,
              'mounted': mounted,
            },
          ),
        );
        if (!mounted) {
          Sentry.addBreadcrumb(
            Breadcrumb(
              message:
                  '[JoinWaiting] Countdown received but widget not mounted — navigation skipped',
              category: 'battle.countdown',
              level: SentryLevel.warning,
              data: {'battleId': widget.battleId, 'count': event.count},
            ),
          );
          return;
        }
        context.router.pushAndPopUntil(
          BattleReadyRoute(battleId: widget.battleId),
          predicate: (route) => false,
        );
      }),
    ]);
  }

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _controller.dispose();
    super.dispose();
  }

  void _showLeaveDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    LeaveGameDialog.show(
      context,
      title: l10n.leaveRoomConfirmation,
      onLeave: () {
        Navigator.of(context).pop();
        locator<BattleEventService>().disconnect();
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = LocalStorageService.getUserSync();
    final displayParticipants = _participants.isNotEmpty
        ? _participants
        : locator<BattleEventService>().participants;
    final creator = displayParticipants
        .cast<BattleRoomParticipant?>()
        .firstWhere(
          (p) => p?.role.toUpperCase() == 'CREATOR',
          orElse: () => null,
        );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showLeaveDialog(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  const VSpace(25),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _showLeaveDialog(context),
                        child: SvgPicture.asset(
                          Assets.icons.battles.chevronRight,
                          width: 9,
                          height: 15,
                          colorFilter: const ColorFilter.mode(
                            Colors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        l10n.waitingRoom,
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.12,
                          letterSpacing: 0.20,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 9),
                    ],
                  ),
                  const VSpace(15),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: AppColors.borderColor,
                  ),
                ],
              ),
              const VSpace(28),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 21,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowColor,
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.battleTopic(_topicName ?? ''),
                      style: TextStyle(
                        color: AppColors.gray800,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.14,
                        letterSpacing: 0.20,
                      ),
                    ),

                    const VSpace(10),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.blueGray100,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.entryFees,
                            style: TextStyle(
                              color: AppColors.textPrimaryDark,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              height: 1,
                              letterSpacing: 0.20,
                            ),
                          ),
                          const HSpace(4),
                          Image.asset(
                            Assets.images.blueGem.path,
                            width: 20,
                            height: 20,
                          ),
                          const HSpace(4),
                          Text(
                            '${widget.entryFees}',
                            style: TextStyle(
                              color: AppColors.textDark,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                              letterSpacing: 0.20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const VSpace(20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildPlayerRow(
                      name: currentUser?.username ?? 'Me',
                      role: l10n.playerRole,
                      isCurrentUser: true,
                      profileImageUrl: currentUser?.profileImageUrl,
                      isFirst: true,
                    ),
                    _buildDivider(),
                    _buildPlayerRow(
                      name: creator?.username ?? '...',
                      role: l10n.creatorRole,
                      isCurrentUser: false,
                      profileImageUrl: creator?.profileImageUrl,
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const VSpace(60),
              Column(
                children: [
                  Center(
                    child: AnimatedBuilder(
                      animation: _rotationAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotationAnimation.value,
                          child: CustomPaint(
                            size: const Size(48, 48),
                            painter: CircularProgressPainter(progress: 0.25),
                          ),
                        );
                      },
                    ),
                  ),
                  const VSpace(35),
                  Text(
                    l10n.waitAMoment,
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.12,
                      letterSpacing: 0.20,
                    ),
                  ),
                  const VSpace(10),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewPadding.bottom,
                    ),
                    child: Text(
                      l10n.creatorWillStart,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.gray700,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1,
                        letterSpacing: 0.20,
                      ),
                    ),
                  ),
                  const VSpace(40),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerRow({
    required String name,
    required String role,
    required bool isCurrentUser,
    String? profileImageUrl,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final padding = isFirst
        ? const EdgeInsets.only(bottom: 15)
        : isLast
        ? const EdgeInsets.only(top: 15)
        : const EdgeInsets.symmetric(vertical: 15);

    return Padding(
      padding: padding,
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isCurrentUser ? AppColors.primaryColor : AppColors.gray300,
              borderRadius: BorderRadius.circular(25),
            ),
            child: profileImageUrl != null && profileImageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: CachedNetworkImage(
                      imageUrl: profileImageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 28,
                      ),
                      errorWidget: (_, _, _) => const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  )
                : const Icon(Icons.person, color: Colors.white, size: 28),
          ),
          const HSpace(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.14,
                    letterSpacing: 0.20,
                  ),
                ),
                const VSpace(4),
                Text(
                  role,
                  style: TextStyle(
                    color: AppColors.gray500,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      width: double.infinity,
      color: AppColors.borderLight,
    );
  }
}
