// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_contest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StartContestModel _$StartContestModelFromJson(Map<String, dynamic> json) =>
    StartContestModel(
      success: json['success'] as bool,
      timestamp: json['timestamp'] as String,
      data: StartContestData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StartContestModelToJson(StartContestModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'timestamp': instance.timestamp,
      'data': instance.data,
    };

StartContestData _$StartContestDataFromJson(Map<String, dynamic> json) =>
    StartContestData(
      contestId: json['contestId'] as String,
      title: json['title'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StartContestDataToJson(StartContestData instance) =>
    <String, dynamic>{
      'contestId': instance.contestId,
      'title': instance.title,
      'questions': instance.questions,
    };

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
  id: json['id'] as String,
  questionText: json['question'] as String,
  options: (json['options'] as List<dynamic>?)
      ?.map((e) => QuestionOption.fromJson(e as Map<String, dynamic>))
      .toList(),
  questionType: json['type'] as String,
);

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
  'id': instance.id,
  'question': instance.questionText,
  'options': instance.options,
  'type': instance.questionType,
};

QuestionOption _$QuestionOptionFromJson(Map<String, dynamic> json) =>
    QuestionOption(
      id: json['id'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      deletedAt: json['deletedAt'] as String?,
      option: json['option'] as String,
      correct: json['correct'] as bool,
    );

Map<String, dynamic> _$QuestionOptionToJson(QuestionOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'option': instance.option,
      'correct': instance.correct,
    };
