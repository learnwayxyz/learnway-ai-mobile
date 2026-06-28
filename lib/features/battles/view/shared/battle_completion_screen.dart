import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:learnwayv2/features/battles/view/shared/leave_game_dialog.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/shared/loader/circular_progress_painter.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/back_button.dart';

@RoutePage()
class BattleCompletionScreen extends StatefulWidget {
  final int userScore;
  final int opponentScore;
  final String opponentName;

  const BattleCompletionScreen({
    super.key,
    required this.userScore,
    required this.opponentScore,
    this.opponentName = 'francis_owusu',
  });

  @override
  State<BattleCompletionScreen> createState() => _BattleCompletionScreenState();
}

class _BattleCompletionScreenState extends State<BattleCompletionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animationController.repeat();

    // Navigate to final results after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.router.push(
          BattleFinalResultsRoute(
            userScore: widget.userScore,
            opponentScore: widget.opponentScore,
            opponentName: widget.opponentName,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: _buildCustomAppBar(context),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Loading spinner
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _animationController.value * 2 * 3.14159,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFEAECF5),
                          width: 4,
                        ),
                      ),
                      child: CustomPaint(
                        painter: CircularProgressPainter(progress: 0.25),
                      ),
                    ),
                  );
                },
              ),

              const VSpace(35),

              // Wait a moment text
              const Text(
                'Wait a moment',
                style: TextStyle(
                  color: Color(0xFF181D27),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.125,
                  letterSpacing: 0.20,
                ),
                textAlign: TextAlign.center,
              ),

              const VSpace(10),

              // Subtitle
              const Text(
                'Scores & allocates are being processed.',
                style: TextStyle(
                  color: Color(0xFF414651),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.0,
                  letterSpacing: 0.20,
                ),
                textAlign: TextAlign.center,
              ),
            ],
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
                  'Battle',
                  style: const TextStyle(
                    color: Color(0xFF181D27),
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
}
