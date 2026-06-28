// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advanced_learnway_courses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdvancedLearnwayCourses _$AdvancedLearnwayCoursesFromJson(
  Map<String, dynamic> json,
) => AdvancedLearnwayCourses(
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
);

Map<String, dynamic> _$AdvancedLearnwayCoursesToJson(
  AdvancedLearnwayCourses instance,
) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'deletedAt': instance.deletedAt?.toIso8601String(),
  'title': instance.title,
  'description': instance.description,
  'skillLevel': instance.skillLevel,
  'isActive': instance.isActive,
  'isPremium': instance.isPremium,
};
