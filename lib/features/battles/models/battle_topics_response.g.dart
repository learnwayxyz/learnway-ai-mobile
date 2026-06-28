// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'battle_topics_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BattleTopic _$BattleTopicFromJson(Map<String, dynamic> json) => BattleTopic(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  status: json['status'] as String,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$BattleTopicToJson(BattleTopic instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'status': instance.status,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
