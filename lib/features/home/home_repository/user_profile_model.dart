import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:learnwayv2/features/account/data/user_account_model.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class BiWeeklyStreak extends Equatable {
  @HiveField(0)
  final int? currentDay;

  @HiveField(1)
  final int? cyclesCompleted;

  @HiveField(2)
  final List<String>? claimDates;

  @HiveField(3)
  final DateTime? nextBonusAt;

  @HiveField(4)
  final bool? recentCompletion;

  const BiWeeklyStreak({
    this.currentDay,
    this.cyclesCompleted,
    this.claimDates,
    this.nextBonusAt,
    this.recentCompletion,
  });

  factory BiWeeklyStreak.fromJson(Map<String, dynamic> json) {
    return BiWeeklyStreak(
      currentDay: json['currentDay'] as int?,
      cyclesCompleted: json['cyclesCompleted'] as int?,
      claimDates: (json['claimDates'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      nextBonusAt: json['nextBonusAt'] != null
          ? DateTime.tryParse(json['nextBonusAt'])
          : null,
      recentCompletion: json['recentCompletion'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentDay': currentDay,
      'cyclesCompleted': cyclesCompleted,
      'claimDates': claimDates,
      'nextBonusAt': nextBonusAt?.toIso8601String(),
      'recentCompletion': recentCompletion,
    };
  }

  @override
  List<Object?> get props => [
    currentDay,
    cyclesCompleted,
    claimDates,
    nextBonusAt,
    recentCompletion,
  ];
}

@HiveType(typeId: 2)
class EarnedBadge extends Equatable {
  @HiveField(0)
  final String? badgeId;

  @HiveField(1)
  final String? tier;

  @HiveField(2)
  final DateTime? earnedAt;

  @HiveField(3)
  final int? gemReward;

  @HiveField(4)
  final bool? isActive;

  @HiveField(5)
  final int? rarityLevel;

  const EarnedBadge({
    this.badgeId,
    this.tier,
    this.earnedAt,
    this.gemReward,
    this.isActive,
    this.rarityLevel,
  });

  factory EarnedBadge.fromJson(Map<String, dynamic> json) {
    return EarnedBadge(
      badgeId: json['badgeId'] as String?,
      tier: json['tier'] as String?,
      earnedAt: json['earnedAt'] != null
          ? DateTime.tryParse(json['earnedAt'])
          : null,
      gemReward: json['gemReward'] as int?,
      isActive: json['isActive'] as bool?,
      rarityLevel: json['rarityLevel'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'badgeId': badgeId,
      'tier': tier,
      'earnedAt': earnedAt?.toIso8601String(),
      'gemReward': gemReward,
      'isActive': isActive,
      'rarityLevel': rarityLevel,
    };
  }

  @override
  List<Object?> get props => [
    badgeId,
    tier,
    earnedAt,
    gemReward,
    isActive,
    rarityLevel,
  ];
}

@HiveType(typeId: 0)
class UserProfileModel extends Equatable {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? username;

  @HiveField(2)
  final String? email;

  @HiveField(3)
  final bool? isEmailVerified;

  @HiveField(4)
  final String? role;

  @HiveField(5)
  final String? country;

  @HiveField(6)
  final String? halfPrivateKey;

  @HiveField(7)
  final String? referralCode;

  @HiveField(8)
  final String? walletAddress;

  @HiveField(9)
  final DateTime? lastLoginAt;

  @HiveField(10)
  final DateTime? createdAt;

  @HiveField(11)
  final DateTime? updatedAt;

  @HiveField(12)
  final String? profileImageUrl;

  @HiveField(13)
  final String? profileImageFileId;

  @HiveField(14)
  final String? profileThumbnailUrl;

  @HiveField(15)
  final int? totalXp;

  @HiveField(16)
  final int? totalGems;

  @HiveField(17)
  final int? totalBadges;

  @HiveField(18)
  final List<String>? badgeList;

  @HiveField(19)
  final int? currentStreak;

  @HiveField(20)
  final int? longestStreak;

  @HiveField(21)
  final int? dailyClaimStreak;

  @HiveField(22)
  final DateTime? nextClaimAt;

  @HiveField(23)
  final BiWeeklyStreak? biWeeklyStreak;

  @HiveField(24)
  final int? weeklyRank;

  @HiveField(25)
  final int? monthlyRank;

  @HiveField(26)
  final int? allTimeRank;

  @HiveField(27)
  final bool? isKycVerified;

  @HiveField(28)
  final DateTime? lastBlockchainSync;

  @HiveField(29)
  final bool? canClaimNow;

  @HiveField(30)
  final DateTime? kycVerifiedAt;

  @HiveField(31)
  final String? signupProvider;

  @HiveField(32)
  final Map<String, List<EarnedBadge>>? earnedBadges;

  @HiveField(33)
  final bool? hasDeviceToken;

  const UserProfileModel({
    this.id,
    this.username,
    this.email,
    this.isEmailVerified,
    this.role,
    this.country,
    this.halfPrivateKey,
    this.referralCode,
    this.walletAddress,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
    this.profileImageUrl,
    this.profileImageFileId,
    this.profileThumbnailUrl,
    this.badgeList,
    this.totalBadges,
    this.totalGems,
    this.totalXp,
    this.currentStreak,
    this.longestStreak,
    this.dailyClaimStreak,
    this.nextClaimAt,
    this.biWeeklyStreak,
    this.weeklyRank,
    this.monthlyRank,
    this.allTimeRank,
    this.isKycVerified,
    this.lastBlockchainSync,
    this.canClaimNow,
    this.kycVerifiedAt,
    this.signupProvider,
    this.earnedBadges,
    this.hasDeviceToken,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    String? halfPrivateKeyValue;
    final halfPrivateKeyRaw = json['halfPrivateKey'];
    if (halfPrivateKeyRaw is String) {
      halfPrivateKeyValue = halfPrivateKeyRaw;
    } else if (halfPrivateKeyRaw is List) {
      halfPrivateKeyValue = jsonEncode(halfPrivateKeyRaw);
    }

    return UserProfileModel(
      id: json['id'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool?,
      role: json['role'] as String?,
      country: json['country'] as String?,
      halfPrivateKey: halfPrivateKeyValue,
      referralCode: json['referralCode'] as String?,
      walletAddress: json['walletAddress'] as String?,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.tryParse(json['lastLoginAt'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      profileImageUrl: json['profileImageUrl'] as String?,
      profileImageFileId: json['profileImageFileId'] as String?,
      profileThumbnailUrl: json['profileThumbnailUrl'] as String?,
      badgeList:
          (json['badgesList'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      totalBadges: json['totalBadges'] as int?,
      totalGems: json['totalGems'] as int?,
      totalXp: json['totalXP'] as int?,
      currentStreak: json['currentStreak'] as int?,
      longestStreak: json['longestStreak'] as int?,
      dailyClaimStreak: json['dailyClaimStreak'] as int?,
      nextClaimAt: json['nextClaimAt'] != null
          ? DateTime.tryParse(json['nextClaimAt'])
          : null,
      biWeeklyStreak: json['biWeeklyStreak'] != null
          ? BiWeeklyStreak.fromJson(
              json['biWeeklyStreak'] as Map<String, dynamic>,
            )
          : null,
      weeklyRank: json['weeklyRank'] != null
          ? int.tryParse(json['weeklyRank'].toString())
          : null,
      monthlyRank: json['monthlyRank'] != null
          ? int.tryParse(json['monthlyRank'].toString())
          : null,
      allTimeRank: json['allTimeRank'] != null
          ? int.tryParse(json['allTimeRank'].toString())
          : null,
      isKycVerified: json['isKycVerified'] as bool?,
      lastBlockchainSync: json['lastBlockchainSync'] != null
          ? DateTime.tryParse(json['lastBlockchainSync'])
          : null,
      canClaimNow: json['canClaimNow'] as bool?,
      kycVerifiedAt: json['kycVerifiedAt'] != null
          ? DateTime.tryParse(json['kycVerifiedAt'])
          : null,
      signupProvider: json['signupProvider'] as String?,
      earnedBadges: json['earnedBadges'] != null
          ? _parseEarnedBadges(json['earnedBadges'] as Map<String, dynamic>)
          : null,
      hasDeviceToken: json['hasDeviceToken'] as bool?,
    );
  }

  static Map<String, List<EarnedBadge>> _parseEarnedBadges(
    Map<String, dynamic> json,
  ) {
    final result = <String, List<EarnedBadge>>{};
    json.forEach((key, value) {
      if (value is List) {
        result[key] = value
            .map((e) => EarnedBadge.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    });
    return result;
  }

  factory UserProfileModel.empty() {
    final now = DateTime.now();
    return UserProfileModel(
      id: '',
      username: '',
      email: '',
      isEmailVerified: false,
      role: 'user',
      country: '',
      halfPrivateKey: '',
      referralCode: '',
      walletAddress: '0x',
      lastLoginAt: now,
      createdAt: now,
      updatedAt: now,
      profileImageUrl: '',
      profileImageFileId: '',
      profileThumbnailUrl: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'isEmailVerified': isEmailVerified,
      'role': role,
      'country': country,
      'halfPrivateKey': halfPrivateKey,
      'referralCode': referralCode,
      'walletAddress': walletAddress,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'profileImageUrl': profileImageUrl,
      'profileImageFileId': profileImageFileId,
      'profileThumbnailUrl': profileThumbnailUrl,
      'badgeList': badgeList,
      'totalBadges': totalBadges,
      'totalGems': totalGems,
      'totalXp': totalXp,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'dailyClaimStreak': dailyClaimStreak,
      'nextClaimAt': nextClaimAt?.toIso8601String(),
      'biWeeklyStreak': biWeeklyStreak?.toJson(),
      'weeklyRank': weeklyRank,
      'monthlyRank': monthlyRank,
      'allTimeRank': allTimeRank,
      'isKycVerified': isKycVerified,
      'lastBlockchainSync': lastBlockchainSync?.toIso8601String(),
      'canClaimNow': canClaimNow,
      'kycVerifiedAt': kycVerifiedAt?.toIso8601String(),
      'signupProvider': signupProvider,
      'earnedBadges': earnedBadges?.map(
        (key, value) => MapEntry(key, value.map((e) => e.toJson()).toList()),
      ),
      'hasDeviceToken': hasDeviceToken,
    };
  }

  @override
  List<Object?> get props => [
    id,
    username,
    email,
    isEmailVerified,
    role,
    country,
    halfPrivateKey,
    referralCode,
    walletAddress,
    lastLoginAt,
    createdAt,
    updatedAt,
    profileImageUrl,
    profileImageFileId,
    profileThumbnailUrl,
    badgeList,
    totalBadges,
    totalGems,
    totalXp,
    currentStreak,
    longestStreak,
    dailyClaimStreak,
    nextClaimAt,
    biWeeklyStreak,
    weeklyRank,
    monthlyRank,
    allTimeRank,
    isKycVerified,
    lastBlockchainSync,
    canClaimNow,
    kycVerifiedAt,
    signupProvider,
    earnedBadges,
    hasDeviceToken,
  ];

  /// Converts UserProfileModel to UserAccountModel
  UserAccountModel toUserAccountModel() {
    return UserAccountModel(
      id: id,
      username: username,
      email: email,
      isEmailVerified: isEmailVerified,
      role: role,
      country: country,
      halfPrivateKey: halfPrivateKey,
      referralCode: referralCode,
      walletAddress: walletAddress,
      lastLoginAt: lastLoginAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      profileImageUrl: profileImageUrl,
      profileImageFileId: profileImageFileId,
      profileThumbnailUrl: profileThumbnailUrl,
      badgeList: badgeList,
      totalBadges: totalBadges,
      totalGems: totalGems,
      totalXp: totalXp,
    );
  }
}

// Generated Hive Adapter
class UserProfileModelAdapter extends TypeAdapter<UserProfileModel> {
  @override
  final int typeId = 0;

  @override
  UserProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfileModel(
      id: fields[0] as String?,
      username: fields[1] as String?,
      email: fields[2] as String?,
      isEmailVerified: fields[3] as bool?,
      role: fields[4] as String?,
      country: fields[5] as String?,
      halfPrivateKey: fields[6] as String?,
      referralCode: fields[7] as String?,
      walletAddress: fields[8] as String?,
      lastLoginAt: fields[9] as DateTime?,
      createdAt: fields[10] as DateTime?,
      updatedAt: fields[11] as DateTime?,
      profileImageUrl: fields[12] as String?,
      profileImageFileId: fields[13] as String?,
      profileThumbnailUrl: fields[14] as String?,
      totalXp: fields[15] as int?,
      totalGems: fields[16] as int?,
      totalBadges: fields[17] as int?,
      badgeList: fields[18] as List<String>?,
      currentStreak: fields[19] as int?,
      longestStreak: fields[20] as int?,
      dailyClaimStreak: fields[21] as int?,
      nextClaimAt: fields[22] as DateTime?,
      biWeeklyStreak: fields[23] as BiWeeklyStreak?,
      weeklyRank: fields[24] as int?,
      monthlyRank: fields[25] as int?,
      allTimeRank: fields[26] as int?,
      isKycVerified: fields[27] as bool?,
      lastBlockchainSync: fields[28] as DateTime?,
      canClaimNow: fields[29] as bool?,
      kycVerifiedAt: fields[30] as DateTime?,
      signupProvider: fields[31] as String?,
      earnedBadges: (fields[32] as Map?)?.cast<String, List<EarnedBadge>>(),
      hasDeviceToken: fields[33] as bool?,
      // fields[34] was dailyLessonsRemaining — read but discarded for backward compat
    );
  }

  @override
  void write(BinaryWriter writer, UserProfileModel obj) {
    writer
      ..writeByte(34)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.isEmailVerified)
      ..writeByte(4)
      ..write(obj.role)
      ..writeByte(5)
      ..write(obj.country)
      ..writeByte(6)
      ..write(obj.halfPrivateKey)
      ..writeByte(7)
      ..write(obj.referralCode)
      ..writeByte(8)
      ..write(obj.walletAddress)
      ..writeByte(9)
      ..write(obj.lastLoginAt)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt)
      ..writeByte(12)
      ..write(obj.profileImageUrl)
      ..writeByte(13)
      ..write(obj.profileImageFileId)
      ..writeByte(14)
      ..write(obj.profileThumbnailUrl)
      ..writeByte(15)
      ..write(obj.totalXp)
      ..writeByte(16)
      ..write(obj.totalGems)
      ..writeByte(17)
      ..write(obj.totalBadges)
      ..writeByte(18)
      ..write(obj.badgeList)
      ..writeByte(19)
      ..write(obj.currentStreak)
      ..writeByte(20)
      ..write(obj.longestStreak)
      ..writeByte(21)
      ..write(obj.dailyClaimStreak)
      ..writeByte(22)
      ..write(obj.nextClaimAt)
      ..writeByte(23)
      ..write(obj.biWeeklyStreak)
      ..writeByte(24)
      ..write(obj.weeklyRank)
      ..writeByte(25)
      ..write(obj.monthlyRank)
      ..writeByte(26)
      ..write(obj.allTimeRank)
      ..writeByte(27)
      ..write(obj.isKycVerified)
      ..writeByte(28)
      ..write(obj.lastBlockchainSync)
      ..writeByte(29)
      ..write(obj.canClaimNow)
      ..writeByte(30)
      ..write(obj.kycVerifiedAt)
      ..writeByte(31)
      ..write(obj.signupProvider)
      ..writeByte(32)
      ..write(obj.earnedBadges)
      ..writeByte(33)
      ..write(obj.hasDeviceToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// Generated Hive Adapter for BiWeeklyStreak
class BiWeeklyStreakAdapter extends TypeAdapter<BiWeeklyStreak> {
  @override
  final int typeId = 1;

  @override
  BiWeeklyStreak read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BiWeeklyStreak(
      currentDay: fields[0] as int?,
      cyclesCompleted: fields[1] as int?,
      claimDates: (fields[2] as List?)?.cast<String>(),
      nextBonusAt: fields[3] as DateTime?,
      recentCompletion: fields[4] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, BiWeeklyStreak obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.currentDay)
      ..writeByte(1)
      ..write(obj.cyclesCompleted)
      ..writeByte(2)
      ..write(obj.claimDates)
      ..writeByte(3)
      ..write(obj.nextBonusAt)
      ..writeByte(4)
      ..write(obj.recentCompletion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BiWeeklyStreakAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// Generated Hive Adapter for EarnedBadge
class EarnedBadgeAdapter extends TypeAdapter<EarnedBadge> {
  @override
  final int typeId = 2;

  @override
  EarnedBadge read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EarnedBadge(
      badgeId: fields[0] as String?,
      tier: fields[1] as String?,
      earnedAt: fields[2] as DateTime?,
      gemReward: fields[3] as int?,
      isActive: fields[4] as bool?,
      rarityLevel: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, EarnedBadge obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.badgeId)
      ..writeByte(1)
      ..write(obj.tier)
      ..writeByte(2)
      ..write(obj.earnedAt)
      ..writeByte(3)
      ..write(obj.gemReward)
      ..writeByte(4)
      ..write(obj.isActive)
      ..writeByte(5)
      ..write(obj.rarityLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EarnedBadgeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
