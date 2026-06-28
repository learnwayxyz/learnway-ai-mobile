import 'package:json_annotation/json_annotation.dart';

part 'battle_model.g.dart';

@JsonSerializable()
class BattleModel {
  BattleModel({
    required this.id,
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
    required this.createdAt,
    required this.updatedAt,
    required this.participants,
  });

  final String id;
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
  final String createdAt;
  final String updatedAt;
  final List<BattleParticipant> participants;

  factory BattleModel.fromJson(Map<String, dynamic> json) =>
      _$BattleModelFromJson(json);

  Map<String, dynamic> toJson() => _$BattleModelToJson(this);
}

@JsonSerializable()
class BattleParticipant {
  BattleParticipant({
    required this.id,
    required this.battleId,
    required this.userId,
    required this.isBot,
    required this.role,
    required this.stakeLocked,
    required this.stakePaid,
    required this.score,
    required this.xpEarned,
    required this.gemsWon,
    this.position,
    required this.answers,
    required this.forfeited,
    this.connectedAt,
    this.disconnectedAt,
    this.user,
  });

  final String id;
  final String battleId;
  final String userId;
  final bool isBot;
  final ParticipantRole role;
  final bool stakeLocked;
  final bool stakePaid;
  final int score;
  final int xpEarned;
  final int gemsWon;
  final int? position;
  final List<dynamic> answers;
  final bool forfeited;
  final String? connectedAt;
  final String? disconnectedAt;
  final BattleUser? user;

  factory BattleParticipant.fromJson(Map<String, dynamic> json) =>
      _$BattleParticipantFromJson(json);

  Map<String, dynamic> toJson() => _$BattleParticipantToJson(this);
}

@JsonSerializable()
class BattleUser {
  BattleUser({
    required this.id,
    required this.username,
  });

  final String id;
  final String username;

  factory BattleUser.fromJson(Map<String, dynamic> json) =>
      _$BattleUserFromJson(json);

  Map<String, dynamic> toJson() => _$BattleUserToJson(this);
}

@JsonEnum()
enum BattleType {
  @JsonValue('FRIEND')
  friend,
  @JsonValue('GROUP')
  group,
  @JsonValue('BOT')
  bot,
}

@JsonEnum()
enum BattleStatus {
  @JsonValue('WAITING')
  waiting,
  @JsonValue('ACTIVE')
  active,
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('CANCELLED')
  cancelled,
  @JsonValue('EXPIRED')
  expired,
}

@JsonEnum()
enum ParticipantRole {
  @JsonValue('CREATOR')
  creator,
  @JsonValue('CHALLENGER')
  challenger,
  @JsonValue('PLAYER')
  player,
}
