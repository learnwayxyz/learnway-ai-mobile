import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/career_roadmap_model.dart';
import '../repository/career_goal_repository.dart';

part 'career_goal_state.dart';

class CareerGoalCubit extends Cubit<CareerGoalState> {
  CareerGoalCubit(this._repository) : super(CareerGoalInitial());

  final CareerGoalRepository _repository;

  Future<void> generateGoal(String userId, String goal) async {
    emit(CareerGoalGenerating());

    final result = await _repository.generateRoadmap(userId, goal);

    result.fold((failure) => emit(CareerGoalError(failure.message)), (roadmap) {
      _repository.saveCareerGoal(userId, goal);
      emit(CareerGoalRoadmapReady(roadmap));
      log('is Event Emitted: ${state is CareerGoalRoadmapReady}');
    });
  }

  void reset() => emit(CareerGoalInitial());
}
