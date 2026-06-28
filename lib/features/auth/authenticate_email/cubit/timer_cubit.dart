import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(const TimerInitial());

  Timer? _timer;
  static const int _initialDuration = 60;

  void startTimer() {
    _timer?.cancel();
    emit(const TimerRunning(_initialDuration));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentState = state;
      if (currentState is TimerRunning) {
        if (currentState.remainingSeconds > 0) {
          emit(TimerRunning(currentState.remainingSeconds - 1));
        } else {
          timer.cancel();
          emit(const TimerCompleted());
        }
      }
    });
  }

  void resetTimer() {
    _timer?.cancel();
    emit(const TimerInitial());
  }

  void restartTimer() {
    startTimer();
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
