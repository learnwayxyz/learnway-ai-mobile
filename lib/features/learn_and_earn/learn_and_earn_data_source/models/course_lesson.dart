import 'package:json_annotation/json_annotation.dart';

part 'course_lesson.g.dart';

@JsonSerializable(explicitToJson: true)
class CourseLesson {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String title;
  final String description;
  final String skillLevel;
  final bool isActive;
  final bool isPremium;
  final int order;
  final List<Lesson> lessons;

  // extra fields from JSON
  final bool isEnrolled;
  final DateTime? enrolledAt;
  final bool isCompleted;
  final DateTime? completedAt;
  final int progress;
  final UserInfo? userInfo;

  CourseLesson({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.title,
    required this.description,
    required this.skillLevel,
    required this.isActive,
    required this.isPremium,
    required this.order,
    required this.lessons,
    required this.isEnrolled,
    this.enrolledAt,
    required this.isCompleted,
    this.completedAt,
    required this.progress,
    this.userInfo,
  });

  factory CourseLesson.fromJson(Map<String, dynamic> json) =>
      _$CourseLessonFromJson(json);

  Map<String, dynamic> toJson() => _$CourseLessonToJson(this);
}

@JsonSerializable()
class Lesson {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String title;
  final int order;

  // extra fields from JSON
  final String? imageUrl;
  final String? mediaUrl;
  final String? mediaType;
  final String? mediaFileId;
  final CourseRef? course;
  final bool isStarted;
  final DateTime? startedAt;
  final bool isCompleted;
  final DateTime? completedAt;
  final int progress;

  Lesson({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.title,
    required this.order,
    this.imageUrl,
    this.mediaUrl,
    this.mediaType,
    this.mediaFileId,
    this.course,
    required this.isStarted,
    this.startedAt,
    required this.isCompleted,
    this.completedAt,
    required this.progress,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);

  Map<String, dynamic> toJson() => _$LessonToJson(this);
}

@JsonSerializable()
class CourseRef {
  final String id;

  CourseRef({required this.id});

  factory CourseRef.fromJson(Map<String, dynamic> json) =>
      _$CourseRefFromJson(json);

  Map<String, dynamic> toJson() => _$CourseRefToJson(this);
}

@JsonSerializable()
class UserInfo {
  final String id;
  final String username;
  final String email;

  UserInfo({required this.id, required this.username, required this.email});

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}
