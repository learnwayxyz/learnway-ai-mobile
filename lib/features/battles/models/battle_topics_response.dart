import 'package:json_annotation/json_annotation.dart';

part 'battle_topics_response.g.dart';

@JsonSerializable()
class BattleTopic {
  BattleTopic({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String? description;
  final String status;
  final String createdAt;
  final String updatedAt;

  factory BattleTopic.fromJson(Map<String, dynamic> json) =>
      _$BattleTopicFromJson(json);

  Map<String, dynamic> toJson() => _$BattleTopicToJson(this);
}
