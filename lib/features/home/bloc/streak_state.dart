import 'package:equatable/equatable.dart';

abstract class StreakState extends Equatable {
  const StreakState();

  @override
  List<Object?> get props => [];
}

class StreakInitial extends StreakState {
  const StreakInitial();
}

class StreakLoading extends StreakState {
  const StreakLoading();
}

class StreakLoaded extends StreakState {
  const StreakLoaded({
    required this.streakDays,
    required this.currentDay,
    required this.totalDays,
    required this.weeklyProgress,
    this.isPlayButtonPressed = false,
    required this.lastUpdated,
    this.nextClaimAt,
  });

  final int streakDays;
  final int currentDay;
  final int totalDays;
  final List<bool> weeklyProgress;
  final bool isPlayButtonPressed;
  final DateTime lastUpdated;
  final DateTime? nextClaimAt;

  StreakLoaded copyWith({
    int? streakDays,
    int? currentDay,
    int? totalDays,
    List<bool>? weeklyProgress,
    bool? isPlayButtonPressed,
    DateTime? lastUpdated,
    DateTime? nextClaimAt,
  }) {
    return StreakLoaded(
      streakDays: streakDays ?? this.streakDays,
      currentDay: currentDay ?? this.currentDay,
      totalDays: totalDays ?? this.totalDays,
      weeklyProgress: weeklyProgress ?? this.weeklyProgress,
      isPlayButtonPressed: isPlayButtonPressed ?? this.isPlayButtonPressed,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      nextClaimAt: nextClaimAt ?? this.nextClaimAt,
    );
  }

  double get progressPercentage => currentDay / totalDays;

  int get completedDaysThisWeek => weeklyProgress.where((day) => day).length;

  bool get isWeekCompleted => weeklyProgress.every((day) => day);

  bool get canClaimToday {
    if (nextClaimAt == null) return true;
    return DateTime.now().isAfter(nextClaimAt!);
  }

  @override
  List<Object?> get props => [
    streakDays,
    currentDay,
    totalDays,
    weeklyProgress,
    isPlayButtonPressed,
    lastUpdated,
    nextClaimAt,
  ];
}

class StreakClaiming extends StreakState {
  const StreakClaiming();
}

class StreakClaimSuccess extends StreakState {
  final int gemsAwarded;
  final int xpAwarded;
  final int currentStreak;
  final DateTime? nextClaimAt;

  const StreakClaimSuccess({
    required this.gemsAwarded,
    required this.xpAwarded,
    required this.currentStreak,
    this.nextClaimAt,
  });

  @override
  List<Object?> get props => [gemsAwarded, xpAwarded, currentStreak, nextClaimAt];
}

class StreakClaimFailed extends StreakState {
  final String message;

  const StreakClaimFailed(this.message);

  @override
  List<Object?> get props => [message];
}

class StreakError extends StreakState {
  final String message;

  const StreakError(this.message);

  @override
  List<Object?> get props => [message];
}
