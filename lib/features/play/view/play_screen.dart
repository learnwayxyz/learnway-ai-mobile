import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/home/enums/card_type.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  AppLocalizations.of(context)!.play,
                  style: AppTextStyles.xlBold(context),
                ),
              ),
              const VSpace(20),
              CardFactory.lessonCard(
                title: AppLocalizations.of(context)!.learningPaths,
                subtitle: AppLocalizations.of(context)!.discoverLearningPaths,
                buttonText: AppLocalizations.of(context)!.startLearning,
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                onButtonPressed: () {
                  context.router.push(const ExplorePathsRoute());
                },
              ),
              CardFactory.lessonCard(
                cardType: CardType.others,
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                title: AppLocalizations.of(context)!.contest,
                subtitle: AppLocalizations.of(context)!.contestSubtitle,
                gradient: AppColors.contestGradient,
                characterImageAsset: Assets.images.contestTroph.path,
                buttonText: AppLocalizations.of(context)!.startContest,
                onButtonPressed: () {
                  context.router.push(const ContestRoute());
                },
              ),
              CardFactory.lessonCard(
                cardType: CardType.battles,
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                gradient: AppColors.playNowGradient,
                title: AppLocalizations.of(context)!.quizBattle,
                subtitle: AppLocalizations.of(context)!.quizBattleSubtitle,
                buttonText: AppLocalizations.of(context)!.startBattle,
                onButtonPressed: () {
                  context.router.push(const BattlesMainEntryRoute());
                },
              ),
              CardFactory.lessonCard(
                cardType: CardType.challenge,
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                gradient: AppColors.quizeChallengeGradient,
                title: AppLocalizations.of(context)!.certifiedCourses,
                subtitle: AppLocalizations.of(
                  context,
                )!.certifiedCoursesSubtitle,
                buttonText: AppLocalizations.of(context)!.comingSoon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
