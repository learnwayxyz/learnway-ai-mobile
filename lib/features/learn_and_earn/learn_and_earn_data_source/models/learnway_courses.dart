import 'package:json_annotation/json_annotation.dart';

part 'learnway_courses.g.dart';

@JsonSerializable()
class LearnWayUser {
  final String id;
  final String username;
  final String email;
  final String? profileImageUrl;
  final String? profileImageFileId;
  final String? profileThumbnailUrl;
  final DateTime enrolledAt;

  LearnWayUser({
    required this.id,
    required this.username,
    required this.email,
    this.profileImageUrl,
    this.profileImageFileId,
    this.profileThumbnailUrl,
    required this.enrolledAt,
  });

  factory LearnWayUser.fromJson(Map<String, dynamic> json) =>
      _$LearnWayUserFromJson(json);

  Map<String, dynamic> toJson() => _$LearnWayUserToJson(this);
}

@JsonSerializable()
class LearnWayCourses {
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
  final List<LearnWayUser> latestEnrolledUsers;
  final bool isEnrolled;
  final DateTime? enrolledAt;
  final bool isCompleted;
  final DateTime? completedAt;
  final int progress;

  LearnWayCourses({
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
    required this.enrolledUsersCount,
    required this.latestEnrolledUsers,
    required this.isEnrolled,
    this.enrolledAt,
    required this.isCompleted,
    this.completedAt,
    required this.progress,
  });

  factory LearnWayCourses.fromJson(Map<String, dynamic> json) =>
      _$LearnWayCoursesFromJson(json);

  Map<String, dynamic> toJson() => _$LearnWayCoursesToJson(this);
}
