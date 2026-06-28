import 'dart:async';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/battles/bloc/battles_bloc.dart';
import 'package:learnwayv2/features/battles/data/battle_data_source.dart';
import 'package:learnwayv2/features/battles/models/battle_room_participant.dart';
import 'package:learnwayv2/features/battles/services/battle_event_service.dart';
import 'package:learnwayv2/features/battles/view/shared/leave_game_dialog.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';

class PlayWithFriendWaitingRoomModal extends StatefulWidget {
  const PlayWithFriendWaitingRoomModal({
    super.key,
    required this.battleId,
    required this.roomCode,
    required this.entryFees,
    required this.topicTitle,
    this.onBattleStarted,
    this.isGroupBattle = false,
  });

  final String battleId;
  final String roomCode;
  final int entryFees;
  final String topicTitle;
  final VoidCallback? onBattleStarted;
  final bool isGroupBattle;
  @override
  State<PlayWithFriendWaitingRoomModal> createState() =>
      _PlayWithFriendWaitingRoomModalState();
}

class _PlayWithFriendWaitingRoomModalState
    extends State<PlayWithFriendWaitingRoomModal> {
  List<BattleRoomParticipant> _joinedPlayers = [];
  bool _isRoomFull = false;
  bool _proceedingToBattle = false;
  bool _codeCopied = false;
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  final _shareButtonKey = GlobalKey();

  bool get _hasOpponent => _joinedPlayers.isNotEmpty;

  bool get _isCreator {
    final currentUserId = LocalStorageService.getUserSync()?.id;
    final participants = locator<BattleEventService>().participants;
    if (participants.isEmpty || currentUserId == null) return true;
    final me = participants.firstWhere(
      (p) => p.userId == currentUserId,
      orElse: () => participants.first,
    );
    return me.role.toUpperCase() == 'CREATOR';
  }

  @override
  void initState() {
    super.initState();
    _initBattleEvents();
  }

  Future<void> _initBattleEvents() async {
    final battleService = locator<BattleEventService>();
    await battleService.connect(widget.battleId);

    final currentUserId = LocalStorageService.getUserSync()?.id;

    _subscriptions.addAll([
      battleService.onRoomUpdated.listen((event) {
        if (!mounted) return;
        log(
          '[WaitingRoom] onRoomUpdated — participants: ${event.participants.map((p) => p.username).toList()}',
        );
        setState(() {
          _joinedPlayers = event.participants
              .where((p) => p.userId != currentUserId)
              .toList();
        });
      }),
      battleService.onRoomFull.listen((event) {
        if (!mounted) return;
        log('[WaitingRoom] onRoomFull — room is full');
        setState(() {
          _isRoomFull = true;
          _joinedPlayers = event.participants
              .where((p) => p.userId != currentUserId)
              .toList();
        });
      }),
    ]);
  }

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    if (!_proceedingToBattle) {
      locator<BattleEventService>().disconnect();
    }
    super.dispose();
  }

  Future<void> _onLeave(BuildContext context) async {
    try {
      await locator<BattleDataSource>().deleteBattle(widget.battleId);
    } catch (e) {
      log('[WaitingRoom] deleteBattle error: $e');
    }
    locator<BattleEventService>().disconnect();
    if (context.mounted) Navigator.of(context).pop();
  }

  void _showLeaveDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    LeaveGameDialog.show(
      context,
      title: _isCreator ? l10n.cancelRoom : l10n.leaveRoomConfirmation,
      description: _isCreator ? l10n.cancelRoomDescription : null,
      onLeave: () {
        Navigator.of(context).pop();
        _onLeave(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = LocalStorageService.getUserSync();
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showLeaveDialog(context);
      },
      child: BlocConsumer<BattlesBloc, BattlesState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            width: 412,
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Column(
              children: [
                Column(
                  children: [
                    const VSpace(25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 21),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => _showLeaveDialog(context),
                            child: SvgPicture.asset(
                              'assets/icons/battles/chevron.right.svg',
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
                    ),
                    const VSpace(17),
                    Container(height: 1, color: AppColors.borderLight),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 21),
                    child: Column(
                      children: [
                        const VSpace(20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 20,
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
                                l10n.battleTopic(widget.topicTitle),
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
                                      'assets/images/blue_gem.png',
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
                                        height: 1.50,
                                        letterSpacing: 0.20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const VSpace(13),
                              Container(
                                height: 1,
                                color: AppColors.borderColor,
                              ),
                              const VSpace(13),
                              Text(
                                l10n.inviteCode,
                                style: TextStyle(
                                  color: AppColors.gray800,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  height: 1.14,
                                  letterSpacing: 0.20,
                                ),
                              ),
                              const VSpace(5),
                              Text(
                                l10n.shareCodeWithFriend,
                                style: TextStyle(
                                  color: AppColors.gray500,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  height: 1,
                                  letterSpacing: 0.20,
                                ),
                              ),
                              const VSpace(13),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.blueGray100,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.roomCode,
                                      style: TextStyle(
                                        color: AppColors.textDark,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            await Clipboard.setData(
                                              ClipboardData(
                                                text: widget.roomCode,
                                              ),
                                            );
                                            if (mounted) {
                                              setState(
                                                () => _codeCopied = true,
                                              );
                                              Future.delayed(
                                                const Duration(seconds: 2),
                                                () {
                                                  if (mounted) {
                                                    setState(
                                                      () => _codeCopied = false,
                                                    );
                                                  }
                                                },
                                              );
                                            }
                                          },
                                          child: Container(
                                            width: 38,
                                            height: 38,
                                            decoration: const BoxDecoration(
                                              color: Colors.black,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: SvgPicture.asset(
                                                'assets/icons/copy_icon.svg',
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                      Colors.white,
                                                      BlendMode.srcIn,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const HSpace(5),
                                        GestureDetector(
                                          key: _shareButtonKey,
                                          onTap: () async {
                                            try {
                                              final box =
                                                  _shareButtonKey.currentContext
                                                          ?.findRenderObject()
                                                      as RenderBox?;
                                              final origin = box != null
                                                  ? box.localToGlobal(
                                                          Offset.zero,
                                                        ) &
                                                        box.size
                                                  : null;
                                              await SharePlus.instance.share(
                                                ShareParams(
                                                  text: l10n
                                                      .battleShareInviteText(
                                                        widget.roomCode,
                                                        widget.topicTitle,
                                                        '${widget.entryFees}',
                                                      ),
                                                  sharePositionOrigin: origin,
                                                ),
                                              );
                                            } catch (e) {
                                              log(
                                                '[WaitingRoom] Share error: $e',
                                              );
                                            }
                                          },
                                          child: Container(
                                            width: 38,
                                            height: 38,
                                            decoration: const BoxDecoration(
                                              color: Colors.black,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: SvgPicture.asset(
                                                'assets/icons/share_icon.svg',
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                      Colors.white,
                                                      BlendMode.srcIn,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const VSpace(20),
                        if (_isRoomFull) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6F4EA),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: Color(0xFF2E7D32),
                                  size: 18,
                                ),
                                const HSpace(8),
                                Text(
                                  l10n.roomFullReadyToStart,
                                  style: TextStyle(
                                    color: const Color(0xFF2E7D32),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const VSpace(12),
                        ],
                        if (_codeCopied) ...[
                          Text(
                            'Invite code copied',
                            style: TextStyle(
                              color: AppColors.textDark,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.12,
                              letterSpacing: 0.20,
                            ),
                          ),
                          const VSpace(10),
                        ],
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
                                role: l10n.creatorRole,
                                isCurrentUser: true,
                                profileImageUrl: currentUser?.profileImageUrl,
                              ),
                              ..._joinedPlayers.map(
                                (player) => Column(
                                  children: [
                                    const VSpace(15),
                                    Container(
                                      height: 1,
                                      color: AppColors.borderColor,
                                    ),
                                    const VSpace(15),
                                    _buildPlayerRow(
                                      name: player.username,
                                      role: player.role,
                                      isCurrentUser: false,
                                      profileImageUrl: player.profileImageUrl,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const VSpace(20),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(
                    left: 21,
                    right: 21,
                    bottom: MediaQuery.of(context).viewPadding.bottom,
                  ),
                  child: Column(
                    children: [
                      const VSpace(20),
                      Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          color: _isRoomFull
                              ? AppColors.gray900
                              : _hasOpponent
                              ? Colors.black
                              : AppColors.gray10,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _isRoomFull
                                ? () {
                                    _proceedingToBattle = true;
                                    Navigator.of(context).pop();
                                    context.router.push(
                                      BattleReadyRoute(
                                        battleId: widget.battleId,
                                      ),
                                    );
                                  }
                                : null,
                            borderRadius: BorderRadius.circular(60),
                            child: Center(
                              child: Text(
                                _isRoomFull
                                    ? l10n.next
                                    : l10n.waitingForPlayers,
                                style: TextStyle(
                                  color: _hasOpponent
                                      ? Colors.white
                                      : AppColors.gray700,
                                  fontSize: _hasOpponent ? 14 : 16,
                                  fontWeight: FontWeight.w600,
                                  height: _hasOpponent ? 1.14 : 1.125,
                                  letterSpacing: 0.20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const VSpace(20),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlayerRow({
    required String name,
    required String role,
    required bool isCurrentUser,
    String? profileImageUrl,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
                    placeholder: (_, _) =>
                        const Icon(Icons.person, color: Colors.white, size: 28),
                    errorWidget: (_, _, _) =>
                        const Icon(Icons.person, color: Colors.white, size: 28),
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
                  color: AppColors.gray700,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
