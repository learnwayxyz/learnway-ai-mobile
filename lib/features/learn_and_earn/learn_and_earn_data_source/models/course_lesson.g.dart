// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseLesson _$CourseLessonFromJson(Map<String, dynamic> json) => CourseLesson(
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
  lessons: (json['lessons'] as List<dynamic>)
      .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
      .toList(),
  isEnrolled: json['isEnrolled'] as bool,
  enrolledAt: json['enrolledAt'] == null
      ? null
      : DateTime.parse(json['enrolledAt'] as String),
  isCompleted: json['isCompleted'] as bool,
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  progress: (json['progress'] as num).toInt(),
  userInfo: json['userInfo'] == null
      ? null
      : UserInfo.fromJson(json['userInfo'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CourseLessonToJson(CourseLesson instance) =>
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
      'lessons': instance.lessons.map((e) => e.toJson()).toList(),
      'isEnrolled': instance.isEnrolled,
      'enrolledAt': instance.enrolledAt?.toIso8601String(),
      'isCompleted': instance.isCompleted,
      'completedAt': instance.completedAt?.toIso8601String(),
      'progress': instance.progress,
      'userInfo': instance.userInfo?.toJson(),
    };

Lesson _$LessonFromJson(Map<String, dynamic> json) => Lesson(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
  title: json['title'] as String,
  order: (json['order'] as num).toInt(),
  imageUrl: json['imageUrl'] as String?,
  mediaUrl: json['mediaUrl'] as String?,
  mediaType: json['mediaType'] as String?,
  mediaFileId: json['mediaFileId'] as String?,
  course: json['course'] == null
      ? null
      : CourseRef.fromJson(json['course'] as Map<String, dynamic>),
  isStarted: json['isStarted'] as bool,
  startedAt: json['startedAt'] == null
      ? null
      : DateTime.parse(json['startedAt'] as String),
  isCompleted: json['isCompleted'] as bool,
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  progress: (json['progress'] as num).toInt(),
);

Map<String, dynamic> _$LessonToJson(Lesson instance) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'deletedAt': instance.deletedAt?.toIso8601String(),
  'title': instance.title,
  'order': instance.order,
  'imageUrl': instance.imageUrl,
  'mediaUrl': instance.mediaUrl,
  'mediaType': instance.mediaType,
  'mediaFileId': instance.mediaFileId,
  'course': instance.course,
  'isStarted': instance.isStarted,
  'startedAt': instance.startedAt?.toIso8601String(),
  'isCompleted': instance.isCompleted,
  'completedAt': instance.completedAt?.toIso8601String(),
  'progress': instance.progress,
};

CourseRef _$CourseRefFromJson(Map<String, dynamic> json) =>
    CourseRef(id: json['id'] as String);

Map<String, dynamic> _$CourseRefToJson(CourseRef instance) => <String, dynamic>{
  'id': instance.id,
};

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
  id: json['id'] as String,
  username: json['username'] as String,
  email: json['email'] as String,
);

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
};
