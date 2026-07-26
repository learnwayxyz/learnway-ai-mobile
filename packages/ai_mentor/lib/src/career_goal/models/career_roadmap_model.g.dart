// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'career_roadmap_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoadmapStage _$RoadmapStageFromJson(Map<String, dynamic> json) => RoadmapStage(
  stage: (json['stage'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
  skills: (json['skills'] as List<dynamic>).map((e) => e as String).toList(),
  estimatedWeeks: (json['estimatedWeeks'] as num).toInt(),
  completed: json['completed'] as bool,
);

Map<String, dynamic> _$RoadmapStageToJson(RoadmapStage instance) =>
    <String, dynamic>{
      'stage': instance.stage,
      'title': instance.title,
      'description': instance.description,
      'skills': instance.skills,
      'estimatedWeeks': instance.estimatedWeeks,
      'completed': instance.completed,
    };

CareerRoadmap _$CareerRoadmapFromJson(Map<String, dynamic> json) =>
    CareerRoadmap(
      id: json['id'] as String,
      careerGoal: json['careerGoal'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      stages: (json['stages'] as List<dynamic>)
          .map((e) => RoadmapStage.fromJson(e as Map<String, dynamic>))
          .toList(),
      requiredSkills: (json['requiredSkills'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      milestones: (json['milestones'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      totalEstimatedWeeks: (json['totalEstimatedWeeks'] as num).toInt(),
      completionPercentage: (json['completionPercentage'] as num).toInt(),
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$CareerRoadmapToJson(CareerRoadmap instance) =>
    <String, dynamic>{
      'id': instance.id,
      'careerGoal': instance.careerGoal,
      'title': instance.title,
      'description': instance.description,
      'stages': instance.stages.map((e) => e.toJson()).toList(),
      'requiredSkills': instance.requiredSkills,
      'milestones': instance.milestones,
      'totalEstimatedWeeks': instance.totalEstimatedWeeks,
      'completionPercentage': instance.completionPercentage,
      'createdAt': instance.createdAt,
    };

CareerRoadmapResponse _$CareerRoadmapResponseFromJson(
  Map<String, dynamic> json,
) => CareerRoadmapResponse(
  success: json['success'] as bool,
  timestamp: json['timestamp'] as String,
  data: CareerRoadmap.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CareerRoadmapResponseToJson(
  CareerRoadmapResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'timestamp': instance.timestamp,
  'data': instance.data.toJson(),
};
