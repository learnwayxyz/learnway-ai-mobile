import 'package:json_annotation/json_annotation.dart';

part 'recommendations_model.g.dart';

enum InsightType {
  @JsonValue('recommendation')
  recommendation,
  @JsonValue('weakness')
  weakness,
  @JsonValue('motivation')
  motivation,
  @JsonValue('strength')
  strength,
  other,
}

@JsonSerializable()
class Insight {
  @JsonKey(unknownEnumValue: InsightType.other)
  final InsightType type;
  final String title;
  final String description;

  const Insight({
    required this.type,
    required this.title,
    required this.description,
  });

  factory Insight.fromJson(Map<String, dynamic> json) =>
      _$InsightFromJson(json);

  Map<String, dynamic> toJson() => _$InsightToJson(this);
}

@JsonSerializable()
class LearningInsightsData {
  final List<Insight> insights;
  final List<String> nextActions;
  final String weeklyGoal;
  final String motivationMessage;
  final List<String> skillFocus;

  const LearningInsightsData({
    required this.insights,
    required this.nextActions,
    required this.weeklyGoal,
    required this.motivationMessage,
    required this.skillFocus,
  });

  factory LearningInsightsData.fromJson(Map<String, dynamic> json) =>
      _$LearningInsightsDataFromJson(json);

  Map<String, dynamic> toJson() => _$LearningInsightsDataToJson(this);
}

@JsonSerializable()
class RecommendationsModel {
  final bool success;
  final DateTime timestamp;
  final LearningInsightsData data;

  const RecommendationsModel({
    required this.success,
    required this.timestamp,
    required this.data,
  });

  factory RecommendationsModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendationsModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendationsModelToJson(this);
}
