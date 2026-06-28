// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referral_reward_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferralRewardResponse _$ReferralRewardResponseFromJson(
  Map<String, dynamic> json,
) => ReferralRewardResponse(
  referrerReward: json['referrerReward'] == null
      ? null
      : ReferralReward.fromJson(json['referrerReward'] as Map<String, dynamic>),
  referredUserReward: json['referredUserReward'] == null
      ? null
      : ReferralReward.fromJson(
          json['referredUserReward'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$ReferralRewardResponseToJson(
  ReferralRewardResponse instance,
) => <String, dynamic>{
  'referrerReward': instance.referrerReward,
  'referredUserReward': instance.referredUserReward,
};

ReferralReward _$ReferralRewardFromJson(Map<String, dynamic> json) =>
    ReferralReward(
      gems: (json['gems'] as num).toInt(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$ReferralRewardToJson(ReferralReward instance) =>
    <String, dynamic>{'gems': instance.gems, 'message': instance.message};
