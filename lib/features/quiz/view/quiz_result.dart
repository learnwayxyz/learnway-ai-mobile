import 'package:learnwayv2/app/app.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/features/quiz/bloc/quiz_bloc.dart';
import 'package:learnwayv2/features/quiz/services/lesson_share_service.dart';
import 'package:learnwayv2/shared/widgets/shareable_card/shareable_card.dart';
import 'package:learnwayv2/shared/widgets/shareable_card/shareable_card_strategy.dart';
import 'package:learnwayv2/services/ad_service.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/shared/widgets/ad_gate_dialog.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

@RoutePage()
class QuizResultScreen extends StatefulWidget {
  const QuizResultScreen({super.key});

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
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

  @override
  Widget build(BuildContext context) {
    final scorePercentage = context.select<QuizBloc, double>(
      (bloc) => bloc.state is QuizCompleted
          ? (bloc.state as QuizCompleted).scorePercentage.roundToDouble()
          : 0,
    );
    final isRetake = context.select<QuizBloc, bool>(
      (bloc) => bloc.state is QuizCompleted
          ? (bloc.state as QuizCompleted).isRetake
          : false,
    );
    final username = LocalStorageService.getUserSync()?.username;
    final name = username != null && username.isNotEmpty
        ? username[0].toUpperCase() + username.substring(1).toLowerCase()
        : null;

    final timeRemaining = context.select<QuizBloc, int>(
      (bloc) => bloc.state is QuizCompleted
          ? (bloc.state as QuizCompleted).totalTimeSpent
          : 0,
    );
    final totalQuestions = context.select<QuizBloc, int>(
      (bloc) => bloc.state is QuizCompleted
          ? (bloc.state as QuizCompleted).totalQuestions
          : 0,
    );
    final correctAnswers = context.select<QuizBloc, int?>(
      (bloc) => bloc.state is QuizCompleted
          ? (bloc.state as QuizCompleted).correctAnswers
          : 0,
    );
    final incorrectAnswers = context.select<QuizBloc, int?>(
      (bloc) => bloc.state is QuizCompleted
          ? (bloc.state as QuizCompleted).incorrectAnswers
          : 0,
    );

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBarFactory.standardAppBar(
          title: AppLocalizations.of(context)!.quizResult,
          barHeight: 0,
          showBackButton: false,
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  VSpace(20),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: AppColors.blueGradient2,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        VSpace(18),
                        CircularPercentIndicator(
                          radius: 50.8,
                          lineWidth: 10.0,
                          percent: scorePercentage / 100,
                          center: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$scorePercentage%',
                                style: AppTextStyles.mdBold(
                                  context,
                                  color: AppColors.white,
                                ).copyWith(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '$timeRemaining ${AppLocalizations.of(context)!.sec}',
                                style: AppTextStyles.baseRegular(
                                  context,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                          progressColor: AppColors.white,
                          backgroundColor: AppColors.gray300,
                          circularStrokeCap: CircularStrokeCap.round,
                          curve: Curves.bounceIn,
                        ),
                        VSpace(12.8),
                        Text(
                          isRetake
                              ? AppLocalizations.of(
                                  context,
                                )!.practiceMakesPerfect
                              : AppLocalizations.of(
                                  context,
                                )!.goodEffort(name ?? ''),
                          style: AppTextStyles.baseBold(
                            context,
                            color: AppColors.white,
                          ).copyWith(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          isRetake
                              ? AppLocalizations.of(
                                  context,
                                )!.alreadyCompletedLesson
                              : AppLocalizations.of(
                                  context,
                                )!.keepLearningAndTrying,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.smRegular(
                            context,
                            color: AppColors.white,
                          ),
                        ),
                        VSpace(15),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: () async {
                            final adsEnabled =
                                !locator
                                    .isRegistered<RevenueConfigResponse>() ||
                                locator.get<RevenueConfigResponse>().enableAds;
                            if (!adsEnabled) {
                              context.router.push(const QuizReviewRoute());
                              return;
                            }
                            final l10n = AppLocalizations.of(context)!;
                            final granted = await AdGateDialog.show(
                              context,
                              title: l10n.reviewAnswers,
                              description: l10n.watchAdToReviewAnswers,
                              watchAdButtonText: l10n.watchAd,
                            );
                            if (granted && context.mounted) {
                              context.router.push(const QuizReviewRoute());
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context)!.reviewAnswers,
                            style: AppTextStyles.smBold(
                              context,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        VSpace(24),
                      ],
                    ),
                  ),
                  VSpace(20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 15,
                          color: Colors.black.withValues(alpha: 0.1),
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.success25,
                              ),
                              child: Icon(
                                Icons.check,
                                size: 15,
                                color: AppColors.white,
                              ),
                            ),
                            HSpace(10),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '$correctAnswers',
                                    style: AppTextStyles.baseBold(
                                      context,
                                      color: AppColors.gray900,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '/$totalQuestions',
                                    style: AppTextStyles.baseBold(
                                      context,
                                      color: AppColors.gray400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              decoration: BoxDecoration(
                                color: AppColors.success100,
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.correctAnswers,
                                style: AppTextStyles.xsSemiBold(
                                  context,
                                  color: AppColors.success500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        VSpace(13),
                        Divider(),
                        VSpace(15),
                        Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.error500,
                              ),
                              child: Icon(
                                Icons.close,
                                size: 15,
                                color: AppColors.white,
                              ),
                            ),
                            HSpace(10),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '$incorrectAnswers',
                                    style: AppTextStyles.baseBold(context),
                                  ),
                                  TextSpan(
                                    text: '/$totalQuestions',
                                    style: AppTextStyles.baseBold(
                                      context,
                                      color: AppColors.gray400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              decoration: BoxDecoration(
                                color: AppColors.error100,
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.wrongAnswer,
                                style: AppTextStyles.xsSemiBold(
                                  context,
                                  color: AppColors.error500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  VSpace(44),

                  // Conditionally show share button only if it's NOT a retake
                  if (!isRetake) ...[
                    _isSharing
                        ? ButtonFactory.blackButton(
                            mainAxisAlignment: MainAxisAlignment.center,
                            onPressed: () {},
                            text: AppLocalizations.of(context)!.preparing,
                          )
                        : ButtonFactory.blackButton(
                            mainAxisAlignment: MainAxisAlignment.center,
                            onPressed: () => _handleShare(),
                            text: AppLocalizations.of(context)!.shareYourScores,
                          ),
                    VSpace(20),
                  ],

                  ButtonFactory.blackButton(
                    mainAxisAlignment: MainAxisAlignment.center,
                    borderColor: AppColors.white,
                    hasBorder: true,
                    onPressed: () {
                      context.router.popUntil(
                        (route) => route.settings.name == LessonRoute.name,
                      );
                    },
                    backgroundColor: AppColors.white,
                    text: AppLocalizations.of(context)!.goBackToLessons,
                    textStyle: AppTextStyles.baseBold(
                      context,
                      color: AppColors.gray900,
                    ),
                  ),
                ],
              ),
            ),
            // Hidden shareable card widget (only rendered if not a retake)
            if (!isRetake)
              Positioned(
                left: -10000,
                top: -10000,
                child: SizedBox(
                  width: 1080,
                  height: 1080,
                  child: RepaintBoundary(
                    key: _shareCardKey,
                    child: _buildShareableCard(
                      scorePercentage: scorePercentage.toInt(),
                      xpEarned: context.select<QuizBloc, int>(
                        (bloc) => bloc.state is QuizCompleted
                            ? (bloc.state as QuizCompleted).xpEarned
                            : 0,
                      ),
                      gemsEarned: context.select<QuizBloc, int>(
                        (bloc) => bloc.state is QuizCompleted
                            ? (bloc.state as QuizCompleted).gemsEarned
                            : 0,
                      ),
                      username:
                          name ??
                          username ??
                          AppLocalizations.of(context)!.student,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareableCard({
    required int scorePercentage,
    required int xpEarned,
    required int gemsEarned,
    required String username,
  }) {
    final user = LocalStorageService.getUserSync();
    final lessonTitle = context.select<QuizBloc, String>(
      (bloc) => bloc.state is QuizCompleted
          ? (bloc.state as QuizCompleted).lessonTitle
          : AppLocalizations.of(context)!.unknownLesson,
    );
    return ShareableCard(
      strategy: LessonShareStrategy(
        scorePercentage: scorePercentage,
        xpEarned: xpEarned,
        gemsEarned: gemsEarned,
        username: username,
        profileImageUrl: user?.profileImageUrl,
        lessonTitle: lessonTitle,
      ),
    );
  }

  Future<void> _handleShare() async {
    setState(() {
      _isSharing = true;
    });

    try {
      final l10n = AppLocalizations.of(context)!;
      await LessonShareService.shareWidget(
        repaintBoundaryKey: _shareCardKey,
        context: context,
        text: l10n.lessonShareText,
        subject: l10n.lessonCompletedSubject,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.failedToShare(e.toString()),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }
}
