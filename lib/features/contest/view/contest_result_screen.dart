import 'dart:developer';

import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/contest/model/all_contest_model.dart';
import 'package:learnwayv2/features/home/home_bloc/home_bloc.dart';
import 'package:learnwayv2/features/home/home_bloc/home_state.dart';
import 'package:learnwayv2/features/contest/bloc/contest_bloc.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

@RoutePage()
class ContestResultScreen extends StatefulWidget {
  const ContestResultScreen({super.key});

  @override
  State<ContestResultScreen> createState() => _ContestResultScreenState();
}

class _ContestResultScreenState extends State<ContestResultScreen> {
  @override
  Widget build(BuildContext context) {
    final scorePercentage = context.select<ContestBloc, double>(
      (bloc) => bloc.state is ContestXPEarned
          ? (bloc.state as ContestXPEarned).scorePercentage.roundToDouble()
          : 0,
    );
    final name = context.select<HomeBloc, String?>(
      (bloc) => bloc.state is FetchHomeDataSuccess
          ? (bloc.state as FetchHomeDataSuccess).userProfile!.username
          : '',
    );
    final timeRemaining = context.select<ContestBloc, int>(
      (bloc) => bloc.state is ContestXPEarned
          ? (bloc.state as ContestXPEarned).totalTimeSpent
          : 0,
    );
    final totalQuestions = context.select<ContestBloc, int>(
      (bloc) => bloc.state is ContestXPEarned
          ? (bloc.state as ContestXPEarned).totalQuestions
          : 0,
    );
    final correctAnswers = context.select<ContestBloc, int?>(
      (bloc) => bloc.state is ContestXPEarned
          ? (bloc.state as ContestXPEarned).correctAnswers
          : 0,
    );
    final incorrectAnswers = context.select<ContestBloc, int?>(
      (bloc) => bloc.state is ContestXPEarned
          ? (bloc.state as ContestXPEarned).incorrectAnswers
          : 0,
    );
    final contestFiltered = context.select<ContestBloc, List<Contest>>((bloc) {
      if (bloc.state is! ContestXPEarned) return <Contest>[];

      final state = bloc.state as ContestXPEarned;
      final contests = state.cachedContests?.content;
      log('contests: $contests');

      if (contests == null) return <Contest>[];

      return contests
          .where((contest) => contest.id == state.contestId)
          .toList();
    });

    log('filtered${contestFiltered.length}');
    return BlocListener<ContestBloc, ContestState>(
      listener: (context, state) {},
      child: PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBarFactory.standardAppBar(
            title: 'Contest Result',
            barHeight: 0,
            showBackButton: false,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                VSpace(20),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: AppColors.blueGradient3,
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
                              '$timeRemaining sec',
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
                        'Great Job $name!',
                        style: AppTextStyles.baseBold(
                          context,
                          color: AppColors.white,
                        ).copyWith(fontSize: 20),
                      ),
                      Text(
                        'Check the leaderboard to see your rank',
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
                        onPressed: () {
                          context.router.push(const ContestReviewRoute());
                        },
                        child: Text(
                          'Review Answers',
                          style: AppTextStyles.smBold(context),
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
                              color: AppColors.success100,
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: Text(
                              'Correct Answers',
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
                              'Wrong Answer',
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
                ButtonFactory.blackButton(
                  mainAxisAlignment: MainAxisAlignment.center,
                  onPressed: () {
                    context.router.push(
                      ContestLeaderBoardRoute(
                        contestId: contestFiltered.first.id ?? '',
                        arguments: {
                          'title': contestFiltered.first.title ?? '',
                          'description': contestFiltered.first.description,
                          'date': contestFiltered.first.endDate,
                        },
                      ),
                    );
                  },
                  text: 'View Leaderboard',
                ),
                VSpace(20),
                ButtonFactory.whiteButton(
                  mainAxisAlignment: MainAxisAlignment.center,
                  hasBorder: true,
                  onPressed: () {
                    final contestBloc = context.read<ContestBloc>();
                    contestBloc.add(
                      GetAllContestsEvent(isBackgroundRefresh: true),
                    );
                    context.router.popUntil(
                      (route) => route.settings.name == ContestRoute.name,
                    );
                  },
                  borderColor: AppColors.gray300,
                  text: 'Back to Contests',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
