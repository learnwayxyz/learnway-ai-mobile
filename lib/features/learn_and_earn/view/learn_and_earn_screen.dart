import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/learn_and_earn_bloc.dart';
import 'package:learnwayv2/services/ad_service.dart';
import 'package:learnwayv2/shared/widgets/banner_ad_slot.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:unity_levelplay_mediation/unity_levelplay_mediation.dart';

@RoutePage()
class LearnAndEarnScreen extends StatefulWidget {
  const LearnAndEarnScreen({super.key});

  @override
  State<LearnAndEarnScreen> createState() => _LearnAndEarnScreenState();
}

class _LearnAndEarnScreenState extends State<LearnAndEarnScreen> {
  final AdService _adService = AdService.instance;
  final LevelPlayAdSize _adSize = LevelPlayAdSize.BANNER;

  static const _adKey = 'lessonAndEarnScreen';

  @override
  void initState() {
    super.initState();
    _adService.premiumStatusNotifier.addListener(_onPremiumChanged);
  }

  void _onPremiumChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _adService.premiumStatusNotifier.removeListener(_onPremiumChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.standardAppBar(
        title: AppLocalizations.of(context)!.learnAndEarn,
        barHeight: 10,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            BlocBuilder<LearnAndEarnBloc, LearnAndEarnState>(
              builder: (context, state) {
                final isDark = Theme.of(context).brightness == Brightness.dark;
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: _adService.shouldShowAds
                        ? _adSize.height.toDouble() + 8
                        : 0,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VSpace(20),
                        Text(
                          AppLocalizations.of(context)!.chooseYourSkillLevel,
                          style: AppTextStyles.mdBold(context),
                        ),
                        Text(
                          AppLocalizations.of(
                            context,
                          )!.letsBringYouOnTechJourney,
                          style: AppTextStyles.md(context).copyWith(
                            color: isDark ? Colors.white : AppColors.gray700,
                          ),
                        ),
                        VSpace(20),
                        CardFactory.levelCard(
                          levelType: LevelType.beginner,
                          title: AppLocalizations.of(context)!.beginner,
                          gradient: AppColors.playNowGradient,
                          margin: EdgeInsets.zero,
                          buttonText: AppLocalizations.of(
                            context,
                          )!.startLearning,
                          subtitle: AppLocalizations.of(
                            context,
                          )!.beginnerSubtitle,
                          onButtonPressed: () {
                            context.router.push(const BeginnerRoute());
                          },
                        ),
                        VSpace(10),
                        CardFactory.levelCard(
                          levelType: LevelType.intermediate,
                          title: AppLocalizations.of(context)!.intermediate,
                          gradient: AppColors.startLessonGradient,
                          margin: EdgeInsets.zero,
                          buttonText: AppLocalizations.of(
                            context,
                          )!.startLearning,
                          isLocked: false,
                          subtitle: AppLocalizations.of(
                            context,
                          )!.intermediateSubtitle,
                          onButtonPressed: () {
                            context.router.push(const IntermediateRoute());
                          },
                        ),
                        VSpace(10),
                        CardFactory.levelCard(
                          levelType: LevelType.advanced,
                          title: AppLocalizations.of(context)!.advanced,
                          isLocked: false,
                          buttonText: AppLocalizations.of(context)!.comingSoon,
                          gradient: AppColors.quizeChallengeGradient,
                          margin: EdgeInsets.zero,
                          subtitle: AppLocalizations.of(
                            context,
                          )!.advancedSubtitle,
                        ),
                        VSpace(20),
                      ],
                    ),
                  ),
                );
              },
            ),
            if (_adService.shouldShowAds)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: const BannerAdSlot(slotKey: _adKey),
              ),
          ],
        ),
      ),
    );
  }
}
