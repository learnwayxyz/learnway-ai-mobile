import 'package:json_annotation/json_annotation.dart';

part 'all_contest_model.g.dart';

@JsonSerializable()
class AllContestModel {
  AllContestModel({
    required this.success,
    required this.timestamp,
    required this.data,
  });

  final bool success;
  final String timestamp;
  final AllContestData data;

  factory AllContestModel.fromJson(Map<String, dynamic> json) =>
      _$AllContestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AllContestModelToJson(this);
}

@JsonSerializable()
class AllContestData {
  AllContestData({
    required this.content,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  final List<Contest> content;
  final int page;
  final int limit;
  final int totalPages;

  factory AllContestData.fromJson(Map<String, dynamic> json) =>
      _$AllContestDataFromJson(json);

  Map<String, dynamic> toJson() => _$AllContestDataToJson(this);
}

@JsonSerializable()
class Contest {
  Contest({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.title,
    required this.description,
    required this.type,
    this.roomCode,
    required this.maxParticipants,
    required this.entryFee,
    required this.totalGemPrize,
    required this.prizeDistribution,
    this.bannerImageUrl,
    required this.participantCount,
    this.finishedAt,
    required this.startDate,
    required this.endDate,
    required this.contestStatus,
    this.userParticipation,
    this.userState,
  });

  final String? id;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? title;
  final String description;
  final ContestType type;
  final String? roomCode;
  final int? maxParticipants;
  final int? entryFee;
  final int? totalGemPrize;
  final List<PrizeDistribution> prizeDistribution;
  final String? bannerImageUrl;
  final int? participantCount;
  final String? finishedAt;
  final String? startDate;
  final String? endDate;
  @JsonKey(name: 'userStatus')
  final UserState? userState;

  @JsonKey(name: 'status')
  final ContestStatus contestStatus;

  final UserParticipation? userParticipation;

  bool get hasJoined => userParticipation != null;

  factory Contest.fromJson(Map<String, dynamic> json) =>
      _$ContestFromJson(json);

  Map<String, dynamic> toJson() => _$ContestToJson(this);
}

@JsonSerializable()
class PrizeDistribution {
  PrizeDistribution({
    required this.rankTo,
    required this.rankFrom,
    required this.gemPerUser,
  });
  final int rankTo;
  final int rankFrom;
  final int gemPerUser;

  factory PrizeDistribution.fromJson(Map<String, dynamic> json) =>
      _$PrizeDistributionFromJson(json);

  Map<String, dynamic> toJson() => _$PrizeDistributionToJson(this);
}

@JsonEnum()
enum ContestType {
  @JsonValue('PUBLIC')
  public,
  @JsonValue('PRIVATE')
  private,
}

@JsonEnum()
enum ContestStatus {
  @JsonValue('ONGOING')
  ongoing,
  @JsonValue('UPCOMING')
  upcoming,
  @JsonValue('FINISHED')
  finished,
}

@JsonEnum()
enum ContestQuestionType {
  @JsonValue('MULTIPLE_CHOICE')
  multipleChoice,
  @JsonValue('SINGLE_CHOICE')
  singleChoice,
}

@JsonSerializable()
class UserParticipation {
  UserParticipation({
    required this.hasStarted,
    required this.hasCompleted,
    this.joinedAt,
  });

  final bool hasStarted;
  final bool hasCompleted;
  final String? joinedAt;

  factory UserParticipation.fromJson(Map<String, dynamic> json) =>
      _$UserParticipationFromJson(json);

  Map<String, dynamic> toJson() => _$UserParticipationToJson(this);
}

@JsonSerializable()
class UserState {
  UserState({
    required this.hasCompleted,
    required this.hasJoined,
    required this.hasStarted,
  });
  final bool hasJoined;
  final bool hasStarted;
  final bool hasCompleted;
  factory UserState.fromJson(Map<String, dynamic> json) =>
      _$UserStateFromJson(json);

  Map<String, dynamic> toJson() => _$UserStateToJson(this);
}

extension EmptyAllContestData on AllContestData {
  AllContestData get empty =>
      AllContestData(content: [], page: 0, limit: 0, totalPages: 0);
}
