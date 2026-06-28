import 'package:json_annotation/json_annotation.dart';

part 'ai_tutor_response.g.dart';

enum AiTutorPromptType {
  explainSimply,
  summarize,
  example,
  keyTakeaways,
  custom;

  String get apiValue => switch (this) {
    AiTutorPromptType.explainSimply => 'explain_simply',
    AiTutorPromptType.summarize => 'summarize',
    AiTutorPromptType.example => 'example',
    AiTutorPromptType.keyTakeaways => 'key_takeaways',
    AiTutorPromptType.custom => 'custom',
  };
}

@JsonSerializable()
class AiTutorRateLimit {
  AiTutorRateLimit({required this.lesson, required this.daily});

  final int lesson;
  final int daily;

  static const int maxLessonAsks = 5;
  static const int maxDailyAsks = 20;

  bool get isLessonLimitExhausted => lesson <= 0;
  bool get isDailyLimitExhausted => daily <= 0;
  bool get canAskMoreQuestions =>
      !isLessonLimitExhausted && !isDailyLimitExhausted;

  double get lessonUsageRatio =>
      (maxLessonAsks - lesson).clamp(0, maxLessonAsks) / maxLessonAsks;

  double get dailyUsageRatio =>
      (maxDailyAsks - daily).clamp(0, maxDailyAsks) / maxDailyAsks;

  factory AiTutorRateLimit.fromJson(Map<String, dynamic> json) =>
      _$AiTutorRateLimitFromJson(json);

  Map<String, dynamic> toJson() => _$AiTutorRateLimitToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AiTutorResponseData {
  AiTutorResponseData({
    required this.requestId,
    required this.response,
    required this.fromCache,
    required this.rateLimitRemaining,
  });

  final String? requestId;
  final String response;
  final bool fromCache;
  final AiTutorRateLimit rateLimitRemaining;

  factory AiTutorResponseData.fromJson(Map<String, dynamic> json) =>
      _$AiTutorResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$AiTutorResponseDataToJson(this);
}

class AiTutorMessage {
  const AiTutorMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isError = false,
    this.fromCache = false,
  });

  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isError;

  final bool fromCache;
}
