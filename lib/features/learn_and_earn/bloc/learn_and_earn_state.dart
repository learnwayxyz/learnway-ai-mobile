part of 'learn_and_earn_bloc.dart';

abstract class LearnAndEarnState extends Equatable {
  const LearnAndEarnState();

  @override
  List<Object?> get props => [];
}

class LearnAndEarnInitial extends LearnAndEarnState {
  @override
  List<Object?> get props => [];
}

class LoadingCourses extends LearnAndEarnState {
  @override
  List<Object?> get props => [];
}

class LoadedCourses extends LearnAndEarnState {
  const LoadedCourses(this.lessons);
  final List<LearnWayCourses> lessons;

  @override
  List<Object?> get props => [lessons];
}

class LoadedCoursesError extends LearnAndEarnState {
  const LoadedCoursesError(this.error);
  final String error;

  @override
  List<Object?> get props => [error];
}

class FetchingCourseLessons extends LearnAndEarnState {
  const FetchingCourseLessons({this.courseLessons});
  final CourseLesson? courseLessons;

  @override
  List<Object?> get props => [courseLessons];
}

class FetchedCourseLessons extends LearnAndEarnState {
  const FetchedCourseLessons(
    this.courseLessons, {
    this.showSuccessSnackbar = false,
    this.lessonInfo,
  });
  final CourseLesson courseLessons;
  final CoursesInfoDetails? lessonInfo;
  final bool showSuccessSnackbar;

  @override
  List<Object?> get props => [courseLessons, lessonInfo, showSuccessSnackbar];
}

class FetchCourseLessonsError extends LearnAndEarnState {
  const FetchCourseLessonsError(this.error, {this.courseLessons});
  final String error;
  final CourseLesson? courseLessons;

  @override
  List<Object?> get props => [error, courseLessons];
}

class FetchingLessonSlide extends LearnAndEarnState {
  const FetchingLessonSlide({this.courseLessons});
  final CourseLesson? courseLessons;

  @override
  List<Object?> get props => [courseLessons];
}

class FetchedLessonSlide extends LearnAndEarnState {
  const FetchedLessonSlide(this.slide, {this.courseLessons});
  final LessonSlidesResponse slide;
  final CourseLesson? courseLessons;

  @override
  List<Object?> get props => [slide, courseLessons];
}

class FetchLessonSlideError extends LearnAndEarnState {
  const FetchLessonSlideError(this.error, {this.courseLessons});
  final String error;
  final CourseLesson? courseLessons;

  @override
  List<Object?> get props => [error, courseLessons];
}

class FetchingBeginnerLessons extends LearnAndEarnState {
  const FetchingBeginnerLessons();

  @override
  List<Object?> get props => [];
}

class FetchedBeginnerLessons extends LearnAndEarnState {
  const FetchedBeginnerLessons(this.lesson);
  final List<LearnWayCourses> lesson;

  @override
  List<Object?> get props => [lesson];
}

class FetchBeginnerLessonsError extends LearnAndEarnState {
  const FetchBeginnerLessonsError(this.error);
  final String error;

  @override
  List<Object?> get props => [error];
}

class FetchingIntermediateLessons extends LearnAndEarnState {
  const FetchingIntermediateLessons();

  @override
  List<Object?> get props => [];
}

class FetchedIntermediateLessons extends LearnAndEarnState {
  const FetchedIntermediateLessons(this.lesson);
  final List<LearnWayCourses> lesson;

  @override
  List<Object?> get props => [lesson];
}

class FetchIntermediateLessonsError extends LearnAndEarnState {
  const FetchIntermediateLessonsError(this.error);
  final String error;

  @override
  List<Object?> get props => [error];
}

class FetchingAdvancedLessons extends LearnAndEarnState {
  const FetchingAdvancedLessons();

  @override
  List<Object?> get props => [];
}

class FetchedAdvancedLessons extends LearnAndEarnState {
  const FetchedAdvancedLessons(this.lesson);
  final List<LearnWayCourses> lesson;

  @override
  List<Object?> get props => [lesson];
}

class FetchAdvancedLessonsError extends LearnAndEarnState {
  const FetchAdvancedLessonsError(this.error);
  final String error;

  @override
  List<Object?> get props => [error];
}

class EnrollingBeginnerCourse extends LearnAndEarnState {
  const EnrollingBeginnerCourse(this.lessons);
  final List<LearnWayCourses>? lessons;

  @override
  List<Object?> get props => [lessons];
}

class EnrollingIntermediateCourse extends LearnAndEarnState {
  const EnrollingIntermediateCourse(this.lessons);
  final List<LearnWayCourses>? lessons;

  @override
  List<Object?> get props => [lessons];
}

class EnrollingAdvancedCourse extends LearnAndEarnState {
  const EnrollingAdvancedCourse(this.lessons);
  final List<LearnWayCourses>? lessons;

  @override
  List<Object?> get props => [lessons];
}

class EnrolledBeginnerCourse extends LearnAndEarnState {
  final EnrollmentResponse enrollmentResponse;
  final List<LearnWayCourses> courses;
  final List<BeginnerRegisteredCourses> myRegisteredCourses;

  const EnrolledBeginnerCourse(
    this.enrollmentResponse, {
    required this.courses,
    required this.myRegisteredCourses,
  });

  @override
  List<Object?> get props => [enrollmentResponse, courses, myRegisteredCourses];
}

class EnrolledIntermediateCourse extends LearnAndEarnState {
  final EnrollmentResponse enrollmentResponse;
  final List<LearnWayCourses> courses;
  final List<IntermediateRegisteredCourse> myRegisteredCourses;

  const EnrolledIntermediateCourse(
    this.enrollmentResponse, {
    required this.courses,
    required this.myRegisteredCourses,
  });

  @override
  List<Object?> get props => [enrollmentResponse, courses, myRegisteredCourses];
}

class EnrolledAdvancedCourse extends LearnAndEarnState {
  final EnrollmentResponse enrollmentResponse;
  final List<LearnWayCourses> courses;
  final List<AdvancedRegisteredCourses> myRegisteredCourses;

  const EnrolledAdvancedCourse(
    this.enrollmentResponse, {
    required this.courses,
    required this.myRegisteredCourses,
  });

  @override
  List<Object?> get props => [enrollmentResponse, courses, myRegisteredCourses];
}

class EnrollBeginnerCourseError extends LearnAndEarnState {
  const EnrollBeginnerCourseError(this.message, {this.lessons});
  final String message;
  final List<LearnWayCourses>? lessons;

  @override
  List<Object?> get props => [message, lessons];
}

class EnrollIntermediateCourseError extends LearnAndEarnState {
  const EnrollIntermediateCourseError(this.message, this.lessons);
  final List<LearnWayCourses>? lessons;
  final String message;

  @override
  List<Object?> get props => [message, lessons];
}

class EnrollAdvancedCourseError extends LearnAndEarnState {
  const EnrollAdvancedCourseError(this.message, this.lessons);
  final String message;
  final List<LearnWayCourses>? lessons;

  @override
  List<Object?> get props => [message, lessons];
}

class StartingLesson extends LearnAndEarnState {
  const StartingLesson();
  @override
  List<Object?> get props => [];
}

class StartedLesson extends LearnAndEarnState {
  const StartedLesson(this.startLessonResponse);
  final StartLessonResponse startLessonResponse;
  @override
  List<Object?> get props => [startLessonResponse];
}

class StartedLessonError extends LearnAndEarnState {
  const StartedLessonError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class GettingLessonProgress extends LearnAndEarnState {
  const GettingLessonProgress();
  @override
  List<Object?> get props => [];
}

class GotLessonProgress extends LearnAndEarnState {
  const GotLessonProgress(this.lessonProgressResponse);
  final LessonProgressResponse lessonProgressResponse;
  @override
  List<Object?> get props => [lessonProgressResponse];
}

class GotLessonProgressError extends LearnAndEarnState {
  const GotLessonProgressError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class AiTutorLoading extends LearnAndEarnState {
  const AiTutorLoading();
  @override
  List<Object?> get props => [];
}

class AiTutorResponseReceived extends LearnAndEarnState {
  const AiTutorResponseReceived(this.data);
  final AiTutorResponseData data;
  @override
  List<Object?> get props => [data];
}

class AiTutorRequestFailed extends LearnAndEarnState {
  const AiTutorRequestFailed(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class AiTutorLessonLimitReached extends LearnAndEarnState {
  const AiTutorLessonLimitReached();
  @override
  List<Object?> get props => [];
}

class AiTutorDailyLimitReached extends LearnAndEarnState {
  const AiTutorDailyLimitReached();
  @override
  List<Object?> get props => [];
}

class LoadingLessonInfo extends LearnAndEarnState {
  const LoadingLessonInfo();
  @override
  List<Object?> get props => [];
}

class LoadedLessonInfo extends LearnAndEarnState {
  const LoadedLessonInfo(this.data);
  final CoursesInfoDetails data;
  @override
  List<Object?> get props => [data];
}

class LoadedLessonInfoError extends LearnAndEarnState {
  const LoadedLessonInfoError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
