// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_contest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JoinContestModel _$JoinContestModelFromJson(Map<String, dynamic> json) =>
    JoinContestModel(
      success: json['success'] as bool,
      timestamp: json['timestamp'] as String,
      data: ContestParticipation.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JoinContestModelToJson(JoinContestModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'timestamp': instance.timestamp,
      'data': instance.data,
    };

ContestParticipation _$ContestParticipationFromJson(
  Map<String, dynamic> json,
) => ContestParticipation(
  contestId: json['contestId'] as String,
  userId: json['userId'] as String,
  joinedAt: json['joinedAt'] as String,
  hasStarted: json['hasStarted'] as bool,
  hasCompleted: json['hasCompleted'] as bool,
  startedAt: json['startedAt'] as String?,
  completedAt: json['completedAt'] as String?,
  score: (json['score'] as num?)?.toInt(),
  xpEarned: (json['xpEarned'] as num?)?.toInt(),
  rank: (json['rank'] as num?)?.toInt(),
  id: json['id'] as String,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
  deletedAt: json['deletedAt'] as String?,
);

Map<String, dynamic> _$ContestParticipationToJson(
  ContestParticipation instance,
) => <String, dynamic>{
  'contestId': instance.contestId,
  'userId': instance.userId,
  'joinedAt': instance.joinedAt,
  'hasStarted': instance.hasStarted,
  'hasCompleted': instance.hasCompleted,
  'startedAt': instance.startedAt,
  'completedAt': instance.completedAt,
  'score': instance.score,
  'xpEarned': instance.xpEarned,
  'rank': instance.rank,
  'id': instance.id,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'deletedAt': instance.deletedAt,
};
