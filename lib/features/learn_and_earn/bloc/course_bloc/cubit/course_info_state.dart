part of 'course_info_cubit.dart';

sealed class CourseInfoState extends Equatable {
  const CourseInfoState();

  @override
  List<Object> get props => [];
}

final class CourseInfoStateInitial extends CourseInfoState {}

final class CourseInfoLoading extends CourseInfoState {}

final class CourseInfoLoaded extends CourseInfoState {
  const CourseInfoLoaded(this.data);
  final LessonInfoDetails data;

  @override
  List<Object> get props => [data];
}

final class CourseInfoError extends CourseInfoState {
  const CourseInfoError(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
