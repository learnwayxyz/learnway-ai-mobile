import 'package:json_annotation/json_annotation.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/base_models/base_course_models.dart';

import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/enrolled_learnway_courses.dart';

part 'intermediate_registered_course.g.dart';

@JsonSerializable()
class IntermediateRegisteredCourseModel extends BaseCourseModel {
  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? deletedAt;
  @override
  final String title;
  @override
  final String description;
  @override
  final String skillLevel;
  @override
  final bool isActive;
  @override
  final bool isPremium;
  @override
  final int enrolledUsersCount;
  @override
  final List<User> latestEnrolledUsers;

  IntermediateRegisteredCourseModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.title,
    required this.description,
    required this.skillLevel,
    required this.isActive,
    required this.isPremium,
    required this.enrolledUsersCount,
    required this.latestEnrolledUsers,
  });

  factory IntermediateRegisteredCourseModel.fromJson(
    Map<String, dynamic> json,
  ) => _$IntermediateRegisteredCourseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$IntermediateRegisteredCourseModelToJson(this);
}

@JsonSerializable()
class IntermediateRegisteredCourse
    extends BaseRegisteredCourses<IntermediateRegisteredCourseModel> {
  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? deletedAt;
  @override
  final DateTime enrolledAt;
  @override
  final DateTime? completedAt;
  @override
  final int progress;
  @override
  final IntermediateRegisteredCourseModel course;
  @override
  final User user;

  IntermediateRegisteredCourse({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.enrolledAt,
    this.completedAt,
    required this.progress,
    required this.course,
    required this.user,
  });

  factory IntermediateRegisteredCourse.fromJson(Map<String, dynamic> json) =>
      _$IntermediateRegisteredCourseFromJson(json);

  Map<String, dynamic> toJson() => _$IntermediateRegisteredCourseToJson(this);
}
