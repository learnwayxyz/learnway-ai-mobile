part of 'registered_course_bloc.dart';

abstract class RegisteredCoursesEvent extends Equatable {
  const RegisteredCoursesEvent();

  @override
  List<Object> get props => [];
}

class LoadBeginnerRegisteredCourses extends RegisteredCoursesEvent {
  const LoadBeginnerRegisteredCourses({this.forceRefresh = false});
  final bool forceRefresh;

  @override
  List<Object> get props => [forceRefresh];
}

class LoadIntermediateRegisteredCourses extends RegisteredCoursesEvent {
  const LoadIntermediateRegisteredCourses({this.forceRefresh = false});
  final bool forceRefresh;

  @override
  List<Object> get props => [forceRefresh];
}

class LoadAdvancedRegisteredCourses extends RegisteredCoursesEvent {
  const LoadAdvancedRegisteredCourses({this.forceRefresh = false});
  final bool forceRefresh;

  @override
  List<Object> get props => [forceRefresh];
}

class RefreshRegisteredCourses extends RegisteredCoursesEvent {
  const RefreshRegisteredCourses({required this.levelType});
  final LevelType levelType;

  @override
  List<Object> get props => [levelType];
}

// Events to update cached data from external sources (like after enrollment)
class UpdateBeginnerRegisteredCourses extends RegisteredCoursesEvent {
  const UpdateBeginnerRegisteredCourses({required this.courses});
  final List<BeginnerRegisteredCourses> courses;

  @override
  List<Object> get props => [courses];
}

class UpdateIntermediateRegisteredCourses extends RegisteredCoursesEvent {
  const UpdateIntermediateRegisteredCourses({required this.courses});
  final List<IntermediateRegisteredCourse> courses;

  @override
  List<Object> get props => [courses];
}

class UpdateAdvancedRegisteredCourses extends RegisteredCoursesEvent {
  const UpdateAdvancedRegisteredCourses({required this.courses});
  final List<AdvancedRegisteredCourses> courses;

  @override
  List<Object> get props => [courses];
}

class BackgroundRefreshBeginnerRegisteredCourses
    extends RegisteredCoursesEvent {
  const BackgroundRefreshBeginnerRegisteredCourses();
}

class BackgroundRefreshIntermediateRegisteredCourses
    extends RegisteredCoursesEvent {
  const BackgroundRefreshIntermediateRegisteredCourses();
}

class BackgroundRefreshAdvancedRegisteredCourses
    extends RegisteredCoursesEvent {
  const BackgroundRefreshAdvancedRegisteredCourses();
}

class ResetRegisteredCoursesBloc extends RegisteredCoursesEvent {
  const ResetRegisteredCoursesBloc();
}
