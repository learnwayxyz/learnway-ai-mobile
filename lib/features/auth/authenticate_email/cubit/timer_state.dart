part of 'timer_cubit.dart';

abstract class TimerState extends Equatable {
  const TimerState();
}

class TimerInitial extends TimerState {
  const TimerInitial();

  @override
  List<Object?> get props => [];
}

class TimerRunning extends TimerState {
  const TimerRunning(this.remainingSeconds);

  final int remainingSeconds;

  @override
  List<Object?> get props => [remainingSeconds];
}

class TimerCompleted extends TimerState {
  const TimerCompleted();

  @override
  List<Object?> get props => [];
}
