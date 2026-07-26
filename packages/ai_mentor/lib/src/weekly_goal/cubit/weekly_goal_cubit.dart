import 'dart:developer';

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../career_goal/repository/career_goal_repository.dart';

part 'weekly_goal_state.dart';

class WeeklyGoalCubit extends Cubit<WeeklyGoalState> {
  WeeklyGoalCubit({
    required CareerGoalRepository repository,
    required String Function() getUserId,
  })  : _repository = repository,
        _getUserId = getUserId,
        super(WeeklyGoalInitial());

  final CareerGoalRepository _repository;
  final String Function() _getUserId;

  Future<void> load() async {
    if (state is WeeklyGoalLoading) return;

    final userId = _getUserId();
    if (userId.isEmpty) {
      emit(WeeklyGoalHidden());
      return;
    }

    final currentWeek = _isoWeekKey(DateTime.now());
    final prefs = await SharedPreferences.getInstance();

    final dismissedWeek =
        prefs.getString('$weeklyGoalDismissedWeekKey-$userId');
    if (dismissedWeek == currentWeek) {
      emit(WeeklyGoalHidden());
      return;
    }

    final storedWeek = prefs.getString('$weeklyGoalWeekKey-$userId');
    final cachedText = prefs.getString('$weeklyGoalTextKey-$userId');

    if (storedWeek == currentWeek && cachedText != null) {
      emit(WeeklyGoalLoaded(cachedText));
      return;
    }

    emit(WeeklyGoalLoading());

    final result = await _repository.recommendations(userId);

    result.fold(
      (failure) {
        log('WeeklyGoalCubit: recommendations error: ${failure.message}');
        if (cachedText != null) {
          emit(WeeklyGoalLoaded(cachedText));
        } else {
          emit(WeeklyGoalHidden());
        }
      },
      (data) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('$weeklyGoalTextKey-$userId', data.weeklyGoal);
        await prefs.setString('$weeklyGoalWeekKey-$userId', currentWeek);
        emit(WeeklyGoalLoaded(data.weeklyGoal));
      },
    );
  }

  Future<void> dismiss() async {
    final userId = _getUserId();
    final currentWeek = _isoWeekKey(DateTime.now());
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$weeklyGoalDismissedWeekKey-$userId', currentWeek);
    emit(WeeklyGoalHidden());
  }

  String _isoWeekKey(DateTime d) {
    final dayOfYear = d.difference(DateTime(d.year, 1, 1)).inDays + 1;
    final week = ((dayOfYear - d.weekday + 10) / 7).floor();
    return '${d.year}-W${week.toString().padLeft(2, '0')}';
  }
}
