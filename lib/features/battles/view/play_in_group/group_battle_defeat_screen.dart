import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learnwayv2/features/battles/view/shared/leave_game_dialog.dart';
import 'package:learnwayv2/features/main_activity/cubit/main_activity_cubit.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/back_button.dart';
import 'package:learnwayv2/core/di/locator.dart';

@RoutePage()
class GroupBattleDefeatScreen extends StatelessWidget {
  final int userScore;
  final int player2Score;
  final int player3Score;
  final int player4Score;

  const GroupBattleDefeatScreen({
    super.key,
    required this.userScore,
    required this.player2Score,
    required this.player3Score,
    required this.player4Score,
  });

  @override
  Widget build(BuildContext context) {
    // Create sorted list of players with scores
    final players = [
      {
        'name': 'Me',
        'score': userScore,
        'avatar': 'male1.png',
        'isCreator': true,
        'rank': 1,
      },
      {
        'name': 'Chi_God',
        'score': player2Score,
        'avatar': 'male3.png',
        'isCreator': false,
        'rank': 2,
      },
      {
        'name': 'Kwaku01',
        'score': player3Score,
        'avatar': 'female1.png',
        'isCreator': false,
        'rank': 3,
      },
      {
        'name': 'Nakamoto',
        'score': player4Score,
        'avatar': 'male4.png',
        'isCreator': false,
        'rank': 4,
      },
    ];

    // Sort by score (descending)
    players.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));

    // Update ranks after sorting
    for (int i = 0; i < players.length; i++) {
      players[i]['rank'] = i + 1;
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: _buildCustomAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const VSpace(20),

            // Defeat Header
            _buildDefeatHeader(),

            const VSpace(20),

            // Leaderboard
            _buildLeaderboard(players),

            const VSpace(40),

            // Action Buttons
            _buildActionButtons(context),

            const VSpace(40),
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
            const SizedBox(width: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildDefeatHeader() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 23),
      decoration: BoxDecoration(
        color: const Color(0xFFEAECF5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Decorative stars
          Positioned(
            left: 177.08,
            top: 0,
            child: SvgPicture.asset(
              'assets/icons/Star 4_Defeat.svg',
              width: 114,
              height: 114,
            ),
          ),
          Positioned(
            left: 66.91,
            top: 14.4,
            child: SvgPicture.asset(
              'assets/icons/Star 4_Defeat.svg',
              width: 59.416,
              height: 59.416,
            ),
          ),
          Positioned(
            left: 201.05,
            top: 190.85,
            child: SvgPicture.asset(
              'assets/icons/Star 4_Defeat.svg',
              width: 59.416,
              height: 59.416,
            ),
          ),
          Positioned(
            left: 21,
            top: 153.94,
            child: SvgPicture.asset(
              'assets/icons/Star 4_Defeat.svg',
              width: 90.025,
              height: 90.025,
            ),
          ),
          Positioned(
            left: 291.98,
            top: 104.43,
            child: SvgPicture.asset(
              'assets/icons/Star 4_Defeat.svg',
              width: 90.025,
              height: 90.025,
            ),
          ),
          // Balloons
          Positioned(
            left: 31,
            top: 92,
            child: SvgPicture.asset(
              'assets/icons/fluent-mdl2_balloons_Defeat.svg',
              width: 22,
              height: 22,
            ),
          ),
          Positioned(
            left: 319,
            top: -8,
            child: SvgPicture.asset(
              'assets/icons/fluent-mdl2_balloons_Defeat.svg',
              width: 22,
              height: 22,
            ),
          ),
          Positioned(
            left: 148,
            top: 154,
            child: SvgPicture.asset(
              'assets/icons/fluent-mdl2_balloons_Defeat.svg',
              width: 37,
              height: 37,
            ),
          ),

          // Main content
          Padding(
            padding: const EdgeInsets.only(top: 44),
            child: Column(
              children: [
                Text(
                  'Defeat',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const VSpace(5),
                Text(
                  'Better Luck next time.',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  height: 55,
                  margin: const EdgeInsets.fromLTRB(25, 0, 25, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: Center(
                    child: Text(
                      'Share Your Scores',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboard(List<Map<String, dynamic>> players) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 23),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: players.asMap().entries.map((entry) {
          final index = entry.key;
          final player = entry.value;
          final isLast = index == players.length - 1;

          return Column(
            children: [
              Row(
                children: [
                  // Rank
                  Text(
                    '${player['rank']}.',
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const HSpace(8),

                  // Avatar
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.asset(
                        'assets/avatars/${player['avatar']}',
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
                        Text(
                          player['name'] as String,
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const VSpace(4),
                        Text(
                          player['isCreator'] ? 'CREATOR' : 'PLAYER',
                          style: TextStyle(
                            color: AppColors.gray500,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Score
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/xp_image.png',
                        width: 32,
                        height: 32,
                      ),
                      const HSpace(8),
                      Text(
                        '${player['score']}',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (!isLast) ...[
                const VSpace(15),
                Container(height: 1, color: AppColors.borderLight),
                const VSpace(15),
              ],
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(60),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(60),
                onTap: () {
                  context.router.push(BattlesMainEntryRoute());
                },
                child: Center(
                  child: Text(
                    'Play Again',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const VSpace(20),

          // Go Home button
          Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(60),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(60),
                onTap: () {
                  // Reset MainActivityCubit to ensure we start on Home tab
                  locator.get<MainActivityCubit>().resetState();
                  // Navigate to MainActivityScreen (home with bottom nav)
                  context.router.pushAndPopUntil(
                    const MainActivityRoute(),
                    predicate: (route) => false,
                  );
                },
                child: Center(
                  child: Text(
                    'Go Home',
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
