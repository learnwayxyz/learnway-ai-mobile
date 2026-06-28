part of 'registered_course_bloc.dart';

abstract class RegisteredCoursesState extends Equatable {
  const RegisteredCoursesState();

  @override
  List<Object?> get props => [];
}

class RegisteredCoursesInitial extends RegisteredCoursesState {}

// Beginner States
class LoadingBeginnerRegisteredCourses extends RegisteredCoursesState {
  const LoadingBeginnerRegisteredCourses(this.lessons);
  final List<LearnWayCourses>? lessons;

  @override
  List<Object?> get props => [lessons];
}

class LoadedBeginnerRegisteredCourses extends RegisteredCoursesState {
  const LoadedBeginnerRegisteredCourses(
    this.registeredCourses, {
    this.allCourses,
    this.isBackgroundRefresh = false,
  });
  final List<BeginnerRegisteredCourses> registeredCourses;
  final List<LearnWayCourses>? allCourses;
  final bool isBackgroundRefresh;

  @override
  List<Object?> get props => [
    registeredCourses,
    allCourses,
    isBackgroundRefresh,
  ];
}

class LoadedBeginnerRegisteredCoursesError extends RegisteredCoursesState {
  const LoadedBeginnerRegisteredCoursesError(this.error, {this.lessons});
  final String error;
  final List<LearnWayCourses>? lessons;

  @override
  List<Object?> get props => [error, lessons];
}

// Intermediate States
class LoadingIntermediateRegisteredCourses extends RegisteredCoursesState {
  const LoadingIntermediateRegisteredCourses(this.lessons);
  final List<LearnWayCourses>? lessons;

  @override
  List<Object?> get props => [lessons];
}

class LoadedIntermediateRegisteredCourses extends RegisteredCoursesState {
  const LoadedIntermediateRegisteredCourses(
    this.registeredCourses, {
    this.allCourses,
    this.isBackgroundRefresh = false,
  });
  final List<IntermediateRegisteredCourse> registeredCourses;
  final List<LearnWayCourses>? allCourses;
  final bool isBackgroundRefresh;

  @override
  List<Object?> get props => [
    registeredCourses,
    allCourses,
    isBackgroundRefresh,
  ];
}

class LoadedIntermediateRegisteredCoursesError extends RegisteredCoursesState {
  const LoadedIntermediateRegisteredCoursesError(this.error, {this.lessons});
  final String error;
  final List<LearnWayCourses>? lessons;

  @override
  List<Object?> get props => [error, lessons];
}

// Advanced States
class LoadingAdvancedRegisteredCourses extends RegisteredCoursesState {
  const LoadingAdvancedRegisteredCourses(this.lessons);
  final List<LearnWayCourses>? lessons;

  @override
  List<Object?> get props => [lessons];
}

class LoadedAdvancedRegisteredCourses extends RegisteredCoursesState {
  const LoadedAdvancedRegisteredCourses(
    this.registeredCourses, {
    this.allCourses,
    this.isBackgroundRefresh = false,
  });
  final List<AdvancedRegisteredCourses> registeredCourses;
  final List<LearnWayCourses>? allCourses;
  final bool isBackgroundRefresh;

  @override
  List<Object?> get props => [
    registeredCourses,
    allCourses,
    isBackgroundRefresh,
  ];
}

class LoadedAdvancedRegisteredCoursesError extends RegisteredCoursesState {
  const LoadedAdvancedRegisteredCoursesError(this.error, {this.lessons});
  final String error;
  final List<LearnWayCourses>? lessons;

  @override
  List<Object?> get props => [error, lessons];
}
