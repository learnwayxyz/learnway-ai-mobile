import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:learnwayv2/features/battles/view/shared/leave_game_dialog.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/back_button.dart';

@RoutePage()
class BattleFinalResultsScreen extends StatefulWidget {
  final int userScore;
  final int opponentScore;
  final String opponentName;

  const BattleFinalResultsScreen({
    super.key,
    required this.userScore,
    required this.opponentScore,
    this.opponentName = 'francis_owusu',
  });

  @override
  State<BattleFinalResultsScreen> createState() =>
      _BattleFinalResultsScreenState();
}

class _BattleFinalResultsScreenState extends State<BattleFinalResultsScreen>
    with TickerProviderStateMixin {
  late AnimationController _diamondController;
  late Animation<double> _diamondAnimation;

  @override
  void initState() {
    super.initState();

    _diamondController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _diamondAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _diamondController, curve: Curves.easeInOut),
    );

    _diamondController.repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Confetti.launch(
        context,
        options: const ConfettiOptions(particleCount: 100, spread: 70, y: 0.6),
      );
    });
  }

  @override
  void dispose() {
    _diamondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int gemsEarned = widget.userScore * 35;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: _buildCustomAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),

            AnimatedBuilder(
              animation: _diamondAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 0.8 + (_diamondAnimation.value * 0.2),
                  child: Image.asset(
                    'assets/images/gems.png',
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),

            const VSpace(20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    'You gained $gemsEarned Gems',
                    style: const TextStyle(
                      color: Color(0xFF181D27),
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      height: 1.13,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const VSpace(10),

                  Text(
                    'Congratulations on your gains',
                    style: const TextStyle(
                      color: Color(0xFF414651),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 360,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: const Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: Color(0xFFFDFDFD),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.125,
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
    );
  }

  PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      toolbarHeight: 60,
      title: Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: CustomBackButton(
                onPress: () => LeaveGameDialog.show(context),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Battle Results',
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
            const SizedBox(width: 60),
          ],
        ),
      ),
    );
  }
}
/**  */