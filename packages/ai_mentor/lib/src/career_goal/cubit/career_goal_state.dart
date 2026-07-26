part of 'career_goal_cubit.dart';

abstract class CareerGoalState extends Equatable {
  const CareerGoalState();

  @override
  List<Object?> get props => [];
}

class CareerGoalInitial extends CareerGoalState {}

class CareerGoalGenerating extends CareerGoalState {}

class CareerGoalRoadmapReady extends CareerGoalState {
  const CareerGoalRoadmapReady(this.roadmap);

  final CareerRoadmap roadmap;

  @override
  List<Object?> get props => [roadmap];
}

class CareerGoalError extends CareerGoalState {
  const CareerGoalError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
