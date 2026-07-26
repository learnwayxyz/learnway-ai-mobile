import 'package:json_annotation/json_annotation.dart';

part 'career_roadmap_model.g.dart';

@JsonSerializable()
class RoadmapStage {
  RoadmapStage({
    required this.stage,
    required this.title,
    required this.description,
    required this.skills,
    required this.estimatedWeeks,
    required this.completed,
  });

  final int stage;
  final String title;
  final String description;
  final List<String> skills;
  final int estimatedWeeks;
  final bool completed;

  factory RoadmapStage.fromJson(Map<String, dynamic> json) =>
      _$RoadmapStageFromJson(json);

  Map<String, dynamic> toJson() => _$RoadmapStageToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CareerRoadmap {
  CareerRoadmap({
    required this.id,
    required this.careerGoal,
    required this.title,
    required this.description,
    required this.stages,
    required this.requiredSkills,
    required this.milestones,
    required this.totalEstimatedWeeks,
    required this.completionPercentage,
    required this.createdAt,
  });

  final String id;
  final String careerGoal;
  final String title;
  final String description;
  final List<RoadmapStage> stages;
  final List<String> requiredSkills;
  final List<String> milestones;
  final int totalEstimatedWeeks;
  final int completionPercentage;
  final String createdAt;

  factory CareerRoadmap.fromJson(Map<String, dynamic> json) =>
      _$CareerRoadmapFromJson(json);

  Map<String, dynamic> toJson() => _$CareerRoadmapToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CareerRoadmapResponse {
  CareerRoadmapResponse({
    required this.success,
    required this.timestamp,
    required this.data,
  });

  final bool success;
  final String timestamp;
  final CareerRoadmap data;

  factory CareerRoadmapResponse.fromJson(Map<String, dynamic> json) =>
      _$CareerRoadmapResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CareerRoadmapResponseToJson(this);
}
