import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:learnwayv2/features/battles/view/play_with_friend/create_battle_modal.dart';
import 'package:learnwayv2/features/battles/view/play_in_group/join_room_modal.dart';
import 'package:learnwayv2/features/battles/view/shared/leave_game_dialog.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/shared/enums/enums.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/back_button.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

@RoutePage()
class PlayInGroupScreen extends StatefulWidget {
  final bool autoStartCountdown;

  const PlayInGroupScreen({super.key, this.autoStartCountdown = false});

  @override
  State<PlayInGroupScreen> createState() => _PlayInGroupScreenState();
}

class _PlayInGroupScreenState extends State<PlayInGroupScreen>
    with TickerProviderStateMixin {
  bool _battleStarted = false;
  int _countdown = 3;
  Timer? _countdownTimer;
  bool _shouldStartBattle = false;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Initialize animations
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only trigger battle start if we should start battle and haven't started yet
    if (_shouldStartBattle && !_battleStarted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _resetAndStartBattle();
        _shouldStartBattle = false; // Reset the flag
      });
    }

    // Auto-start countdown if requested
    if (widget.autoStartCountdown && !_battleStarted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _resetAndStartBattle();
      });
    }
  }

  void _resetAndStartBattle() {
    setState(() {
      _battleStarted = true;
      _countdown = 3; // Reset countdown to 3
    });
    _startCountdown();
  }

  void _startCountdown() {
    // Start initial animation
    _scaleController.forward();
    _rotationController.forward();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _countdown--;
        });

        // Trigger animation for each countdown change
        _scaleController.reset();
        _scaleController.forward();
        _rotationController.reset();
        _rotationController.forward();

        if (_countdown <= 1) {
          timer.cancel();
          // Wait for the "1" animation to complete before navigating
          Future.delayed(const Duration(milliseconds: 1200), () {
            if (mounted) {
              context.router.push(GroupBattleRoute());
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: _buildCustomAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const VSpace(105), // 105px above the AppBar

                if (!_battleStarted) ...[
                  // Original content when battle hasn't started
                  // Main illustration with responsive sizing
                  ResponsiveBuilder(
                    builder: (context, responsiveInfo) {
                      double imageSize;
                      switch (responsiveInfo.screenSize) {
                        case ScreenSize.small:
                          imageSize = 250;
                          break;
                        case ScreenSize.medium:
                          imageSize = 300;
                          break;
                        case ScreenSize.large:
                          imageSize = 350;
                          break;
                        case ScreenSize.xlarge:
                          imageSize = 400;
                          break;
                      }

                      return Center(
                        child: Image.asset(
                          'assets/images/battles/group_battle_illustration.png',
                          width: imageSize,
                          height: imageSize,
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                  ),
                  const VSpace(35), // 35px below the asset
                  // Description text with responsive sizing
                  ResponsiveBuilder(
                    builder: (context, responsiveInfo) {
                      double titleFontSize;
                      double subtitleFontSize;
                      double spacing;

                      switch (responsiveInfo.screenSize) {
                        case ScreenSize.small:
                          titleFontSize = 24;
                          subtitleFontSize = 16;
                          spacing = 3;
                          break;
                        case ScreenSize.medium:
                          titleFontSize = 30;
                          subtitleFontSize = 18;
                          spacing = 5;
                          break;
                        case ScreenSize.large:
                          titleFontSize = 36;
                          subtitleFontSize = 20;
                          spacing = 7;
                          break;
                        case ScreenSize.xlarge:
                          titleFontSize = 42;
                          subtitleFontSize = 22;
                          spacing = 10;
                          break;
                      }

                      return Column(
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Get ready to participate',
                              style: AppTextStyles.headline(context).copyWith(
                                color: AppColors.textDark,
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.w600,
                                height: 1.13,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                            ),
                          ),
                          VSpace(spacing),
                          Text(
                            'Sed ut perspiciatis unde omnis iste',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: subtitleFontSize,
                              fontWeight: FontWeight.w400,
                              height: 1.33,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const VSpace(60),
                  // Action buttons with responsive design
                  ResponsiveBuilder(
                    builder: (context, responsiveInfo) {
                      double buttonHeight;
                      double buttonFontSize;
                      double dividerFontSize;
                      double spacing;
                      double dividerSpacing;

                      switch (responsiveInfo.screenSize) {
                        case ScreenSize.small:
                          buttonHeight = 50;
                          buttonFontSize = 14;
                          dividerFontSize = 14;
                          spacing = 15;
                          dividerSpacing = 15;
                          break;
                        case ScreenSize.medium:
                          buttonHeight = 55;
                          buttonFontSize = 16;
                          dividerFontSize = 16;
                          spacing = 20;
                          dividerSpacing = 20;
                          break;
                        case ScreenSize.large:
                          buttonHeight = 60;
                          buttonFontSize = 18;
                          dividerFontSize = 18;
                          spacing = 25;
                          dividerSpacing = 25;
                          break;
                        case ScreenSize.xlarge:
                          buttonHeight = 65;
                          buttonFontSize = 20;
                          dividerFontSize = 20;
                          spacing = 30;
                          dividerSpacing = 30;
                          break;
                      }

                      return Column(
                        children: [
                          // Create a Room button
                          ButtonFactory.blackButton(
                            text: 'Create a Room',
                            onPressed: () {
                              _showCreateBattleModal(context);
                            },
                            isFullWidth: true,
                            height: buttonHeight,
                            backgroundColor: Colors.black,
                            textStyle: TextStyle(
                              color: AppColors.gray100,
                              fontSize: buttonFontSize,
                              fontWeight: FontWeight.w600,
                              height: 1.12,
                              letterSpacing: 0.20,
                            ),
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                          VSpace(spacing),
                          // OR divider
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: AppColors.borderColor,
                                ),
                              ),
                              HSpace(dividerSpacing),
                              Text(
                                'OR',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: dividerFontSize,
                                  fontWeight: FontWeight.w600,
                                  height: 1.12,
                                  letterSpacing: 0.20,
                                ),
                              ),
                              HSpace(dividerSpacing),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: AppColors.borderColor,
                                ),
                              ),
                            ],
                          ),
                          VSpace(spacing),
                          // Join a Room button
                          ButtonFactory.blackButton(
                            text: 'Join a Room',
                            onPressed: () {
                              _showJoinRoomModal(context);
                            },
                            isFullWidth: true,
                            height: buttonHeight,
                            backgroundColor: Colors.black,
                            textStyle: TextStyle(
                              color: AppColors.gray100,
                              fontSize: buttonFontSize,
                              fontWeight: FontWeight.w600,
                              height: 1.12,
                              letterSpacing: 0.20,
                            ),
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        ],
                      );
                    },
                  ),
                ] else ...[
                  // Battle started content
                  // Countdown circle
                  Center(
                    child: AnimatedBuilder(
                      animation: Listenable.merge([
                        _scaleAnimation,
                        _rotationAnimation,
                      ]),
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Transform.rotate(
                            angle: _rotationAnimation.value,
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(0.50, -0.00),
                                  end: Alignment(0.50, 1.00),
                                  colors: [
                                    const Color(0xFF205AEB) /* Main */,
                                    const Color(0xFF123385),
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF205AEB,
                                    ).withValues(alpha: 0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  '$_countdown',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 60,
                                    fontWeight: FontWeight.w600,
                                    height: 1.83,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const VSpace(91), // 60px below countdown
                  // Description text
                  Column(
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _countdown == 1
                              ? 'Good Luck'
                              : 'Get ready to participate',
                          style: AppTextStyles.headline(context).copyWith(
                            color: AppColors.textDark,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            height: 1.13,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),
                      ),
                      const VSpace(5), // 5px between texts
                      Text(
                        'Sed ut perspiciatis unde omnis iste',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          height: 1.33,
                        ),
                      ),
                    ],
                  ),
                  const VSpace(20), // 40px below text
                  // Players section - 4 players in vertical layout
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
                        // Player 1 (Me)
                        _buildGroupPlayerCard(
                          avatarPath: 'assets/avatars/male1.png',
                          name: 'Me',
                          isCurrentUser: true,
                          isFirst: true,
                        ),

                        // Divider
                        _buildDivider(),

                        // Player 2 (Kwaku01)
                        _buildGroupPlayerCard(
                          avatarPath: 'assets/avatars/female1.png',
                          name: 'Kwaku01',
                          isCurrentUser: false,
                        ),

                        // Divider
                        _buildDivider(),

                        // Player 3 (Chi_God)
                        _buildGroupPlayerCard(
                          avatarPath: 'assets/avatars/male3.png',
                          name: 'Chi_God',
                          isCurrentUser: false,
                        ),

                        // Divider
                        _buildDivider(),

                        // Player 4 (Nakamoto)
                        _buildGroupPlayerCard(
                          avatarPath: 'assets/avatars/male4.png',
                          name: 'Nakamoto',
                          isCurrentUser: false,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      toolbarHeight: 60, // Increased height to prevent clipping
      title: Container(
        padding: const EdgeInsets.only(bottom: 20), // 20px from bottom
        child: Row(
          children: [
            // Back button positioned exactly 20px from left
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: CustomBackButton(onPress: () => LeaveGameDialog.show(context)),
            ),
            // Title centered in remaining space
            Expanded(
              child: Center(
                child: Text(
                  'Group Battle',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.12,
                    letterSpacing: 0.20,
                  ),
                ),
              ),
            ),
            // Balance space for centering
            const SizedBox(width: 60),
          ],
        ),
      ),
    );
  }

  void _showCreateBattleModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateBattleModal(
        isGroupBattle: true,
        onBattleStarted: () {
          // Set flag to start battle when returning from waiting room
          setState(() {
            _shouldStartBattle = true;
          });
          // Also trigger immediately
          _resetAndStartBattle();
        },
      ),
    ).then((_) {
      // This is called when the modal is closed
      // We don't know if battle was started or cancelled, so we don't trigger anything here
    });
  }

  void _showJoinRoomModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => JoinRoomModal(
        onBattleStarted: () {
          // Set flag to start battle when returning from waiting room
          setState(() {
            _shouldStartBattle = true;
          });
          // Also trigger immediately
          _resetAndStartBattle();
        },
      ),
    ).then((_) {
      // This is called when the modal is closed
      // We don't know if battle was started or cancelled, so we don't trigger anything here
    });
  }

  Widget _buildGroupPlayerCard({
    required String avatarPath,
    required String name,
    required bool isCurrentUser,
    bool isFirst = false,
    bool isLast = false,
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
          // Avatar
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

          // Player info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Player name
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
                // Player role
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
