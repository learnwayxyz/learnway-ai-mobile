import 'package:json_annotation/json_annotation.dart';
import 'package:learnwayv2/features/battles/models/battle_model.dart';

part 'join_room_response.g.dart';

@JsonSerializable()
class JoinRoomResponse {
  const JoinRoomResponse({
    required this.id,
    required this.type,
    required this.status,
    required this.roomCode,
    required this.stakeAmount,
    required this.maxParticipants,
    required this.participants,
  });

  final String id;
  final BattleType type;
  final BattleStatus status;
  final String roomCode;
  final int stakeAmount;
  final int maxParticipants;
  final List<JoinRoomParticipant> participants;

  factory JoinRoomResponse.fromJson(Map<String, dynamic> json) =>
      _$JoinRoomResponseFromJson(json);

  Map<String, dynamic> toJson() => _$JoinRoomResponseToJson(this);
}

@JsonSerializable()
class JoinRoomParticipant {
  const JoinRoomParticipant({
    required this.userId,
    required this.role,
    required this.username,
    this.profileImageUrl,
  });

  final String userId;
  final JoinRoomRole role;
  final String username;
  final String? profileImageUrl;

  factory JoinRoomParticipant.fromJson(Map<String, dynamic> json) =>
      _$JoinRoomParticipantFromJson(json);

  Map<String, dynamic> toJson() => _$JoinRoomParticipantToJson(this);
}

@JsonEnum()
enum JoinRoomRole {
  @JsonValue('CREATOR')
  creator,
  @JsonValue('PLAYER')
  player,
}
