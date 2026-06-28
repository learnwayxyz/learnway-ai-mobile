// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'battle_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BattleHistoryResponse _$BattleHistoryResponseFromJson(
  Map<String, dynamic> json,
) => BattleHistoryResponse(
  items: (json['items'] as List<dynamic>)
      .map((e) => BattleHistoryItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
);

Map<String, dynamic> _$BattleHistoryResponseToJson(
  BattleHistoryResponse instance,
) => <String, dynamic>{
  'items': instance.items,
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
};

BattleHistoryItem _$BattleHistoryItemFromJson(
  Map<String, dynamic> json,
) => BattleHistoryItem(
  id: json['id'] as String,
  type: json['type'] as String,
  outcome: json['outcome'] as String,
  roomCode: json['roomCode'] as String?,
  stakeAmount: (json['stakeAmount'] as num).toInt(),
  prizePool: (json['prizePool'] as num).toInt(),
  completedAt: json['completedAt'] as String?,
  me: BattleHistoryMe.fromJson(json['me'] as Map<String, dynamic>),
  winners: (json['winners'] as List<dynamic>)
      .map((e) => BattleHistoryParticipant.fromJson(e as Map<String, dynamic>))
      .toList(),
  participants: (json['participants'] as List<dynamic>)
      .map((e) => BattleHistoryParticipant.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BattleHistoryItemToJson(BattleHistoryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'outcome': instance.outcome,
      'roomCode': instance.roomCode,
      'stakeAmount': instance.stakeAmount,
      'prizePool': instance.prizePool,
      'completedAt': instance.completedAt,
      'me': instance.me,
      'winners': instance.winners,
      'participants': instance.participants,
    };

BattleHistoryMe _$BattleHistoryMeFromJson(Map<String, dynamic> json) =>
    BattleHistoryMe(
      score: (json['score'] as num).toInt(),
      position: (json['position'] as num?)?.toInt(),
      gemsWon: (json['gemsWon'] as num).toInt(),
      xpEarned: (json['xpEarned'] as num).toInt(),
      forfeited: json['forfeited'] as bool,
    );

Map<String, dynamic> _$BattleHistoryMeToJson(BattleHistoryMe instance) =>
    <String, dynamic>{
      'score': instance.score,
      'position': instance.position,
      'gemsWon': instance.gemsWon,
      'xpEarned': instance.xpEarned,
      'forfeited': instance.forfeited,
    };

BattleHistoryParticipant _$BattleHistoryParticipantFromJson(
  Map<String, dynamic> json,
) => BattleHistoryParticipant(
  userId: json['userId'] as String?,
  username: json['username'] as String,
  profileImageUrl: json['profileImageUrl'] as String?,
  isBot: json['isBot'] as bool,
  score: (json['score'] as num).toInt(),
  xpEarned: (json['xpEarned'] as num).toInt(),
  gemsWon: (json['gemsWon'] as num).toInt(),
  position: (json['position'] as num?)?.toInt(),
  forfeited: json['forfeited'] as bool,
);

Map<String, dynamic> _$BattleHistoryParticipantToJson(
  BattleHistoryParticipant instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'username': instance.username,
  'profileImageUrl': instance.profileImageUrl,
  'isBot': instance.isBot,
  'score': instance.score,
  'xpEarned': instance.xpEarned,
  'gemsWon': instance.gemsWon,
  'position': instance.position,
  'forfeited': instance.forfeited,
};
