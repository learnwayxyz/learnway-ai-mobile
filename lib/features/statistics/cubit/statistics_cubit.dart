import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/features/statistics/cubit/statistics_state.dart';
import 'package:learnwayv2/features/statistics/models/statistics_model.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit() : super(const StatisticsState());

  void loadStatistics() {
    // Load statistics immediately since there are no API requests
    final statistics = _getDummyStatistics();
    emit(state.copyWith(isLoading: false, statistics: statistics));
  }

  StatisticsModel _getDummyStatistics() {
    return StatisticsModel(
      totalQuestionsAnswered: 22,
      correctAnswers: 20,
      wrongAnswers: 2,
      totalBattles: 6,
      battlesWon: 2,
      battlesLost: 2,
      battlesDraw: 2,
      totalXP: 30200.0,
      monthlyXPData: [
        const MonthlyXPData(month: 'Jan', xp: 200, isHighest: false),
        const MonthlyXPData(month: 'Feb', xp: 450, isHighest: false),
        const MonthlyXPData(month: 'Mar', xp: 320, isHighest: false),
        const MonthlyXPData(month: 'Apr', xp: 380, isHighest: false),
        const MonthlyXPData(month: 'May', xp: 290, isHighest: false),
        const MonthlyXPData(month: 'Jun', xp: 500, isHighest: true),
        const MonthlyXPData(month: 'Jul', xp: 420, isHighest: false),
        const MonthlyXPData(month: 'Aug', xp: 180, isHighest: false),
        const MonthlyXPData(month: 'Sep', xp: 350, isHighest: false),
        const MonthlyXPData(month: 'Oct', xp: 280, isHighest: false),
        const MonthlyXPData(month: 'Nov', xp: 310, isHighest: false),
        const MonthlyXPData(month: 'Dec', xp: 400, isHighest: false),
      ],
    );
  }
}
