// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'battle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BattleModel _$BattleModelFromJson(Map<String, dynamic> json) => BattleModel(
  id: json['id'] as String,
  type: $enumDecode(_$BattleTypeEnumMap, json['type']),
  status: $enumDecode(_$BattleStatusEnumMap, json['status']),
  roomCode: json['roomCode'] as String?,
  topicId: json['topicId'] as String,
  stakeAmount: (json['stakeAmount'] as num).toInt(),
  maxParticipants: (json['maxParticipants'] as num).toInt(),
  adminFeeRate: json['adminFeeRate'] as String,
  prizePool: (json['prizePool'] as num).toInt(),
  adminFeeGems: (json['adminFeeGems'] as num).toInt(),
  questionIds: (json['questionIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  currentQuestionIndex: (json['currentQuestionIndex'] as num).toInt(),
  questionStartedAt: json['questionStartedAt'] as String?,
  startedAt: json['startedAt'] as String?,
  completedAt: json['completedAt'] as String?,
  expiresAt: json['expiresAt'] as String?,
  creatorId: json['creatorId'] as String,
  winnerId: json['winnerId'] as String?,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
  participants: (json['participants'] as List<dynamic>)
      .map((e) => BattleParticipant.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BattleModelToJson(BattleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$BattleTypeEnumMap[instance.type]!,
      'status': _$BattleStatusEnumMap[instance.status]!,
      'roomCode': instance.roomCode,
      'topicId': instance.topicId,
      'stakeAmount': instance.stakeAmount,
      'maxParticipants': instance.maxParticipants,
      'adminFeeRate': instance.adminFeeRate,
      'prizePool': instance.prizePool,
      'adminFeeGems': instance.adminFeeGems,
      'questionIds': instance.questionIds,
      'currentQuestionIndex': instance.currentQuestionIndex,
      'questionStartedAt': instance.questionStartedAt,
      'startedAt': instance.startedAt,
      'completedAt': instance.completedAt,
      'expiresAt': instance.expiresAt,
      'creatorId': instance.creatorId,
      'winnerId': instance.winnerId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'participants': instance.participants,
    };

const _$BattleTypeEnumMap = {
  BattleType.friend: 'FRIEND',
  BattleType.group: 'GROUP',
  BattleType.bot: 'BOT',
};

const _$BattleStatusEnumMap = {
  BattleStatus.waiting: 'WAITING',
  BattleStatus.active: 'ACTIVE',
  BattleStatus.completed: 'COMPLETED',
  BattleStatus.cancelled: 'CANCELLED',
  BattleStatus.expired: 'EXPIRED',
};

BattleParticipant _$BattleParticipantFromJson(Map<String, dynamic> json) =>
    BattleParticipant(
      id: json['id'] as String,
      battleId: json['battleId'] as String,
      userId: json['userId'] as String,
      isBot: json['isBot'] as bool,
      role: $enumDecode(_$ParticipantRoleEnumMap, json['role']),
      stakeLocked: json['stakeLocked'] as bool,
      stakePaid: json['stakePaid'] as bool,
      score: (json['score'] as num).toInt(),
      xpEarned: (json['xpEarned'] as num).toInt(),
      gemsWon: (json['gemsWon'] as num).toInt(),
      position: (json['position'] as num?)?.toInt(),
      answers: json['answers'] as List<dynamic>,
      forfeited: json['forfeited'] as bool,
      connectedAt: json['connectedAt'] as String?,
      disconnectedAt: json['disconnectedAt'] as String?,
      user: json['user'] == null
          ? null
          : BattleUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BattleParticipantToJson(BattleParticipant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'battleId': instance.battleId,
      'userId': instance.userId,
      'isBot': instance.isBot,
      'role': _$ParticipantRoleEnumMap[instance.role]!,
      'stakeLocked': instance.stakeLocked,
      'stakePaid': instance.stakePaid,
      'score': instance.score,
      'xpEarned': instance.xpEarned,
      'gemsWon': instance.gemsWon,
      'position': instance.position,
      'answers': instance.answers,
      'forfeited': instance.forfeited,
      'connectedAt': instance.connectedAt,
      'disconnectedAt': instance.disconnectedAt,
      'user': instance.user,
    };

const _$ParticipantRoleEnumMap = {
  ParticipantRole.creator: 'CREATOR',
  ParticipantRole.challenger: 'CHALLENGER',
  ParticipantRole.player: 'PLAYER',
};

BattleUser _$BattleUserFromJson(Map<String, dynamic> json) =>
    BattleUser(id: json['id'] as String, username: json['username'] as String);

Map<String, dynamic> _$BattleUserToJson(BattleUser instance) =>
    <String, dynamic>{'id': instance.id, 'username': instance.username};
