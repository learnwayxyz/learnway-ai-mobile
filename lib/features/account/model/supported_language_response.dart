import 'package:json_annotation/json_annotation.dart';

part 'supported_language_response.g.dart';

@JsonSerializable()
class LanguageResponse {
  final bool success;
  final List<Language> data;

  const LanguageResponse({required this.success, required this.data});

  factory LanguageResponse.fromJson(Map<String, dynamic> json) =>
      _$LanguageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageResponseToJson(this);
}

@JsonSerializable()
class Language {
  final String code;
  final String name;
  final String nativeName;
  final String direction;
  final bool isActive;
  final DateTime createdAt;

  const Language({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.direction,
    required this.isActive,
    required this.createdAt,
  });

  factory Language.fromJson(Map<String, dynamic> json) =>
      _$LanguageFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageToJson(this);
}
