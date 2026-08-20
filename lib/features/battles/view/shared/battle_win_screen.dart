import 'package:learnwayv2/app/app.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/battles/services/battle_event_service.dart';
import 'package:learnwayv2/features/main_activity/cubit/main_activity_cubit.dart';
import 'package:learnwayv2/features/quiz/services/lesson_share_service.dart';
import 'package:learnwayv2/services/ad_service.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/banner_ad_slot.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:learnwayv2/shared/widgets/shareable_card/shareable_card.dart';
import 'package:learnwayv2/shared/widgets/shareable_card/shareable_card_strategy.dart';

@RoutePage()
class BattleWinScreen extends StatefulWidget {
  final int userXpEarned;
  final int opponentXpEarned;
  final int userScore;
  final int userGemsEarned;
  final int totalQuestions;
  final String myName;
  final String opponentName;
  final String topic;
  final String? myProfileImageUrl;
  final String? opponentProfileImageUrl;
  final bool isTie;
  final bool isBot;

  const BattleWinScreen({
    super.key,
    required this.userXpEarned,
    required this.opponentXpEarned,
    this.userScore = 0,
    this.userGemsEarned = 0,
    this.totalQuestions = 10,
    this.myName = 'You',
    this.opponentName = 'Opponent',
    this.topic = '',
    this.myProfileImageUrl,
    this.opponentProfileImageUrl,
    this.isTie = false,
    this.isBot = false,
  });

  @override
  State<BattleWinScreen> createState() => _BattleWinScreenState();
}

class _BattleWinScreenState extends State<BattleWinScreen> {
  final GlobalKey _shareCardKey = GlobalKey();
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!AdService.instance.shouldShowAds) return;
      if (!AdService.instance.isNativeAdReady) return;

      appRouter.push(NativeAdRoute());
    });
  }

  Future<void> _handleShare() async {
    await _doShare();
  }

  Future<void> _doShare() async {
    if (!mounted) return;
    setState(() => _isSharing = true);
    try {
      await LessonShareService.shareWidget(
        repaintBoundaryKey: _shareCardKey,
        context: context,
        text:
            'I won a battle on LearnWay! 🏆 Check out my score!\n\nJoin me and start earning real rewards while leveling up your skills! 🚀\n\nDownload the app now 👉 https://onelink.to/q3ypvq',
        subject: 'Battle Won - LearnWay',
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
    final l10n = AppLocalizations.of(context)!;
    final user = LocalStorageService.getUserSync();
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBarFactory.standardAppBar(
        title: l10n.battleResults,
        showBackButton: false,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                const VSpace(20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 23),
                  height: 388,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF85A0E6), Color(0xFF215AEB)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Stack(
                    children: [
                      _buildDecorations(),
                      Column(
                        children: [
                          const VSpace(36),
                          SizedBox(
                            width: 345,
                            child: Column(
                              children: [
                                Text(
                                  widget.isTie
                                      ? l10n.itsADraw(widget.myName)
                                      : l10n.congratulations,
                                  style: TextStyle(
                                    color: Color(0xFFFDFDFD),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    height: 1.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const VSpace(10),
                                Text(
                                  widget.isTie
                                      ? l10n.youFoughtHard
                                      : l10n.youWonThisBattle(
                                          widget.userGemsEarned,
                                        ),
                                  style: TextStyle(
                                    color: Color(0xFFFDFDFD),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 1.29,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          _buildPlayerCards(),
                          const VSpace(20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ButtonFactory.whiteButton(
                              mainAxisAlignment: MainAxisAlignment.center,
                              onPressed: () =>
                                  _isSharing ? null : _handleShare(),
                              text: _isSharing
                                  ? l10n.preparingShare
                                  : l10n.shareYourScores,
                              style: AppTextStyles.base(context).copyWith(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.20,
                              ),
                            ),
                          ),

                          const VSpace(20),
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          locator<BattleEventService>().disconnect();
                          context.router.pushAndPopUntil(
                            BattlesMainEntryRoute(),
                            predicate: (route) =>
                                route.data?.name == MainActivityRoute.name,
                          );
                        },
                        child: Container(
                          width: 370,
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: Center(
                            child: Text(
                              l10n.playAgain,
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

                      const VSpace(20),

                      GestureDetector(
                        onTap: () {
                          locator.get<MainActivityCubit>().resetState();

                          context.router.pushAndPopUntil(
                            const MainActivityRoute(),
                            predicate: (route) => false,
                          );
                        },
                        child: Container(
                          width: 370,
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(60),
                            border: Border.all(color: const Color(0xFFD5D7DA)),
                          ),
                          child: Center(
                            child: Text(
                              l10n.goHome,
                              style: TextStyle(
                                color: Color(0xFF252B37),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 1.125,
                                letterSpacing: 0.20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const BannerAdSlot(slotKey: 'battleWin'),
                const VSpace(10),
              ],
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
                  skin: widget.isTie ? BattleSkin.win : BattleSkin.win,
                  strategy: BattleShareStrategy(
                    userWon: !widget.isTie,
                    isDraw: widget.isTie,
                    userScore: widget.userScore,
                    totalQuestions: widget.totalQuestions,
                    xpEarned: widget.userXpEarned,
                    gemsEarned: widget.userGemsEarned,
                    username: widget.myName,
                    profileImageUrl: user?.profileImageUrl,
                    opponentName: widget.opponentName,
                    opponentXpEarned: widget.opponentXpEarned,
                    opponentProfileImageUrl: widget.opponentProfileImageUrl,
                    topic: widget.topic,
                    isBot: widget.isBot,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorations() {
    return Stack(
      children: [
        Positioned(
          left: 177,
          top: 0,
          child: SizedBox(
            width: 114,
            height: 114,
            child: SvgPicture.asset(Assets.icons.star5, fit: BoxFit.contain),
          ),
        ),
        Positioned(
          left: 67,
          top: 14,
          child: SizedBox(
            width: 59,
            height: 59,
            child: SvgPicture.asset(Assets.icons.star5, fit: BoxFit.contain),
          ),
        ),
        Positioned(
          left: 201,
          top: 191,
          child: SizedBox(
            width: 59,
            height: 59,
            child: SvgPicture.asset(Assets.icons.star5, fit: BoxFit.contain),
          ),
        ),
        Positioned(
          left: 21,
          top: 154,
          child: SizedBox(
            width: 90,
            height: 90,
            child: SvgPicture.asset(Assets.icons.star5, fit: BoxFit.contain),
          ),
        ),
        Positioned(
          left: 292,
          top: 104,
          child: SizedBox(
            width: 90,
            height: 90,
            child: SvgPicture.asset(Assets.icons.star5, fit: BoxFit.contain),
          ),
        ),

        Positioned(
          left: 31,
          top: 92,
          child: SizedBox(
            width: 22,
            height: 22,
            child: SvgPicture.asset(
              Assets.icons.fluentMdl2Balloons,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Positioned(
          left: 319,
          top: -8,
          child: SizedBox(
            width: 22,
            height: 22,
            child: SvgPicture.asset(
              Assets.icons.fluentMdl2Balloons,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Positioned(
          left: 148,
          top: 154,
          child: SizedBox(
            width: 37,
            height: 37,
            child: SvgPicture.asset(
              Assets.icons.fluentMdl2Balloons,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerCards() {
    return ResponsiveBuilder(
      builder: (context, sizingInfo) {
        final scale = sizingInfo.scaleFactor;
        final vsSize = 89 * scale;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildPlayerCard(
              name: widget.myName,
              xpEarned: widget.userXpEarned,
              profileImageUrl: widget.myProfileImageUrl,
              responsiveInfo: sizingInfo,
            ),

            SizedBox(
              width: vsSize,
              height: vsSize,
              child: Image.asset(Assets.images.vs.path, fit: BoxFit.contain),
            ),

            _buildPlayerCard(
              name: widget.opponentName,
              xpEarned: widget.opponentXpEarned,
              profileImageUrl: widget.opponentProfileImageUrl,
              responsiveInfo: sizingInfo,
              isBot: widget.isBot,
            ),
          ],
        );
      },
    );
  }

  Widget _buildPlayerCard({
    required String name,
    required int xpEarned,
    String? profileImageUrl,
    required ResponsiveInfo responsiveInfo,
    bool isBot = false,
  }) {
    final scale = responsiveInfo.scaleFactor;
    final avatarSize = 95 * scale;
    final xpIconSize = 28 * scale;
    final fontSize = 14 * responsiveInfo.fontSizeMultiplier;

    return Column(
      children: [
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(avatarSize / 2),
            child: isBot
                ? Image.asset(
                    'assets/images/battles/lenny_bot.png',
                    width: avatarSize,
                    height: avatarSize,
                    fit: BoxFit.cover,
                  )
                : profileImageUrl != null
                ? CachedNetworkImage(
                    imageUrl: profileImageUrl,
                    width: avatarSize,
                    height: avatarSize,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => Image.asset(
                      Assets.avatars.male2.path,
                      width: avatarSize,
                      height: avatarSize,
                      fit: BoxFit.cover,
                    ),
                    errorWidget: (_, _, _) => Image.asset(
                      Assets.avatars.male2.path,
                      width: avatarSize,
                      height: avatarSize,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    Assets.avatars.male2.path,
                    width: avatarSize,
                    height: avatarSize,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        VSpace(16 * scale),
        Text(
          name,
          style: TextStyle(
            color: const Color(0xFFFDFDFD),
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            height: 1.14,
            letterSpacing: 0.20,
          ),
        ),
        VSpace(5 * scale),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10 * scale,
            vertical: 8 * scale,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                Assets.images.newXp.path,
                width: xpIconSize,
                height: xpIconSize,
                fit: BoxFit.contain,
              ),
              HSpace(5 * scale),
              Text(
                '$xpEarned',
                style: TextStyle(
                  color: const Color(0xFF252B37),
                  fontSize: fontSize,
                  fontWeight: FontWeight.w400,
                  height: 1.0,
                  letterSpacing: 0.20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
