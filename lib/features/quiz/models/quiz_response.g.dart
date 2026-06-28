// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizResponse _$QuizResponseFromJson(Map<String, dynamic> json) => QuizResponse(
  success: json['success'] as bool,
  timestamp: json['timestamp'] as String,
  data: QuizData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$QuizResponseToJson(QuizResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'timestamp': instance.timestamp,
      'data': instance.data.toJson(),
    };

QuizData _$QuizDataFromJson(Map<String, dynamic> json) => QuizData(
  content: (json['content'] as List<dynamic>)
      .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
      .toList(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
);

Map<String, dynamic> _$QuizDataToJson(QuizData instance) => <String, dynamic>{
  'content': instance.content.map((e) => e.toJson()).toList(),
  'page': instance.page,
  'limit': instance.limit,
  'totalPages': instance.totalPages,
};

QuizQuestion _$QuizQuestionFromJson(Map<String, dynamic> json) => QuizQuestion(
  id: json['id'] as String,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
  deletedAt: json['deletedAt'] as String?,
  question: json['question'] as String,
  type: $enumDecode(
    _$QuestionTypeEnumMap,
    json['type'],
    unknownValue: QuestionType.SINGLE_CHOICE,
  ),
  purpose: $enumDecode(
    _$QuestionPurposeEnumMap,
    json['purpose'],
    unknownValue: QuestionPurpose.ACTUAL_QUIZ,
  ),
  note: json['note'] as String?,
  level: (json['level'] as num).toInt(),
  options: (json['options'] as List<dynamic>)
      .map((e) => QuizOption.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QuizQuestionToJson(QuizQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'question': instance.question,
      'type': _$QuestionTypeEnumMap[instance.type]!,
      'purpose': _$QuestionPurposeEnumMap[instance.purpose]!,
      'note': instance.note,
      'level': instance.level,
      'options': instance.options.map((e) => e.toJson()).toList(),
    };

const _$QuestionTypeEnumMap = {
  QuestionType.SINGLE_CHOICE: 'SINGLE_CHOICE',
  QuestionType.BINARY: 'BINARY',
};

const _$QuestionPurposeEnumMap = {QuestionPurpose.ACTUAL_QUIZ: 'ACTUAL_QUIZ'};

QuizOption _$QuizOptionFromJson(Map<String, dynamic> json) => QuizOption(
  id: json['id'] as String,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
  deletedAt: json['deletedAt'] as String?,
  option: json['option'] as String,
  correct: json['correct'] as bool,
  timeToAnswer: (json['timeToAnswer'] as num?)?.toInt(),
);

Map<String, dynamic> _$QuizOptionToJson(QuizOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'option': instance.option,
      'correct': instance.correct,
      'timeToAnswer': instance.timeToAnswer,
    };
