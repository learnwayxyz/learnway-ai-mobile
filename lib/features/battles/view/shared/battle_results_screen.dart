import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:learnwayv2/features/battles/view/battles_main_entry_screen.dart';
import 'package:learnwayv2/features/quiz/services/lesson_share_service.dart';
import 'package:learnwayv2/shared/widgets/shareable_card/shareable_card.dart';
import 'package:learnwayv2/shared/widgets/shareable_card/shareable_card_strategy.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

@RoutePage()
class BattleResultsScreen extends StatefulWidget {
  final int userScore;
  final int opponentScore;
  final String myName;
  final String opponentName;
  final String topic;
  final int xpEarned;

  const BattleResultsScreen({
    super.key,
    required this.userScore,
    required this.opponentScore,
    this.myName = 'You',
    this.opponentName = 'Opponent',
    this.topic = '',
    this.xpEarned = 0,
  });

  @override
  State<BattleResultsScreen> createState() => _BattleResultsScreenState();
}

class _BattleResultsScreenState extends State<BattleResultsScreen> {
  final GlobalKey _shareCardKey = GlobalKey();
  bool _isSharing = false;

  bool get _userWon => widget.userScore > widget.opponentScore;
  bool get _isDraw => widget.userScore == widget.opponentScore;
  int get _gemsEarned => widget.userScore * 35;

  Future<void> _handleShare() async {
    setState(() => _isSharing = true);
    try {
      await LessonShareService.shareWidget(
        repaintBoundaryKey: _shareCardKey,
        context: context,
        text:
            '''I just completed a Battle on LearnWay! ${_userWon
                ? '🏆 I won!'
                : _isDraw
                ? '🤝 It was a draw!'
                : '😤 Better luck next time!'} Check out my score: ${widget.userScore} vs ${widget.opponentScore}.\n\nJoin me and start earning real rewards while leveling up your skills! 🚀\n\nDownload the app now 👉 https://onelink.to/q3ypvq''',
        subject: 'Battle Completed - LearnWay',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to share: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = LocalStorageService.getUserSync();
    final profileImageUrl = user?.profileImageUrl;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const VSpace(40),

                  Text(
                    'Battle Complete!',
                    style: AppTextStyles.headline(context).copyWith(
                      color: AppColors.textDark,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 1.14,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const VSpace(20),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: _userWon
                          ? const Color(0xFFE8F5E8)
                          : _isDraw
                          ? const Color(0xFFFFF3E0)
                          : const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _userWon
                          ? '🎉 You Won!'
                          : _isDraw
                          ? '🤝 It\'s a Draw!'
                          : '😔 You Lost',
                      style: TextStyle(
                        color: _userWon
                            ? const Color(0xFF4CAF50)
                            : _isDraw
                            ? const Color(0xFFFF9800)
                            : const Color(0xFFF44336),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.33,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const VSpace(40),

                  Row(
                    children: [
                      Expanded(
                        child: _buildScoreCard(
                          name: widget.myName,
                          score: widget.userScore,
                          avatarPath: 'assets/avatars/male2.png',
                          isUser: true,
                          isWinner: _userWon,
                        ),
                      ),

                      const HSpace(20),

                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.gray100,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            'VS',
                            style: TextStyle(
                              color: AppColors.textDark,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const HSpace(20),

                      Expanded(
                        child: _buildScoreCard(
                          name: widget.opponentName,
                          score: widget.opponentScore,
                          avatarPath: 'assets/avatars/female9.png',
                          isUser: false,
                          isWinner: !_userWon && !_isDraw,
                        ),
                      ),
                    ],
                  ),

                  const VSpace(40),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Score Breakdown',
                          style: AppTextStyles.baseMedium(context).copyWith(
                            color: AppColors.textDark,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const VSpace(15),
                        _buildScoreRow(
                          'Correct Answers',
                          widget.userScore,
                          widget.opponentScore,
                        ),
                        const VSpace(10),
                        _buildScoreRow(
                          'Wrong Answers',
                          10 - widget.userScore,
                          10 - widget.opponentScore,
                        ),
                        const VSpace(10),
                        _buildScoreRow(
                          'Accuracy',
                          ((widget.userScore / 10) * 100).round(),
                          ((widget.opponentScore / 10) * 100).round(),
                          isPercentage: true,
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  Column(
                    children: [
                      _isSharing
                          ? ButtonFactory.blackButton(
                              mainAxisAlignment: MainAxisAlignment.center,
                              onPressed: () {},
                              text: 'Preparing...',
                              isFullWidth: true,
                              height: 55,
                            )
                          : ButtonFactory.blackButton(
                              mainAxisAlignment: MainAxisAlignment.center,
                              onPressed: _handleShare,
                              text: 'Share your score',
                              isFullWidth: true,
                              height: 55,
                            ),

                      const VSpace(15),

                      ButtonFactory.blackButton(
                        text: 'Play Again',
                        onPressed: () {
                          context.router.push(BattlesMainEntryRoute());
                        },
                        isFullWidth: true,
                        height: 55,
                        backgroundColor: Colors.black,
                        textStyle: TextStyle(
                          color: AppColors.gray100,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.12,
                          letterSpacing: 0.20,
                        ),
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                      const VSpace(15),

                      ButtonFactory.blackButton(
                        text: 'Back to Battles',
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const BattlesMainEntryScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        isFullWidth: true,
                        height: 55,
                        backgroundColor: Colors.white,
                        textStyle: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.12,
                          letterSpacing: 0.20,
                        ),
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ],
                  ),

                  const VSpace(40),
                ],
              ),
            ),
          ),
          Positioned(
            left: -10000,
            top: -10000,
            child: SizedBox(
              width: 1080,
              height: 1080,
              child: RepaintBoundary(
                key: _shareCardKey,
                child: ShareableCard(
                  skin: _userWon || _isDraw ? BattleSkin.win : BattleSkin.lose,
                  strategy: BattleShareStrategy(
                    userWon: _userWon,
                    isDraw: _isDraw,
                    userScore: widget.userScore,
                    totalQuestions: 10,
                    xpEarned: widget.xpEarned,
                    gemsEarned: _gemsEarned,
                    username: widget.myName,
                    profileImageUrl: profileImageUrl,
                    opponentName: widget.opponentName,
                    opponentXpEarned: 0,
                    topic: widget.topic,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard({
    required String name,
    required int score,
    required String avatarPath,
    required bool isUser,
    required bool isWinner,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isWinner
            ? Border.all(color: AppColors.primaryColor, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    avatarPath,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (isWinner)
                Positioned(
                  top: -5,
                  right: -5,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFD700),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),

          const VSpace(12),

          Text(
            name,
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
            textAlign: TextAlign.center,
          ),

          const VSpace(8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$score/10',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreRow(
    String label,
    int userValue,
    int opponentValue, {
    bool isPercentage = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.14,
          ),
        ),
        Row(
          children: [
            Text(
              '$userValue${isPercentage ? '%' : ''}',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.14,
              ),
            ),
            const HSpace(20),
            Text(
              '$opponentValue${isPercentage ? '%' : ''}',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
