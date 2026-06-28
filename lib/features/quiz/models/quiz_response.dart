import 'package:json_annotation/json_annotation.dart';

part 'quiz_response.g.dart';

@JsonSerializable(explicitToJson: true)
class QuizResponse {
  final bool success;
  final String timestamp;
  final QuizData data;

  QuizResponse({
    required this.success,
    required this.timestamp,
    required this.data,
  });

  factory QuizResponse.fromJson(Map<String, dynamic> json) =>
      _$QuizResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QuizResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QuizData {
  final List<QuizQuestion> content;
  final int page;
  final int limit;
  final int totalPages;

  QuizData({
    required this.content,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory QuizData.fromJson(Map<String, dynamic> json) =>
      _$QuizDataFromJson(json);

  Map<String, dynamic> toJson() => _$QuizDataToJson(this);
}

enum QuestionType { SINGLE_CHOICE, BINARY }

enum QuestionPurpose { ACTUAL_QUIZ }

@JsonSerializable(explicitToJson: true)
class QuizQuestion {
  final String id;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String question;

  @JsonKey(unknownEnumValue: QuestionType.SINGLE_CHOICE)
  final QuestionType type;

  @JsonKey(unknownEnumValue: QuestionPurpose.ACTUAL_QUIZ)
  final QuestionPurpose purpose;

  final String? note;
  final int level;
  final List<QuizOption> options;

  QuizQuestion({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.question,
    required this.type,
    required this.purpose,
    this.note,
    required this.level,
    required this.options,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuizQuestionToJson(this);
}

@JsonSerializable()
class QuizOption {
  final String id;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String option;
  final bool correct;
  final int? timeToAnswer;

  QuizOption({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.option,
    required this.correct,
    this.timeToAnswer,
  });

  factory QuizOption.fromJson(Map<String, dynamic> json) =>
      _$QuizOptionFromJson(json);

  Map<String, dynamic> toJson() => _$QuizOptionToJson(this);
}
