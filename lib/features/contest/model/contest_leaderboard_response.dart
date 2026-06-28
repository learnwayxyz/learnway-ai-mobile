import 'package:json_annotation/json_annotation.dart';

part 'contest_leaderboard_response.g.dart';

@JsonSerializable()
class ContestLeaderboardResponse {
  final String contestId;
  final ContestLeaderboardData data;
  final String timestamp;

  ContestLeaderboardResponse({
    required this.contestId,
    required this.data,
    required this.timestamp,
  });

  factory ContestLeaderboardResponse.fromJson(Map<String, dynamic> json) =>
      _$ContestLeaderboardResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ContestLeaderboardResponseToJson(this);
}

@JsonSerializable()
class ContestLeaderboardData {
  final List<ContestLeaderboardParticipant> participants;
  final int total;
  final int limit;
  final int offset;

  ContestLeaderboardData({
    required this.participants,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory ContestLeaderboardData.fromJson(Map<String, dynamic> json) =>
      _$ContestLeaderboardDataFromJson(json);

  Map<String, dynamic> toJson() => _$ContestLeaderboardDataToJson(this);
}

@JsonSerializable()
class ContestLeaderboardParticipant {
  final String userId;
  final String username;
  final String? profileImageUrl;
  final int? rank;
  final int? score;
  final int? xpEarned;
  final bool hasCompleted;
  final DateTime? completedAt;

  ContestLeaderboardParticipant({
    required this.userId,
    required this.username,
    this.profileImageUrl,
    this.rank,
    this.score,
    this.xpEarned,
    required this.hasCompleted,
    this.completedAt,
  });

  factory ContestLeaderboardParticipant.fromJson(Map<String, dynamic> json) =>
      _$ContestLeaderboardParticipantFromJson(json);

  Map<String, dynamic> toJson() => _$ContestLeaderboardParticipantToJson(this);

  /// Helper to check if this participant is the current user
  bool isCurrentUser(String? currentUserId) {
    return currentUserId != null && userId == currentUserId;
  }
}
