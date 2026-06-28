import 'package:json_annotation/json_annotation.dart';

part 'enrolled_learnway_courses.g.dart';

@JsonSerializable(explicitToJson: true)
class EnrolledLearnwayCourses {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime enrolledAt;
  final DateTime? completedAt;
  final int progress;
  final Course course;
  final User user;

  EnrolledLearnwayCourses({
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

  factory EnrolledLearnwayCourses.fromJson(Map<String, dynamic> json) =>
      _$EnrolledLearnwayCoursesFromJson(json);

  Map<String, dynamic> toJson() => _$EnrolledLearnwayCoursesToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Course {
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
  final List<User> latestEnrolledUsers;

  Course({
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
  });

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  Map<String, dynamic> toJson() => _$CourseToJson(this);
}

@JsonSerializable()
class User {
  final String id;
  final String username;
  final String? email;
  final String? profileImageUrl;
  final String? profileImageFileId;
  final String? profileThumbnailUrl;
  final DateTime? enrolledAt;

  User({
    required this.id,
    required this.username,
    this.email,
    this.profileImageUrl,
    this.profileImageFileId,
    this.profileThumbnailUrl,
    this.enrolledAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
