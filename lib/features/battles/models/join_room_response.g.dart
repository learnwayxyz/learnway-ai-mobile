// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_room_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JoinRoomResponse _$JoinRoomResponseFromJson(Map<String, dynamic> json) =>
    JoinRoomResponse(
      id: json['id'] as String,
      type: $enumDecode(_$BattleTypeEnumMap, json['type']),
      status: $enumDecode(_$BattleStatusEnumMap, json['status']),
      roomCode: json['roomCode'] as String,
      stakeAmount: (json['stakeAmount'] as num).toInt(),
      maxParticipants: (json['maxParticipants'] as num).toInt(),
      participants: (json['participants'] as List<dynamic>)
          .map((e) => JoinRoomParticipant.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JoinRoomResponseToJson(JoinRoomResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$BattleTypeEnumMap[instance.type]!,
      'status': _$BattleStatusEnumMap[instance.status]!,
      'roomCode': instance.roomCode,
      'stakeAmount': instance.stakeAmount,
      'maxParticipants': instance.maxParticipants,
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

JoinRoomParticipant _$JoinRoomParticipantFromJson(Map<String, dynamic> json) =>
    JoinRoomParticipant(
      userId: json['userId'] as String,
      role: $enumDecode(_$JoinRoomRoleEnumMap, json['role']),
      username: json['username'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
    );

Map<String, dynamic> _$JoinRoomParticipantToJson(
  JoinRoomParticipant instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'role': _$JoinRoomRoleEnumMap[instance.role]!,
  'username': instance.username,
  'profileImageUrl': instance.profileImageUrl,
};

const _$JoinRoomRoleEnumMap = {
  JoinRoomRole.creator: 'CREATOR',
  JoinRoomRole.player: 'PLAYER',
};
