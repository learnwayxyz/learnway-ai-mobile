part of 'course_bloc.dart';

abstract class CoursesState extends Equatable {
  const CoursesState();

  @override
  List<Object?> get props => [];
}

class CoursesInitial extends CoursesState {}

class FetchingBeginnerCourses extends CoursesState {}

class FetchedBeginnerCourses extends CoursesState {
  const FetchedBeginnerCourses(
    this.courses, {
    this.isBackgroundRefresh = false,
  });
  final List<LearnWayCourses> courses;
  final bool isBackgroundRefresh;

  @override
  List<Object> get props => [courses, isBackgroundRefresh];
}

class FetchBeginnerCoursesError extends CoursesState {
  const FetchBeginnerCoursesError(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}

class FetchingIntermediateCourses extends CoursesState {}

class FetchedIntermediateCourses extends CoursesState {
  const FetchedIntermediateCourses(
    this.courses, {
    this.isBackgroundRefresh = false,
  });
  final List<LearnWayCourses> courses;
  final bool isBackgroundRefresh;

  @override
  List<Object> get props => [courses, isBackgroundRefresh];
}

class FetchIntermediateCoursesError extends CoursesState {
  const FetchIntermediateCoursesError(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}

class FetchingAdvancedCourses extends CoursesState {}

class FetchedAdvancedCourses extends CoursesState {
  const FetchedAdvancedCourses(
    this.courses, {
    this.isBackgroundRefresh = false,
  });
  final List<LearnWayCourses> courses;
  final bool isBackgroundRefresh;

  @override
  List<Object> get props => [courses, isBackgroundRefresh];
}

class FetchAdvancedCoursesError extends CoursesState {
  const FetchAdvancedCoursesError(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
