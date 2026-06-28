import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:learnwayv2/features/battles/view/online_opponent/online_opponent_modal.dart';
import 'package:learnwayv2/features/battles/view/play_with_friend/battle_screen.dart';
import 'package:learnwayv2/features/battles/view/shared/leave_game_dialog.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/back_button.dart';

@RoutePage()
class OnlineOpponentScreen extends StatefulWidget {
  final bool autoStartCountdown;

  const OnlineOpponentScreen({super.key, this.autoStartCountdown = false});

  @override
  State<OnlineOpponentScreen> createState() => _OnlineOpponentScreenState();
}

class _OnlineOpponentScreenState extends State<OnlineOpponentScreen>
    with TickerProviderStateMixin {
  bool _battleStarted = false;
  bool _searchingForOpponent = false;
  int _countdown = 3;
  Timer? _countdownTimer;
  Timer? _searchTimer;
  bool _shouldStartBattle = false;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late AnimationController _spinnerController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _spinnerAnimation;

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
    _spinnerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Initialize animations
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    _spinnerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _spinnerController, curve: Curves.linear),
    );

    // Auto-start countdown if requested
    if (widget.autoStartCountdown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _resetAndStartBattle();
      });
    }
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

  void _startSearchingForOpponent() {
    setState(() {
      _searchingForOpponent = true;
    });

    // Start spinner animation
    _spinnerController.repeat();

    // Simulate searching for 3 seconds, then start countdown
    _searchTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _searchingForOpponent = false;
          _battleStarted = true;
          _countdown = 3;
        });
        _spinnerController.stop();
        _startCountdown();
      }
    });
  }

  void _resetAndStartBattle() {
    setState(() {
      _battleStarted = true;
      _countdown = 3;
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const BattleScreen(battleId: ''),
                ),
              );
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _searchTimer?.cancel();
    _scaleController.dispose();
    _rotationController.dispose();
    _spinnerController.dispose();
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
                if (!_battleStarted && !_searchingForOpponent) ...[
                  // Original content when battle hasn't started
                  const VSpace(38), // 143px total from AppBar (105 + 38 = 143)
                  // Globe Image
                  Center(
                    child: Image.asset(
                      'assets/images/battles/globe.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const VSpace(35), // 35px below the asset
                  // Title
                  FittedBox(
                    child: Text(
                      'Play with online opponent',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        height: 1.13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const VSpace(8), // 8px between title and subtitle
                  // Subtitle
                  FittedBox(
                    child: Text(
                      'Have fun with a learning buddy.',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        height: 1.33,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const VSpace(60), // 60px below subtitle
                  // Start Button
                  GestureDetector(
                    onTap: () {
                      _showOnlineOpponentModal(context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.textDark,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: Center(
                        child: Text(
                          'Find opponent',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 1.33,
                          ),
                        ),
                      ),
                    ),
                  ),
                ] else if (_searchingForOpponent) ...[
                  // Searching for opponent state
                  const VSpace(38), // 143px total from AppBar (105 + 38 = 143)
                  // Globe with spinning ring
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Spinning ring
                        AnimatedBuilder(
                          animation: _spinnerAnimation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _spinnerAnimation.value * 2 * 3.14159,
                              child: Container(
                                width: 200,
                                height: 200,
                                child: CustomPaint(painter: SpinnerPainter()),
                              ),
                            );
                          },
                        ),
                        // Globe image
                        Image.asset(
                          'assets/images/battles/globe.png',
                          width: 180,
                          height: 180,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),

                  const VSpace(35), // 35px below the globe
                  // Title
                  FittedBox(
                    child: Text(
                      'Finding opponent',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        height: 1.13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const VSpace(8), // 8px between title and subtitle
                  // Subtitle
                  FittedBox(
                    child: Text(
                      'Searching for online players ...',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        height: 1.33,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const VSpace(60), // 60px below subtitle
                  // Players section
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Player 1 (Me)
                        _buildPlayerCard(
                          avatarPath: 'assets/avatars/male0.png',
                          name: 'Me',
                          isCurrentUser: true,
                        ),

                        // VS divider
                        Image.asset(
                          'assets/images/vs.png',
                          fit: BoxFit.contain,
                          width: 89,
                          height: 89,
                        ),

                        // Player 2 (Searching)
                        _buildSearchingPlayerCard(),
                      ],
                    ),
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
                          style: TextStyle(
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
                  // Players section
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Player 1 (Me)
                        _buildPlayerCard(
                          avatarPath: 'assets/avatars/male0.png',
                          name: 'Me',
                          isCurrentUser: true,
                        ),

                        // VS divider
                        Image.asset(
                          'assets/images/vs.png',
                          fit: BoxFit.contain,
                          width: 89,
                          height: 89,
                        ),

                        // Player 2 (Human opponent)
                        _buildPlayerCard(
                          avatarPath: 'assets/avatars/female5.png',
                          name: 'Sarah',
                          isCurrentUser: false,
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
              child: CustomBackButton(
                onPress: () => LeaveGameDialog.show(context),
              ),
            ),
            // Title centered in remaining space
            Expanded(
              child: Center(
                child: Text(
                  'Online Battle',
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

  void _showOnlineOpponentModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OnlineOpponentModal(
        onBattleStarted: () {
          // Start searching for opponent instead of directly starting battle
          _startSearchingForOpponent();
        },
      ),
    ).then((_) {
      // This is called when the modal is closed
      // We don't know if battle was started or cancelled, so we don't trigger anything here
    });
  }

  Widget _buildPlayerCard({
    required String avatarPath,
    required String name,
    required bool isCurrentUser,
  }) {
    return Column(
      children: [
        // Avatar
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              avatarPath,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const VSpace(8),
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
          isCurrentUser ? 'PLAYER' : 'BOT',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchingPlayerCard() {
    return Column(
      children: [
        // Opponent avatar
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              'assets/avatars/female5.png', // Using a random avatar
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const VSpace(8),
        // Player name
        Text(
          'Sarah',
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
          'PLAYER',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

class SpinnerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2 - 1;

    // Draw the gray background ring
    final grayPaint = Paint()
      ..color = const Color(0xFFEAECF5)
      ..strokeWidth = 9
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final grayRect = Rect.fromCircle(center: center, radius: outerRadius - 5);
    canvas.drawArc(
      grayRect,
      0,
      2 * 3.14159, // Full circle
      false,
      grayPaint,
    );

    // Draw the blue progress arc
    final bluePaint = Paint()
      ..color = const Color(0xFF215AEB)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final blueRect = Rect.fromCircle(center: center, radius: outerRadius - 5);
    canvas.drawArc(
      blueRect,
      -1.57, // Start from top (-π/2)
      1.57, // 90 degrees (π/2)
      false,
      bluePaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
