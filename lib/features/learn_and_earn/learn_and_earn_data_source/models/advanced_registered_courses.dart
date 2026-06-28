import 'package:json_annotation/json_annotation.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/base_models/base_course_models.dart';

import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/enrolled_learnway_courses.dart';

part 'advanced_registered_courses.g.dart';

@JsonSerializable()
class AdvancedRegisteredCourses
    extends BaseRegisteredCourses<AdvancedRegisteredCourseModel> {
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
  final AdvancedRegisteredCourseModel course;
  @override
  final User user;

  AdvancedRegisteredCourses({
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

  factory AdvancedRegisteredCourses.fromJson(Map<String, dynamic> json) =>
      _$AdvancedRegisteredCoursesFromJson(json);

  Map<String, dynamic> toJson() => _$AdvancedRegisteredCoursesToJson(this);
}

@JsonSerializable()
class AdvancedRegisteredCourseModel extends BaseCourseModel {
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

  AdvancedRegisteredCourseModel({
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

  factory AdvancedRegisteredCourseModel.fromJson(Map<String, dynamic> json) =>
      _$AdvancedRegisteredCourseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AdvancedRegisteredCourseModelToJson(this);
}
