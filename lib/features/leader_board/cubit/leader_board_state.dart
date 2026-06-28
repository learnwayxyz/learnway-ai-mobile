part of 'leader_board_cubit.dart';

abstract class LeaderBoardState extends Equatable {
  const LeaderBoardState();
  
  @override
  List<Object?> get props => [];
}

class LeaderBoardInitial extends LeaderBoardState {}

class LeaderBoardLoading extends LeaderBoardState {}

class LeaderBoardLoaded extends LeaderBoardState {
  final LeaderboardResponseModel leaderboard;
  final MyPositionModel? myPosition;
  final String period; // 'alltime', 'monthly', 'weekly'
  final bool isRefreshing; // true when fetching in background

  const LeaderBoardLoaded({
    required this.leaderboard,
    this.myPosition,
    required this.period,
    this.isRefreshing = false,
  });

  LeaderBoardLoaded copyWith({
    LeaderboardResponseModel? leaderboard,
    MyPositionModel? myPosition,
    String? period,
    bool? isRefreshing,
  }) {
    return LeaderBoardLoaded(
      leaderboard: leaderboard ?? this.leaderboard,
      myPosition: myPosition ?? this.myPosition,
      period: period ?? this.period,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [leaderboard, myPosition, period, isRefreshing];
}

class LeaderBoardError extends LeaderBoardState {
  final String message;

  const LeaderBoardError(this.message);

  @override
  List<Object> get props => [message];
}
