// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registered_courses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisteredCourses<T> _$RegisteredCoursesFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => RegisteredCourses<T>(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
  enrolledAt: DateTime.parse(json['enrolledAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  progress: (json['progress'] as num).toInt(),
  course: fromJsonT(json['course']),
);

Map<String, dynamic> _$RegisteredCoursesToJson<T>(
  RegisteredCourses<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'deletedAt': instance.deletedAt?.toIso8601String(),
  'enrolledAt': instance.enrolledAt.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'progress': instance.progress,
  'course': toJsonT(instance.course),
};

RegisteredCourseModel _$RegisteredCourseModelFromJson(
  Map<String, dynamic> json,
) => RegisteredCourseModel(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
  title: json['title'] as String,
  description: json['description'] as String,
  skillLevel: json['skillLevel'] as String,
  isActive: json['isActive'] as bool,
  isPremium: json['isPremium'] as bool,
);

Map<String, dynamic> _$RegisteredCourseModelToJson(
  RegisteredCourseModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'deletedAt': instance.deletedAt?.toIso8601String(),
  'title': instance.title,
  'description': instance.description,
  'skillLevel': instance.skillLevel,
  'isActive': instance.isActive,
  'isPremium': instance.isPremium,
};
