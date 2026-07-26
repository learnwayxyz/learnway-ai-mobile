import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/learning_path_repository.dart';
import 'learning_path_state.dart';

class LearningPathCubit extends Cubit<LearningPathState> {
  LearningPathCubit(this._repository) : super(const LearningPathState());

  final LearningPathRepository _repository;

  Future<void> fetchLearningPaths() async {
    emit(state.copyWith(status: LearningPathStatus.loading));
    final result = await _repository.getLearningPaths();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LearningPathStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (paths) => emit(
        state.copyWith(status: LearningPathStatus.success, paths: paths),
      ),
    );
  }

  Future<void> fetchPathCourses(String pathId) async {
    emit(state.copyWith(pathCoursesStatus: LearningPathStatus.loading));
    final result = await _repository.getCoursesByPath(pathId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          pathCoursesStatus: LearningPathStatus.failure,
          pathCoursesError: failure.message,
        ),
      ),
      (courses) => emit(
        state.copyWith(
          pathCoursesStatus: LearningPathStatus.success,
          pathCourses: courses,
        ),
      ),
    );
  }
}
