import 'package:json_annotation/json_annotation.dart';

part 'join_contest_model.g.dart';

@JsonSerializable()
class JoinContestModel {
  JoinContestModel({
    required this.success,
    required this.timestamp,
    required this.data,
  });

  final bool success;
  final String timestamp;
  final ContestParticipation data;

  factory JoinContestModel.fromJson(Map<String, dynamic> json) =>
      _$JoinContestModelFromJson(json);

  Map<String, dynamic> toJson() => _$JoinContestModelToJson(this);
}

@JsonSerializable()
class ContestParticipation {
  ContestParticipation({
    required this.contestId,
    required this.userId,
    required this.joinedAt,
    required this.hasStarted,
    required this.hasCompleted,
    this.startedAt,
    this.completedAt,
    this.score,
    this.xpEarned,
    this.rank,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  final String contestId;
  final String userId;
  final String joinedAt;
  final bool hasStarted;
  final bool hasCompleted;
  final String? startedAt;
  final String? completedAt;
  final int? score;
  final int? xpEarned;
  final int? rank;
  final String id;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  factory ContestParticipation.fromJson(Map<String, dynamic> json) =>
      _$ContestParticipationFromJson(json);

  Map<String, dynamic> toJson() => _$ContestParticipationToJson(this);
}
