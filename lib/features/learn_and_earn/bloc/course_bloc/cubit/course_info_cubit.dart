import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/courses_info_details.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_repository/learn_and_earn_repository.dart';

part 'course_info_state.dart';

class CourseInfoCubit extends Cubit<CourseInfoState> {
  final LearnAndEarnRepository repository;

  CourseInfoCubit({required this.repository}) : super(CourseInfoStateInitial());

  Future<void> fetchCourseInfo(String courseId) async {
    emit(CourseInfoLoading());
    try {
      final result = await repository.fetchCourseInfoDetails(courseId);
      result.fold(
        (failure) => emit(CourseInfoError(failure.message)),
        (data) => emit(CourseInfoLoaded(data)),
      );
    } catch (e) {
      emit(CourseInfoError(e.toString()));
    }
  }
}
