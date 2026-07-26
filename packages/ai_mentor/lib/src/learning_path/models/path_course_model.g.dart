// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'path_course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PathCourseUser _$PathCourseUserFromJson(Map<String, dynamic> json) =>
    PathCourseUser(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      enrolledAt: DateTime.parse(json['enrolledAt'] as String),
      profileImageUrl: json['profileImageUrl'] as String?,
      profileImageFileId: json['profileImageFileId'] as String?,
      profileThumbnailUrl: json['profileThumbnailUrl'] as String?,
    );

Map<String, dynamic> _$PathCourseUserToJson(PathCourseUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'profileImageUrl': instance.profileImageUrl,
      'profileImageFileId': instance.profileImageFileId,
      'profileThumbnailUrl': instance.profileThumbnailUrl,
      'enrolledAt': instance.enrolledAt.toIso8601String(),
    };

PathCourseModel _$PathCourseModelFromJson(Map<String, dynamic> json) =>
    PathCourseModel(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      title: json['title'] as String,
      description: json['description'] as String,
      skillLevel: json['skillLevel'] as String,
      isActive: json['isActive'] as bool,
      isPremium: json['isPremium'] as bool,
      order: (json['order'] as num).toInt(),
      enrolledUsersCount: (json['enrolledUsersCount'] as num).toInt(),
      latestEnrolledUsers: (json['latestEnrolledUsers'] as List<dynamic>)
          .map((e) => PathCourseUser.fromJson(e as Map<String, dynamic>))
          .toList(),
      isEnrolled: json['isEnrolled'] as bool,
      isCompleted: json['isCompleted'] as bool,
      progress: (json['progress'] as num).toInt(),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      enrolledAt: json['enrolledAt'] == null
          ? null
          : DateTime.parse(json['enrolledAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$PathCourseModelToJson(PathCourseModel instance) =>
    <String, dynamic>{
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
      'isEnrolled': instance.isEnrolled,
      'enrolledAt': instance.enrolledAt?.toIso8601String(),
      'isCompleted': instance.isCompleted,
      'completedAt': instance.completedAt?.toIso8601String(),
      'progress': instance.progress,
    };
