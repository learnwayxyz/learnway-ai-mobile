import 'package:json_annotation/json_annotation.dart';

part 'battle_history_model.g.dart';

@JsonSerializable()
class BattleHistoryResponse {
  BattleHistoryResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  final List<BattleHistoryItem> items;
  final int total;
  final int page;
  final int limit;

  factory BattleHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$BattleHistoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BattleHistoryResponseToJson(this);
}

@JsonSerializable()
class BattleHistoryItem {
  BattleHistoryItem({
    required this.id,
    required this.type,
    required this.outcome,
    this.roomCode,
    required this.stakeAmount,
    required this.prizePool,
    this.completedAt,
    required this.me,
    required this.winners,
    required this.participants,
  });

  final String id;
  final String type;
  final String outcome;
  final String? roomCode;
  final int stakeAmount;
  final int prizePool;
  final String? completedAt;
  final BattleHistoryMe me;
  final List<BattleHistoryParticipant> winners;
  final List<BattleHistoryParticipant> participants;

  factory BattleHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$BattleHistoryItemFromJson(json);

  Map<String, dynamic> toJson() => _$BattleHistoryItemToJson(this);
}

@JsonSerializable()
class BattleHistoryMe {
  BattleHistoryMe({
    required this.score,
    this.position,
    required this.gemsWon,
    required this.xpEarned,
    required this.forfeited,
  });

  final int score;
  final int? position;
  final int gemsWon;
  final int xpEarned;
  final bool forfeited;

  factory BattleHistoryMe.fromJson(Map<String, dynamic> json) =>
      _$BattleHistoryMeFromJson(json);

  Map<String, dynamic> toJson() => _$BattleHistoryMeToJson(this);
}

@JsonSerializable()
class BattleHistoryParticipant {
  BattleHistoryParticipant({
    this.userId,
    required this.username,
    this.profileImageUrl,
    required this.isBot,
    required this.score,
    required this.xpEarned,
    required this.gemsWon,
    this.position,
    required this.forfeited,
  });

  final String? userId;
  final String username;
  final String? profileImageUrl;
  final bool isBot;
  final int score;
  final int xpEarned;
  final int gemsWon;
  final int? position;
  final bool forfeited;

  factory BattleHistoryParticipant.fromJson(Map<String, dynamic> json) =>
      _$BattleHistoryParticipantFromJson(json);

  Map<String, dynamic> toJson() => _$BattleHistoryParticipantToJson(this);
}
