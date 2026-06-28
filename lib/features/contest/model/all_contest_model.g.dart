// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_contest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllContestModel _$AllContestModelFromJson(Map<String, dynamic> json) =>
    AllContestModel(
      success: json['success'] as bool,
      timestamp: json['timestamp'] as String,
      data: AllContestData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AllContestModelToJson(AllContestModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'timestamp': instance.timestamp,
      'data': instance.data,
    };

AllContestData _$AllContestDataFromJson(Map<String, dynamic> json) =>
    AllContestData(
      content: (json['content'] as List<dynamic>)
          .map((e) => Contest.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );

Map<String, dynamic> _$AllContestDataToJson(AllContestData instance) =>
    <String, dynamic>{
      'content': instance.content,
      'page': instance.page,
      'limit': instance.limit,
      'totalPages': instance.totalPages,
    };

Contest _$ContestFromJson(Map<String, dynamic> json) => Contest(
  id: json['id'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  deletedAt: json['deletedAt'] as String?,
  title: json['title'] as String?,
  description: json['description'] as String,
  type: $enumDecode(_$ContestTypeEnumMap, json['type']),
  roomCode: json['roomCode'] as String?,
  maxParticipants: (json['maxParticipants'] as num?)?.toInt(),
  entryFee: (json['entryFee'] as num?)?.toInt(),
  totalGemPrize: (json['totalGemPrize'] as num?)?.toInt(),
  prizeDistribution: (json['prizeDistribution'] as List<dynamic>)
      .map((e) => PrizeDistribution.fromJson(e as Map<String, dynamic>))
      .toList(),
  bannerImageUrl: json['bannerImageUrl'] as String?,
  participantCount: (json['participantCount'] as num?)?.toInt(),
  finishedAt: json['finishedAt'] as String?,
  startDate: json['startDate'] as String?,
  endDate: json['endDate'] as String?,
  contestStatus: $enumDecode(_$ContestStatusEnumMap, json['status']),
  userParticipation: json['userParticipation'] == null
      ? null
      : UserParticipation.fromJson(
          json['userParticipation'] as Map<String, dynamic>,
        ),
  userState: json['userStatus'] == null
      ? null
      : UserState.fromJson(json['userStatus'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ContestToJson(Contest instance) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'deletedAt': instance.deletedAt,
  'title': instance.title,
  'description': instance.description,
  'type': _$ContestTypeEnumMap[instance.type]!,
  'roomCode': instance.roomCode,
  'maxParticipants': instance.maxParticipants,
  'entryFee': instance.entryFee,
  'totalGemPrize': instance.totalGemPrize,
  'prizeDistribution': instance.prizeDistribution,
  'bannerImageUrl': instance.bannerImageUrl,
  'participantCount': instance.participantCount,
  'finishedAt': instance.finishedAt,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'userStatus': instance.userState,
  'status': _$ContestStatusEnumMap[instance.contestStatus]!,
  'userParticipation': instance.userParticipation,
};

const _$ContestTypeEnumMap = {
  ContestType.public: 'PUBLIC',
  ContestType.private: 'PRIVATE',
};

const _$ContestStatusEnumMap = {
  ContestStatus.ongoing: 'ONGOING',
  ContestStatus.upcoming: 'UPCOMING',
  ContestStatus.finished: 'FINISHED',
};

PrizeDistribution _$PrizeDistributionFromJson(Map<String, dynamic> json) =>
    PrizeDistribution(
      rankTo: (json['rankTo'] as num).toInt(),
      rankFrom: (json['rankFrom'] as num).toInt(),
      gemPerUser: (json['gemPerUser'] as num).toInt(),
    );

Map<String, dynamic> _$PrizeDistributionToJson(PrizeDistribution instance) =>
    <String, dynamic>{
      'rankTo': instance.rankTo,
      'rankFrom': instance.rankFrom,
      'gemPerUser': instance.gemPerUser,
    };

UserParticipation _$UserParticipationFromJson(Map<String, dynamic> json) =>
    UserParticipation(
      hasStarted: json['hasStarted'] as bool,
      hasCompleted: json['hasCompleted'] as bool,
      joinedAt: json['joinedAt'] as String?,
    );

Map<String, dynamic> _$UserParticipationToJson(UserParticipation instance) =>
    <String, dynamic>{
      'hasStarted': instance.hasStarted,
      'hasCompleted': instance.hasCompleted,
      'joinedAt': instance.joinedAt,
    };

UserState _$UserStateFromJson(Map<String, dynamic> json) => UserState(
  hasCompleted: json['hasCompleted'] as bool,
  hasJoined: json['hasJoined'] as bool,
  hasStarted: json['hasStarted'] as bool,
);

Map<String, dynamic> _$UserStateToJson(UserState instance) => <String, dynamic>{
  'hasJoined': instance.hasJoined,
  'hasStarted': instance.hasStarted,
  'hasCompleted': instance.hasCompleted,
};
