import 'package:json_annotation/json_annotation.dart';
import 'package:learnwayv2/features/battles/models/battle_model.dart';

part 'battle_detail_model.g.dart';

@JsonSerializable()
class BattleDetailModel {
  BattleDetailModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.type,
    required this.status,
    this.roomCode,
    required this.topicId,
    required this.stakeAmount,
    required this.maxParticipants,
    required this.adminFeeRate,
    required this.prizePool,
    required this.adminFeeGems,
    this.questionIds,
    required this.currentQuestionIndex,
    this.questionStartedAt,
    this.startedAt,
    this.completedAt,
    this.expiresAt,
    required this.creatorId,
    this.winnerId,
    required this.participants,
    required this.topic,
    required this.creator,
    required this.topicName,
  });

  final String id;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final BattleType type;
  final BattleStatus status;
  final String? roomCode;
  final String topicId;
  final int stakeAmount;
  final int maxParticipants;
  final String adminFeeRate;
  final int prizePool;
  final int adminFeeGems;
  final List<String>? questionIds;
  final int currentQuestionIndex;
  final String? questionStartedAt;
  final String? startedAt;
  final String? completedAt;
  final String? expiresAt;
  final String creatorId;
  final String? winnerId;
  final List<BattleDetailParticipant> participants;
  final BattleDetailTopic topic;
  final BattleDetailCreator creator;
  final String topicName;

  factory BattleDetailModel.fromJson(Map<String, dynamic> json) =>
      _$BattleDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$BattleDetailModelToJson(this);
}

@JsonSerializable()
class BattleDetailParticipant {
  BattleDetailParticipant({
    this.userId,
    required this.role,
    this.username,
    this.profileImageUrl,
    required this.score,
    this.position,
    required this.gemsWon,
    required this.xpEarned,
    required this.forfeited,
  });

  final String? userId;
  final ParticipantRole role;
  final String? username;
  final String? profileImageUrl;
  final int score;
  final int? position;
  final int gemsWon;
  final int xpEarned;
  final bool forfeited;

  factory BattleDetailParticipant.fromJson(Map<String, dynamic> json) =>
      _$BattleDetailParticipantFromJson(json);

  Map<String, dynamic> toJson() => _$BattleDetailParticipantToJson(this);
}

@JsonSerializable()
class BattleDetailTopic {
  BattleDetailTopic({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.title,
    this.description,
    required this.status,
  });

  final String id;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String title;
  final String? description;
  final String status;

  factory BattleDetailTopic.fromJson(Map<String, dynamic> json) =>
      _$BattleDetailTopicFromJson(json);

  Map<String, dynamic> toJson() => _$BattleDetailTopicToJson(this);
}

@JsonSerializable()
class BattleDetailCreator {
  BattleDetailCreator({
    required this.id,
    required this.username,
    this.profileImageUrl,
  });

  final String id;
  final String username;
  final String? profileImageUrl;

  factory BattleDetailCreator.fromJson(Map<String, dynamic> json) =>
      _$BattleDetailCreatorFromJson(json);

  Map<String, dynamic> toJson() => _$BattleDetailCreatorToJson(this);
}
