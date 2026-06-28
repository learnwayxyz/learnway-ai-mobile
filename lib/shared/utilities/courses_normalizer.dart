import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/registered_courses.dart';

List<RegisteredCourses<U>> normalizeToRegisteredCourses<T, U>(
  List<T> courses,
  String Function(T) getId,
  DateTime Function(T) getCreatedAt,
  DateTime Function(T) getUpdatedAt,
  DateTime? Function(T) getDeletedAt,
  DateTime Function(T) getEnrolledAt,
  DateTime? Function(T) getCompletedAt,
  int Function(T) getProgress,
  U Function(T) getCourseModel,
) {
  return courses
      .map(
        (c) => RegisteredCourses<U>(
          id: getId(c),
          createdAt: getCreatedAt(c),
          updatedAt: getUpdatedAt(c),
          deletedAt: getDeletedAt(c),
          enrolledAt: getEnrolledAt(c),
          completedAt: getCompletedAt(c),
          progress: getProgress(c),
          course: getCourseModel(c),
        ),
      )
      .toList();
}
