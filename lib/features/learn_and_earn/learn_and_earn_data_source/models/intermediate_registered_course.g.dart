// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intermediate_registered_course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntermediateRegisteredCourseModel _$IntermediateRegisteredCourseModelFromJson(
  Map<String, dynamic> json,
) => IntermediateRegisteredCourseModel(
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
  enrolledUsersCount: (json['enrolledUsersCount'] as num).toInt(),
  latestEnrolledUsers: (json['latestEnrolledUsers'] as List<dynamic>)
      .map((e) => User.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$IntermediateRegisteredCourseModelToJson(
  IntermediateRegisteredCourseModel instance,
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
  'enrolledUsersCount': instance.enrolledUsersCount,
  'latestEnrolledUsers': instance.latestEnrolledUsers,
};

IntermediateRegisteredCourse _$IntermediateRegisteredCourseFromJson(
  Map<String, dynamic> json,
) => IntermediateRegisteredCourse(
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
  course: IntermediateRegisteredCourseModel.fromJson(
    json['course'] as Map<String, dynamic>,
  ),
  user: User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$IntermediateRegisteredCourseToJson(
  IntermediateRegisteredCourse instance,
) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'deletedAt': instance.deletedAt?.toIso8601String(),
  'enrolledAt': instance.enrolledAt.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'progress': instance.progress,
  'course': instance.course,
  'user': instance.user,
};
