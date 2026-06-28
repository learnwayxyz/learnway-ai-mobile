import 'package:json_annotation/json_annotation.dart';

part 'referral_reward_response.g.dart';

@JsonSerializable()
class ReferralRewardResponse {
  final ReferralReward? referrerReward;
  final ReferralReward? referredUserReward;

  const ReferralRewardResponse({
    this.referrerReward,
    this.referredUserReward,
  });

  factory ReferralRewardResponse.fromJson(Map<String, dynamic> json) =>
      _$ReferralRewardResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ReferralRewardResponseToJson(this);

  bool get isSuccess =>
      (referrerReward?.gems != null && referrerReward!.gems > 0) ||
      (referredUserReward?.gems != null && referredUserReward!.gems > 0);
}

@JsonSerializable()
class ReferralReward {
  final int gems;
  final String message;

  const ReferralReward({required this.gems, required this.message});

  factory ReferralReward.fromJson(Map<String, dynamic> json) =>
      _$ReferralRewardFromJson(json);
  Map<String, dynamic> toJson() => _$ReferralRewardToJson(this);
}
