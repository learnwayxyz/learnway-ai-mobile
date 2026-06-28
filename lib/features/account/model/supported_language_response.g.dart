// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supported_language_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LanguageResponse _$LanguageResponseFromJson(Map<String, dynamic> json) =>
    LanguageResponse(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => Language.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LanguageResponseToJson(LanguageResponse instance) =>
    <String, dynamic>{'success': instance.success, 'data': instance.data};

Language _$LanguageFromJson(Map<String, dynamic> json) => Language(
  code: json['code'] as String,
  name: json['name'] as String,
  nativeName: json['nativeName'] as String,
  direction: json['direction'] as String,
  isActive: json['isActive'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$LanguageToJson(Language instance) => <String, dynamic>{
  'code': instance.code,
  'name': instance.name,
  'nativeName': instance.nativeName,
  'direction': instance.direction,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt.toIso8601String(),
};
