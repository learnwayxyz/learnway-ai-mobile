import 'package:json_annotation/json_annotation.dart';

part 'registered_courses.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class RegisteredCourses<T> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime enrolledAt;
  final DateTime? completedAt;
  final int progress;
  final T course;

  RegisteredCourses({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.enrolledAt,
    this.completedAt,
    required this.progress,
    required this.course,
  });

  factory RegisteredCourses.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$RegisteredCoursesFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$RegisteredCoursesToJson(this, toJsonT);
}

@JsonSerializable()
class RegisteredCourseModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String title;
  final String description;
  final String skillLevel;
  final bool isActive;
  final bool isPremium;

  RegisteredCourseModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.title,
    required this.description,
    required this.skillLevel,
    required this.isActive,
    required this.isPremium,
  });

  factory RegisteredCourseModel.fromJson(Map<String, dynamic> json) =>
      _$RegisteredCourseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisteredCourseModelToJson(this);
}
