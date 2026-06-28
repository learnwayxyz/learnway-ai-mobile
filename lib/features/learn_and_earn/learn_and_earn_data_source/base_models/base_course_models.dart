import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/enrolled_learnway_courses.dart';

abstract class BaseCourseModel {
  String get id;
  DateTime get createdAt;
  DateTime get updatedAt;
  DateTime? get deletedAt;
  String get title;
  String get description;
  String get skillLevel;
  bool get isActive;
  bool get isPremium;
  int get enrolledUsersCount;
  List<User> get latestEnrolledUsers;
}

abstract class BaseRegisteredCourses<T extends BaseCourseModel> {
  String get id;
  DateTime get createdAt;
  DateTime get updatedAt;
  DateTime? get deletedAt;
  DateTime get enrolledAt;
  DateTime? get completedAt;
  int get progress;
  T get course;
  User get user;
}
