// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enrolled_learnway_courses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnrolledLearnwayCourses _$EnrolledLearnwayCoursesFromJson(
  Map<String, dynamic> json,
) => EnrolledLearnwayCourses(
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
  course: Course.fromJson(json['course'] as Map<String, dynamic>),
  user: User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EnrolledLearnwayCoursesToJson(
  EnrolledLearnwayCourses instance,
) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'deletedAt': instance.deletedAt?.toIso8601String(),
  'enrolledAt': instance.enrolledAt.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'progress': instance.progress,
  'course': instance.course.toJson(),
  'user': instance.user.toJson(),
};

Course _$CourseFromJson(Map<String, dynamic> json) => Course(
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
  order: (json['order'] as num).toInt(),
  enrolledUsersCount: (json['enrolledUsersCount'] as num).toInt(),
  latestEnrolledUsers: (json['latestEnrolledUsers'] as List<dynamic>)
      .map((e) => User.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'deletedAt': instance.deletedAt?.toIso8601String(),
  'title': instance.title,
  'description': instance.description,
  'skillLevel': instance.skillLevel,
  'isActive': instance.isActive,
  'isPremium': instance.isPremium,
  'order': instance.order,
  'enrolledUsersCount': instance.enrolledUsersCount,
  'latestEnrolledUsers': instance.latestEnrolledUsers
      .map((e) => e.toJson())
      .toList(),
};

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  username: json['username'] as String,
  email: json['email'] as String?,
  profileImageUrl: json['profileImageUrl'] as String?,
  profileImageFileId: json['profileImageFileId'] as String?,
  profileThumbnailUrl: json['profileThumbnailUrl'] as String?,
  enrolledAt: json['enrolledAt'] == null
      ? null
      : DateTime.parse(json['enrolledAt'] as String),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'profileImageUrl': instance.profileImageUrl,
  'profileImageFileId': instance.profileImageFileId,
  'profileThumbnailUrl': instance.profileThumbnailUrl,
  'enrolledAt': instance.enrolledAt?.toIso8601String(),
};
