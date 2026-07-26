// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendations_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Insight _$InsightFromJson(Map<String, dynamic> json) => Insight(
  type: $enumDecode(
    _$InsightTypeEnumMap,
    json['type'],
    unknownValue: InsightType.other,
  ),
  title: json['title'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$InsightToJson(Insight instance) => <String, dynamic>{
  'type': _$InsightTypeEnumMap[instance.type]!,
  'title': instance.title,
  'description': instance.description,
};

const _$InsightTypeEnumMap = {
  InsightType.recommendation: 'recommendation',
  InsightType.weakness: 'weakness',
  InsightType.motivation: 'motivation',
  InsightType.strength: 'strength',
  InsightType.other: 'other',
};

LearningInsightsData _$LearningInsightsDataFromJson(
  Map<String, dynamic> json,
) => LearningInsightsData(
  insights: (json['insights'] as List<dynamic>)
      .map((e) => Insight.fromJson(e as Map<String, dynamic>))
      .toList(),
  nextActions: (json['nextActions'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  weeklyGoal: json['weeklyGoal'] as String,
  motivationMessage: json['motivationMessage'] as String,
  skillFocus: (json['skillFocus'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$LearningInsightsDataToJson(
  LearningInsightsData instance,
) => <String, dynamic>{
  'insights': instance.insights,
  'nextActions': instance.nextActions,
  'weeklyGoal': instance.weeklyGoal,
  'motivationMessage': instance.motivationMessage,
  'skillFocus': instance.skillFocus,
};

RecommendationsModel _$RecommendationsModelFromJson(
  Map<String, dynamic> json,
) => RecommendationsModel(
  success: json['success'] as bool,
  timestamp: DateTime.parse(json['timestamp'] as String),
  data: LearningInsightsData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RecommendationsModelToJson(
  RecommendationsModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'timestamp': instance.timestamp.toIso8601String(),
  'data': instance.data,
};
