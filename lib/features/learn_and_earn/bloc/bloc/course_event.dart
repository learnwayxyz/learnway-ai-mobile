part of 'course_bloc.dart';

abstract class CoursesEvent extends Equatable {
  const CoursesEvent();

  @override
  List<Object> get props => [];
}

class FetchBeginnerCourses extends CoursesEvent {
  const FetchBeginnerCourses({this.forceRefresh = false});
  final bool forceRefresh;

  @override
  List<Object> get props => [forceRefresh];
}

class FetchIntermediateCourses extends CoursesEvent {
  const FetchIntermediateCourses({this.forceRefresh = false});
  final bool forceRefresh;

  @override
  List<Object> get props => [forceRefresh];
}

class FetchAdvancedCourses extends CoursesEvent {
  const FetchAdvancedCourses({this.forceRefresh = false});
  final bool forceRefresh;

  @override
  List<Object> get props => [forceRefresh];
}

class RefreshCourses extends CoursesEvent {
  const RefreshCourses({required this.levelType});
  final LevelType levelType;

  @override
  List<Object> get props => [levelType];
}

class BackgroundRefreshBeginnerCourses extends CoursesEvent {
  const BackgroundRefreshBeginnerCourses();
}

class BackgroundRefreshIntermediateCourses extends CoursesEvent {
  const BackgroundRefreshIntermediateCourses();
}

class BackgroundRefreshAdvancedCourses extends CoursesEvent {
  const BackgroundRefreshAdvancedCourses();
}

class ResetCoursesBloc extends CoursesEvent {
  const ResetCoursesBloc();
}
