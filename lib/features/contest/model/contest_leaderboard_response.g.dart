// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contest_leaderboard_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContestLeaderboardResponse _$ContestLeaderboardResponseFromJson(
  Map<String, dynamic> json,
) => ContestLeaderboardResponse(
  contestId: json['contestId'] as String,
  data: ContestLeaderboardData.fromJson(json['data'] as Map<String, dynamic>),
  timestamp: json['timestamp'] as String,
);

Map<String, dynamic> _$ContestLeaderboardResponseToJson(
  ContestLeaderboardResponse instance,
) => <String, dynamic>{
  'contestId': instance.contestId,
  'data': instance.data,
  'timestamp': instance.timestamp,
};

ContestLeaderboardData _$ContestLeaderboardDataFromJson(
  Map<String, dynamic> json,
) => ContestLeaderboardData(
  participants: (json['participants'] as List<dynamic>)
      .map(
        (e) =>
            ContestLeaderboardParticipant.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  total: (json['total'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  offset: (json['offset'] as num).toInt(),
);

Map<String, dynamic> _$ContestLeaderboardDataToJson(
  ContestLeaderboardData instance,
) => <String, dynamic>{
  'participants': instance.participants,
  'total': instance.total,
  'limit': instance.limit,
  'offset': instance.offset,
};

ContestLeaderboardParticipant _$ContestLeaderboardParticipantFromJson(
  Map<String, dynamic> json,
) => ContestLeaderboardParticipant(
  userId: json['userId'] as String,
  username: json['username'] as String,
  profileImageUrl: json['profileImageUrl'] as String?,
  rank: (json['rank'] as num?)?.toInt(),
  score: (json['score'] as num?)?.toInt(),
  xpEarned: (json['xpEarned'] as num?)?.toInt(),
  hasCompleted: json['hasCompleted'] as bool,
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$ContestLeaderboardParticipantToJson(
  ContestLeaderboardParticipant instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'username': instance.username,
  'profileImageUrl': instance.profileImageUrl,
  'rank': instance.rank,
  'score': instance.score,
  'xpEarned': instance.xpEarned,
  'hasCompleted': instance.hasCompleted,
  'completedAt': instance.completedAt?.toIso8601String(),
};
