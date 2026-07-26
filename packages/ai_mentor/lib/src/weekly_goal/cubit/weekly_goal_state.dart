part of 'weekly_goal_cubit.dart';

sealed class WeeklyGoalState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WeeklyGoalInitial extends WeeklyGoalState {}

class WeeklyGoalLoading extends WeeklyGoalState {}

class WeeklyGoalLoaded extends WeeklyGoalState {
  WeeklyGoalLoaded(this.weeklyGoal);

  final String weeklyGoal;

  @override
  List<Object?> get props => [weeklyGoal];
}

class WeeklyGoalHidden extends WeeklyGoalState {}
