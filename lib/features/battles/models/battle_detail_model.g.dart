// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'battle_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BattleDetailModel _$BattleDetailModelFromJson(Map<String, dynamic> json) =>
    BattleDetailModel(
      id: json['id'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      deletedAt: json['deletedAt'] as String?,
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
      participants: (json['participants'] as List<dynamic>)
          .map(
            (e) => BattleDetailParticipant.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      topic: BattleDetailTopic.fromJson(json['topic'] as Map<String, dynamic>),
      creator: BattleDetailCreator.fromJson(
        json['creator'] as Map<String, dynamic>,
      ),
      topicName: json['topicName'] as String,
    );

Map<String, dynamic> _$BattleDetailModelToJson(BattleDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
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
      'participants': instance.participants,
      'topic': instance.topic,
      'creator': instance.creator,
      'topicName': instance.topicName,
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

BattleDetailParticipant _$BattleDetailParticipantFromJson(
  Map<String, dynamic> json,
) => BattleDetailParticipant(
  userId: json['userId'] as String?,
  role: $enumDecode(_$ParticipantRoleEnumMap, json['role']),
  username: json['username'] as String?,
  profileImageUrl: json['profileImageUrl'] as String?,
  score: (json['score'] as num).toInt(),
  position: (json['position'] as num?)?.toInt(),
  gemsWon: (json['gemsWon'] as num).toInt(),
  xpEarned: (json['xpEarned'] as num).toInt(),
  forfeited: json['forfeited'] as bool,
);

Map<String, dynamic> _$BattleDetailParticipantToJson(
  BattleDetailParticipant instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'role': _$ParticipantRoleEnumMap[instance.role]!,
  'username': instance.username,
  'profileImageUrl': instance.profileImageUrl,
  'score': instance.score,
  'position': instance.position,
  'gemsWon': instance.gemsWon,
  'xpEarned': instance.xpEarned,
  'forfeited': instance.forfeited,
};

const _$ParticipantRoleEnumMap = {
  ParticipantRole.creator: 'CREATOR',
  ParticipantRole.challenger: 'CHALLENGER',
  ParticipantRole.player: 'PLAYER',
};

BattleDetailTopic _$BattleDetailTopicFromJson(Map<String, dynamic> json) =>
    BattleDetailTopic(
      id: json['id'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      deletedAt: json['deletedAt'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      status: json['status'] as String,
    );

Map<String, dynamic> _$BattleDetailTopicToJson(BattleDetailTopic instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'title': instance.title,
      'description': instance.description,
      'status': instance.status,
    };

BattleDetailCreator _$BattleDetailCreatorFromJson(Map<String, dynamic> json) =>
    BattleDetailCreator(
      id: json['id'] as String,
      username: json['username'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
    );

Map<String, dynamic> _$BattleDetailCreatorToJson(
  BattleDetailCreator instance,
) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'profileImageUrl': instance.profileImageUrl,
};
