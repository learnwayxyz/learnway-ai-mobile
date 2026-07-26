import 'package:json_annotation/json_annotation.dart';

part 'path_course_model.g.dart';

@JsonSerializable()
class PathCourseUser {
  PathCourseUser({
    required this.id,
    required this.username,
    required this.email,
    required this.enrolledAt,
    this.profileImageUrl,
    this.profileImageFileId,
    this.profileThumbnailUrl,
  });

  factory PathCourseUser.fromJson(Map<String, dynamic> json) =>
      _$PathCourseUserFromJson(json);

  final String id;
  final String username;
  final String email;
  final String? profileImageUrl;
  final String? profileImageFileId;
  final String? profileThumbnailUrl;
  final DateTime enrolledAt;

  Map<String, dynamic> toJson() => _$PathCourseUserToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PathCourseModel {
  PathCourseModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.description,
    required this.skillLevel,
    required this.isActive,
    required this.isPremium,
    required this.order,
    required this.enrolledUsersCount,
    required this.latestEnrolledUsers,
    required this.isEnrolled,
    required this.isCompleted,
    required this.progress,
    this.deletedAt,
    this.enrolledAt,
    this.completedAt,
  });

  factory PathCourseModel.fromJson(Map<String, dynamic> json) =>
      _$PathCourseModelFromJson(json);

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
  final int enrolledUsersCount;
  final List<PathCourseUser> latestEnrolledUsers;
  final bool isEnrolled;
  final DateTime? enrolledAt;
  final bool isCompleted;
  final DateTime? completedAt;
  final int progress;

  Map<String, dynamic> toJson() => _$PathCourseModelToJson(this);
}
