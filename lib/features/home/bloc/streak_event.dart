import 'package:equatable/equatable.dart';
import 'package:learnwayv2/features/home/home_repository/user_profile_model.dart';

abstract class StreakEvent extends Equatable {
  const StreakEvent();

  @override
  List<Object> get props => [];
}

class LoadStreakData extends StreakEvent {
  const LoadStreakData();
}

class UpdateProgress extends StreakEvent {
  const UpdateProgress({required this.currentDay, required this.totalDays});
  final int currentDay;
  final int totalDays;
  @override
  List<Object> get props => [currentDay, totalDays];
}

class UpdateStreakDays extends StreakEvent {
  final int streakDays;

  const UpdateStreakDays(this.streakDays);

  @override
  List<Object> get props => [streakDays];
}

class ToggleWeekDay extends StreakEvent {
  final int dayIndex;

  const ToggleWeekDay(this.dayIndex);

  @override
  List<Object> get props => [dayIndex];
}

class PlayButtonPressed extends StreakEvent {
  const PlayButtonPressed();
}

class ResetStreak extends StreakEvent {
  const ResetStreak();
}

class InitializeWeeklyProgress extends StreakEvent {
  final List<bool> weeklyProgress;

  const InitializeWeeklyProgress(this.weeklyProgress);

  @override
  List<Object> get props => [weeklyProgress];
}

class InitializeStreakFromProfile extends StreakEvent {
  final UserProfileModel profile;

  const InitializeStreakFromProfile(this.profile);

  @override
  List<Object> get props => [profile];
}
