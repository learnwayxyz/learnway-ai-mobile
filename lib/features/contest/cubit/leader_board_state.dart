part of 'leader_board_cubit.dart';

sealed class LeaderBoardState extends Equatable {
  const LeaderBoardState();

  @override
  List<Object?> get props => [];
}

final class LoadingLeaderBoardState extends LeaderBoardState {}

final class LeaderBoardLoaded extends LeaderBoardState {
  const LeaderBoardLoaded({
    required this.participants,
    required this.myRank,
    required this.total,
  });

  final List<ContestLeaderboardParticipant> participants;
  final int myRank;
  final int total;

  @override
  List<Object?> get props => [participants, myRank, total];
}

final class LeaderBoardError extends LeaderBoardState {
  const LeaderBoardError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
