import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/features/battles/view/play_in_group/join_room_modal.dart';
import 'package:learnwayv2/features/battles/view/play_in_group/play_in_group_screen.dart';
import 'dart:async';

class JoinWaitingRoomModal extends StatefulWidget {
  final String roomCode;
  final int entryFees;
  final VoidCallback? onBattleStarted;

  const JoinWaitingRoomModal({
    super.key,
    required this.roomCode,
    required this.entryFees,
    this.onBattleStarted,
  });

  @override
  State<JoinWaitingRoomModal> createState() => _JoinWaitingRoomModalState();
}

class _JoinWaitingRoomModalState extends State<JoinWaitingRoomModal> {
  Timer? _timer;

  final List<Map<String, String>> _groupPlayers = [
    {'name': 'PLAYER 2', 'avatar': 'assets/images/battles/image_14.png'},
    {'name': 'PLAYER 3', 'avatar': 'assets/images/battles/image_14.png'},
    {'name': 'PLAYER 4', 'avatar': 'assets/images/battles/image_14.png'},
  ];

  @override
  void initState() {
    super.initState();
    _startSimulation();
  }

  void _startSimulation() {
    final List<Duration> delays = [
      const Duration(seconds: 2),
      const Duration(seconds: 4),
      const Duration(seconds: 6),
    ];

    final List<String> names = ['Kwaku01', 'Chi_God', 'Nakamoto'];
    final List<String> avatars = [
      'assets/avatars/female1.png',
      'assets/avatars/male3.png',
      'assets/avatars/male4.png',
    ];

    for (int i = 0; i < delays.length; i++) {
      Future.delayed(delays[i], () {
        if (mounted) {
          setState(() {
            _groupPlayers[i] = {'name': names[i], 'avatar': avatars[i]};

            if (i == delays.length - 1) {
              _timer = Timer(Duration(seconds: 3), () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        PlayInGroupScreen(autoStartCountdown: true),
                  ),
                );
              });
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 750,
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21),
          child: Column(
            children: [
              Column(
                children: [
                  const VSpace(25),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => JoinRoomModal(
                              onBattleStarted: widget.onBattleStarted,
                            ),
                          );
                        },
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
                        'Waiting Room',
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
                      'Topic: History and Evolution of Money',
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
                            'Entry Fees:',
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
                    _buildGroupPlayerCard(
                      avatarPath: 'assets/avatars/male1.png',
                      name: 'Me',
                      isCurrentUser: true,
                      isFirst: true,
                    ),

                    ..._groupPlayers.asMap().entries.map((entry) {
                      final index = entry.key;
                      final player = entry.value;
                      final isLast = index == _groupPlayers.length - 1;
                      final hasJoined = player['name'] != 'PLAYER ${index + 2}';

                      return Column(
                        children: [
                          _buildDivider(),

                          _buildGroupPlayerCard(
                            avatarPath: player['avatar']!,
                            name: player['name']!,
                            isCurrentUser: false,
                            isLast: isLast,
                            showLoading: !hasJoined,
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),

              const VSpace(60),

              Column(
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3.75,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryColor,
                        ),
                        backgroundColor: AppColors.blueGray50,
                      ),
                    ),
                  ),

                  const VSpace(35),

                  Text(
                    'Wait a moment',
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.12,
                      letterSpacing: 0.20,
                    ),
                  ),

                  const VSpace(10),

                  Text(
                    'Creator will start and the Quiz will begin.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.gray700,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1,
                      letterSpacing: 0.20,
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

  Widget _buildGroupPlayerCard({
    required String avatarPath,
    required String name,
    required bool isCurrentUser,
    bool isFirst = false,
    bool isLast = false,
    bool showLoading = false,
  }) {
    EdgeInsets padding;
    if (isFirst) {
      padding = const EdgeInsets.only(bottom: 15);
    } else if (isLast) {
      padding = const EdgeInsets.only(top: 15);
    } else {
      padding = const EdgeInsets.symmetric(vertical: 15);
    }

    return Padding(
      padding: padding,
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.asset(
                avatarPath,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
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
                  isCurrentUser ? 'CREATOR' : 'PLAYER',
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

          if (showLoading && !isCurrentUser)
            SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryColor,
                ),
                backgroundColor: const Color(0xFFEAECF5),
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
