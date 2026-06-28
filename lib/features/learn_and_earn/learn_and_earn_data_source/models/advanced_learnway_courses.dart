import 'package:json_annotation/json_annotation.dart';

part 'advanced_learnway_courses.g.dart';

@JsonSerializable()
class AdvancedLearnwayCourses {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String title;
  final String description;
  final String skillLevel;
  final bool isActive;
  final bool isPremium;

  AdvancedLearnwayCourses({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.title,
    required this.description,
    required this.skillLevel,
    required this.isActive,
    required this.isPremium,
  });

  factory AdvancedLearnwayCourses.fromJson(Map<String, dynamic> json) =>
      _$AdvancedLearnwayCoursesFromJson(json);

  Map<String, dynamic> toJson() => _$AdvancedLearnwayCoursesToJson(this);
}
