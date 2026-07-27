// lib/features/learn_and_earn/learn_and_earn_data_source/models/course_detail.dart

import 'package:json_annotation/json_annotation.dart';

part 'courses_info_details.g.dart';

@JsonSerializable()
class CoursesInfoDetails {
  const CoursesInfoDetails({
    required this.id,
    required this.title,
    required this.description,
    this.longDescription,
    required this.difficultyLevel,
    this.estimatedCompletionMinutes,
    this.skillsGained = const [],
    this.prerequisites = const [],
    this.targetAudience,
    this.careerOpportunities = const [],
    this.recommendedNextCourse,
  });

  factory CoursesInfoDetails.fromJson(Map<String, dynamic> json) =>
      _$CoursesInfoDetailsFromJson(json);

  final String id;
  final String title;
  final String description;
  final String? longDescription;

  final int difficultyLevel;

  final int? estimatedCompletionMinutes;
  final List<String> skillsGained;
  final List<String> prerequisites;
  final String? targetAudience;
  final List<String> careerOpportunities;
  final RecommendedCourse? recommendedNextCourse;

  Map<String, dynamic> toJson() => _$CoursesInfoDetailsToJson(this);

  /// Text for the "About course" card — the richer longDescription when the
  /// API provides one, otherwise the short description.
  String get aboutText {
    final long = longDescription?.trim() ?? '';
    return long.isNotEmpty ? long : description;
  }

  bool get hasInformation =>
      aboutText.trim().isNotEmpty ||
      skillsGained.isNotEmpty ||
      prerequisites.isNotEmpty ||
      (targetAudience?.trim().isNotEmpty ?? false) ||
      careerOpportunities.isNotEmpty;

  String get difficultyLabel {
    return switch (difficultyLevel) {
      1 => 'Beginner',
      2 => 'Intermediate',
      3 => 'Advanced',
      _ => 'Unknown',
    };
  }

  String? get estimatedTimeLabel {
    final minutes = estimatedCompletionMinutes;
    if (minutes == null) return null;
    if (minutes < 60) return '${minutes}m';
    final hours = minutes / 60;
    return hours == hours.toInt()
        ? '${hours.toInt()}hrs'
        : '${hours.toStringAsFixed(1)}hrs';
  }
}

@JsonSerializable()
class RecommendedCourse {
  const RecommendedCourse({
    required this.id,
    required this.title,
    this.coverImageUrl,
  });

  factory RecommendedCourse.fromJson(Map<String, dynamic> json) =>
      _$RecommendedCourseFromJson(json);

  final String id;
  final String title;
  final String? coverImageUrl;

  Map<String, dynamic> toJson() => _$RecommendedCourseToJson(this);
}
