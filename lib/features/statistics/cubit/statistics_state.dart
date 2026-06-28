import 'package:learnwayv2/features/statistics/models/statistics_model.dart';

class StatisticsState {
  final bool isLoading;
  final StatisticsModel? statistics;
  final String? errorMessage;

  const StatisticsState({
    this.isLoading = false,
    this.statistics,
    this.errorMessage,
  });

  StatisticsState copyWith({
    bool? isLoading,
    StatisticsModel? statistics,
    String? errorMessage,
  }) {
    return StatisticsState(
      isLoading: isLoading ?? this.isLoading,
      statistics: statistics ?? this.statistics,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
