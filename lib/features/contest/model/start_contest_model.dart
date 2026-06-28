import 'package:json_annotation/json_annotation.dart';

part 'start_contest_model.g.dart';

@JsonSerializable()
class StartContestModel {
  StartContestModel({
    required this.success,
    required this.timestamp,
    required this.data,
  });

  final bool success;
  final String timestamp;
  final StartContestData data;

  factory StartContestModel.fromJson(Map<String, dynamic> json) =>
      _$StartContestModelFromJson(json);

  Map<String, dynamic> toJson() => _$StartContestModelToJson(this);
}

@JsonSerializable()
class StartContestData {
  StartContestData({
    required this.contestId,
    required this.title,
    required this.questions,
  });

  final String contestId;
  final String title;
  final List<Question> questions;

  factory StartContestData.fromJson(Map<String, dynamic> json) =>
      _$StartContestDataFromJson(json);

  Map<String, dynamic> toJson() => _$StartContestDataToJson(this);
}

@JsonSerializable()
class Question {
  Question({
    required this.id,
    required this.questionText,
    required this.options,
    required this.questionType,
  });

  final String id;
  @JsonKey(name: 'question')
  final String questionText;
  final List<QuestionOption>? options;
  @JsonKey(name: 'type')
  final String questionType;

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}

@JsonSerializable()
class QuestionOption {
  QuestionOption({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.option,
    required this.correct,
  });

  final String id;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String option;
  final bool correct;

  factory QuestionOption.fromJson(Map<String, dynamic> json) =>
      _$QuestionOptionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionOptionToJson(this);
}
