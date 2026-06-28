// Create a unified course data wrapper
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/base_models/base_course_models.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';

class CourseDataWrapper {
  CourseDataWrapper({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.enrolledAt,
    this.completedAt,
    required this.progress,
    required this.levelType,
    required this.courseTitle,
    required this.courseDescription,
    required this.skillLevel,
    required this.isActive,
    required this.isPremium,
    required this.enrolledUsersCount,
    required this.course,
  });
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime enrolledAt;
  final DateTime? completedAt;
  final int progress;
  final LevelType levelType;

  final String courseTitle;
  final String courseDescription;
  final String skillLevel;
  final bool isActive;
  final bool isPremium;
  final int enrolledUsersCount;
  final BaseCourseModel course;

  factory CourseDataWrapper.fromBaseCourse(
    BaseRegisteredCourses<BaseCourseModel> courseData,
    LevelType levelType,
  ) {
    return CourseDataWrapper(
      id: courseData.id,
      createdAt: courseData.createdAt,
      updatedAt: courseData.updatedAt,
      deletedAt: courseData.deletedAt,
      enrolledAt: courseData.enrolledAt,
      completedAt: courseData.completedAt,
      progress: courseData.progress,
      levelType: levelType,
      courseTitle: courseData.course.title,
      courseDescription: courseData.course.description,
      skillLevel: courseData.course.skillLevel,
      isActive: courseData.course.isActive,
      isPremium: courseData.course.isPremium,
      enrolledUsersCount: courseData.course.enrolledUsersCount,
      course: courseData.course,
    );
  }
}

void registerCourseData(
  BaseRegisteredCourses<BaseCourseModel> courseData,
  LevelType levelType,
) {
  final wrapper = CourseDataWrapper.fromBaseCourse(courseData, levelType);
  if (locator.isRegistered<CourseDataWrapper>()) {
    locator.unregister<CourseDataWrapper>();
  }

  locator.registerLazySingleton<CourseDataWrapper>(() => wrapper);
}
