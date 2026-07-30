import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learnwayv2/features/statistics/cubit/statistics_cubit.dart';
import 'package:learnwayv2/features/statistics/cubit/statistics_state.dart';
import 'package:learnwayv2/features/statistics/models/statistics_model.dart';
import 'package:learnwayv2/features/statistics/view/widgets/statistics_card.dart';
import 'package:learnwayv2/features/statistics/view/widgets/monthly_xp_chart.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';

@RoutePage()
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StatisticsCubit>().loadStatistics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FC),
      appBar: AppBarFactory.standardAppBar(
        title: 'Statistics',
        backgroundColor: Colors.white,
      ),
      body: BlocBuilder<StatisticsCubit, StatisticsState>(
        builder: (context, state) {
          if (state.errorMessage != null) {
            return _buildErrorState(state.errorMessage!);
          }

          if (state.statistics == null) {
            return _buildEmptyState();
          }

          return _buildStatisticsContent(state.statistics!);
        },
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.error500),
          const VSpace(16),
          Text(
            'Error loading statistics',
            style: AppTextStyles.lgSemiBold(context),
          ),
          const VSpace(8),
          Text(
            error,
            style: AppTextStyles.smRegular(context),
            textAlign: TextAlign.center,
          ),
          const VSpace(16),
          ElevatedButton(
            onPressed: () {
              context.read<StatisticsCubit>().loadStatistics();
            },
            child: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics_outlined, size: 64, color: AppColors.gray400),
          const VSpace(16),
          Text(
            'No Statistics Available',
            style: AppTextStyles.lgSemiBold(context),
          ),
          const VSpace(8),
          Text(
            'Complete some lessons to see your statistics',
            style: AppTextStyles.smRegular(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsContent(StatisticsModel statistics) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            'View your statistics',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          // const VSpace(4),
          Text(
            'See the scores you\'ve earned over a period of time.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF414651),
            ),
          ),
          const VSpace(22),
          // Statistics cards
          Row(
            children: [
              // Badges card
              Expanded(
                child: StatisticsCard(
                  title: 'Badges',
                  totalText: statistics.totalQuestionsAnswered.toString(),
                  labelText: 'Total',
                  progress: 100,
                  progressColor: const Color(0xFF215AEB),
                  icon: SvgPicture.asset(
                    'assets/icons/bar_chart.svg',
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF215AEB),
                      BlendMode.srcIn,
                    ),
                  ),
                  items: [
                    StatisticItem(
                      label: 'Earned',
                      value: statistics.correctAnswers,
                      color: const Color(0xFF215AEB),
                    ),
                    StatisticItem(
                      label: 'Progress',
                      value: statistics.wrongAnswers,
                      color: const Color(0xFF9E77ED),
                    ),
                    StatisticItem(
                      label: 'Not Earned',
                      value: 0,
                      color: const Color(0xFFE8ECF6),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10), // 10px horizontal spacing
              // Lessons card
              Expanded(
                child: StatisticsCard(
                  title: 'Lessons',
                  totalText: statistics.totalBattles.toString().padLeft(2, '0'),
                  labelText: 'Total',
                  progress: 100,
                  progressColor: const Color(0xFF215AEB),
                  icon: SvgPicture.asset(
                    'assets/icons/bar_chart.svg',
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF215AEB),
                      BlendMode.srcIn,
                    ),
                  ),
                  isThreeSegment: true,
                  middleProgress: 0.15, // 15%
                  middleColor: const Color(0xFF9E77ED),
                  items: [
                    StatisticItem(
                      label: 'Completed',
                      value: statistics.battlesWon,
                      color: const Color(0xFF215AEB),
                    ),
                    StatisticItem(
                      label: 'Progress',
                      value: statistics.battlesDraw,
                      color: const Color(0xFF9E77ED),
                    ),
                    StatisticItem(
                      label: 'Not completed',
                      value: statistics.battlesLost,
                      color: const Color(0xFFE8ECF6),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const VSpace(10),
          // Monthly Charts
          Column(
            children: [
              // Total courses completed chart
              MonthlyXPChart(
                title: 'Total courses completed',
                monthlyData: statistics.monthlyXPData,
                totalXP: statistics.totalXP,
                maxXP: statistics.monthlyXPData
                    .map((e) => e.xp)
                    .reduce((a, b) => a > b ? a : b),
              ),
              const VSpace(10),
              // Total quiz completed chart
              MonthlyXPChart(
                title: 'Total quiz completed',
                monthlyData: statistics.monthlyXPData,
                totalXP: statistics.totalXP,
                maxXP: statistics.monthlyXPData
                    .map((e) => e.xp)
                    .reduce((a, b) => a > b ? a : b),
              ),
              const VSpace(10),
              // Total contest completed chart
              MonthlyXPChart(
                title: 'Total contest completed',
                monthlyData: statistics.monthlyXPData,
                totalXP: statistics.totalXP,
                maxXP: statistics.monthlyXPData
                    .map((e) => e.xp)
                    .reduce((a, b) => a > b ? a : b),
              ),
              const VSpace(10),
              // Total battles completed chart
              MonthlyXPChart(
                title: 'Total battles completed',
                monthlyData: statistics.monthlyXPData,
                totalXP: statistics.totalXP,
                maxXP: statistics.monthlyXPData
                    .map((e) => e.xp)
                    .reduce((a, b) => a > b ? a : b),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
