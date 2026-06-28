class InviteFriendsModel {
  final String referralCode;
  final int totalReferrals;
  final int gemsEarned;
  final int gemsForReferrer;
  final int gemsForReferee;
  final List<ReferralModel> referrals;
  final bool hasUsedReferralCode;

  const InviteFriendsModel({
    required this.referralCode,
    required this.totalReferrals,
    required this.gemsEarned,
    required this.gemsForReferrer,
    required this.gemsForReferee,
    required this.referrals,
    this.hasUsedReferralCode = false,
  });

  factory InviteFriendsModel.fromJson(Map<String, dynamic> json) {
    return InviteFriendsModel(
      referralCode: json['referralCode'] ?? '',
      totalReferrals: json['totalReferrals'] ?? 0,
      gemsEarned: json['totalBonusEarned'] ?? 0,
      gemsForReferrer: json['gemsForReferrer'] ?? 100,
      gemsForReferee: json['gemsForReferee'] ?? 50,
      referrals:
          (json['referrals'] as List<dynamic>?)
              ?.map((e) => ReferralModel.fromJson(e))
              .toList() ??
          [],
      hasUsedReferralCode: json['hasUsedReferralCode'] ?? false,
    );
  }

  InviteFriendsModel copyWith({bool? hasUsedReferralCode}) {
    return InviteFriendsModel(
      referralCode: referralCode,
      totalReferrals: totalReferrals,
      gemsEarned: gemsEarned,
      gemsForReferrer: gemsForReferrer,
      gemsForReferee: gemsForReferee,
      referrals: referrals,
      hasUsedReferralCode: hasUsedReferralCode ?? this.hasUsedReferralCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'referralCode': referralCode,
      'totalReferrals': totalReferrals,
      'gemsEarned': gemsEarned,
      'gemsForReferrer': gemsForReferrer,
      'gemsForReferee': gemsForReferee,
      'referrals': referrals.map((e) => e.toJson()).toList(),
      'hasUsedReferralCode': hasUsedReferralCode,
    };
  }
}

class ReferralModel {
  final String id;
  final String name;
  final String email;
  final DateTime joinedAt;
  final bool isActive;
  final int gemsEarned;

  const ReferralModel({
    required this.id,
    required this.name,
    required this.email,
    required this.joinedAt,
    required this.isActive,
    required this.gemsEarned,
  });

  factory ReferralModel.fromJson(Map<String, dynamic> json) {
    return ReferralModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      joinedAt: DateTime.tryParse(json['joinedAt'] ?? '') ?? DateTime.now(),
      isActive: json['isActive'] ?? false,
      gemsEarned: json['gemsEarned'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'joinedAt': joinedAt.toIso8601String(),
      'isActive': isActive,
      'gemsEarned': gemsEarned,
    };
  }
}
