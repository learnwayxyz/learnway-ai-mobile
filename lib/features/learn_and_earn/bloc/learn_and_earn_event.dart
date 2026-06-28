part of 'learn_and_earn_bloc.dart';

abstract class LearnAndEarnEvent extends Equatable {
  const LearnAndEarnEvent();

  @override
  List<Object> get props => [];
}

class LoadLessons extends LearnAndEarnEvent {
  const LoadLessons({this.forceRefresh = false});
  final bool forceRefresh;
}

class LoadMyRegisteredCourses extends LearnAndEarnEvent {
  const LoadMyRegisteredCourses({this.forceRefresh = false});
  final bool forceRefresh;
}

class LoadAdvancedRegisteredCourses extends LearnAndEarnEvent {
  const LoadAdvancedRegisteredCourses({this.forceRefresh = false});
  final bool forceRefresh;
}

class LoadBeginnerRegisteredCourses extends LearnAndEarnEvent {
  const LoadBeginnerRegisteredCourses({this.forceRefresh = false});
  final bool forceRefresh;
}

class LoadIntermediateRegisteredCourses extends LearnAndEarnEvent {
  const LoadIntermediateRegisteredCourses({this.forceRefresh = false});
  final bool forceRefresh;
}

class CompleteLesson extends LearnAndEarnEvent {
  const CompleteLesson({required this.lessonId});
  final int lessonId;
}

class CompleteLessonFromLessonScreen extends LearnAndEarnEvent {
  const CompleteLessonFromLessonScreen({required this.lessonId});
  final int lessonId;
}

class EnrollCourse extends LearnAndEarnEvent {
  const EnrollCourse({required this.courseId});
  final String courseId;
}

class FetchCourseLessons extends LearnAndEarnEvent {
  const FetchCourseLessons({required this.id, this.forceRefresh = false});
  final String id;
  final bool forceRefresh;
}

class FetchLessonSlides extends LearnAndEarnEvent {
  const FetchLessonSlides({required this.id, this.forceRefresh = false});
  final String id;
  final bool forceRefresh;
}

class LoadAllCourses extends LearnAndEarnEvent {
  const LoadAllCourses({this.forceRefresh = false});
  final bool forceRefresh;
}

class MarkLessonCompleted extends LearnAndEarnEvent {
  const MarkLessonCompleted({required this.courseId, required this.lessonId});
  final String courseId;
  final int lessonId;
}

class FetchBeginnerLessons extends LearnAndEarnEvent {
  const FetchBeginnerLessons({this.forceRefresh = false});
  final bool forceRefresh;
  @override
  List<Object> get props => [forceRefresh];
}

class FetchIntermediateLessons extends LearnAndEarnEvent {
  const FetchIntermediateLessons({this.forceRefresh = false});
  final bool forceRefresh;
}

class FetchAdvancedLessons extends LearnAndEarnEvent {
  const FetchAdvancedLessons({this.forceRefresh = false});
  final bool forceRefresh;
}

class EnrollBeginnerCourse extends LearnAndEarnEvent {
  final String courseId;

  const EnrollBeginnerCourse(this.courseId);

  @override
  List<Object> get props => [courseId];
}

class EnrollIntermediateCourse extends LearnAndEarnEvent {
  final String courseId;

  const EnrollIntermediateCourse(this.courseId);

  @override
  List<Object> get props => [courseId];
}

class EnrollAdvancedCourse extends LearnAndEarnEvent {
  final String courseId;

  const EnrollAdvancedCourse(this.courseId);

  @override
  List<Object> get props => [courseId];
}

class ResetLearnAndEarnBloc extends LearnAndEarnEvent {
  const ResetLearnAndEarnBloc();
}

class StartLesson extends LearnAndEarnEvent {
  const StartLesson({required this.lessonId, required this.courseId});
  final String lessonId;
  final String courseId;
}

class GetLessonProgress extends LearnAndEarnEvent {
  const GetLessonProgress({required this.courseId});
  final String courseId;
}

class FetchDailyLessonsRemaining extends LearnAndEarnEvent {
  const FetchDailyLessonsRemaining();
}

class AskAiTutorWithQuickPrompt extends LearnAndEarnEvent {
  const AskAiTutorWithQuickPrompt({
    required this.lessonId,
    required this.promptType,
    required this.displayLabel,
  }) : assert(promptType != AiTutorPromptType.custom);

  final String lessonId;
  final AiTutorPromptType promptType;
  final String displayLabel;

  @override
  List<Object> get props => [lessonId, promptType, displayLabel];
}

class AskAiTutorWithCustomQuestion extends LearnAndEarnEvent {
  const AskAiTutorWithCustomQuestion({
    required this.lessonId,
    required this.customQuestion,
  });

  final String lessonId;
  final String customQuestion;

  @override
  List<Object> get props => [lessonId, customQuestion];
}
