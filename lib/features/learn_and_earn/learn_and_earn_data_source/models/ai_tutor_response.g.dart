// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_tutor_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AiTutorRateLimit _$AiTutorRateLimitFromJson(Map<String, dynamic> json) =>
    AiTutorRateLimit(
      lesson: (json['lesson'] as num).toInt(),
      daily: (json['daily'] as num).toInt(),
    );

Map<String, dynamic> _$AiTutorRateLimitToJson(AiTutorRateLimit instance) =>
    <String, dynamic>{'lesson': instance.lesson, 'daily': instance.daily};

AiTutorResponseData _$AiTutorResponseDataFromJson(Map<String, dynamic> json) =>
    AiTutorResponseData(
      requestId: json['requestId'] as String?,
      response: json['response'] as String,
      fromCache: json['fromCache'] as bool,
      rateLimitRemaining: AiTutorRateLimit.fromJson(
        json['rateLimitRemaining'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$AiTutorResponseDataToJson(
  AiTutorResponseData instance,
) => <String, dynamic>{
  'requestId': instance.requestId,
  'response': instance.response,
  'fromCache': instance.fromCache,
  'rateLimitRemaining': instance.rateLimitRemaining.toJson(),
};
