import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserAccountModel extends Equatable {
  final String? id;
  final String? username;
  final String? email;
  final bool? isEmailVerified;
  final String? role;
  final String? country;
  final String? halfPrivateKey;
  final String? referralCode;
  final String? walletAddress;
  final DateTime? lastLoginAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? profileImageUrl;
  final String? profileImageFileId;
  final String? profileThumbnailUrl;
  final int? totalXp;
  final int? totalGems;
  final int? totalBadges;
  final List<String>? badgeList;

  const UserAccountModel({
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
  });

  factory UserAccountModel.fromJson(Map<String, dynamic> json) {
    // Handle halfPrivateKey which can be either String or List
    String? halfPrivateKeyValue;
    final halfPrivateKeyRaw = json['halfPrivateKey'];
    if (halfPrivateKeyRaw is String) {
      halfPrivateKeyValue = halfPrivateKeyRaw;
    } else if (halfPrivateKeyRaw is List) {
      // Convert List to JSON string
      halfPrivateKeyValue = jsonEncode(halfPrivateKeyRaw);
    }

    return UserAccountModel(
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
    );
  }

  factory UserAccountModel.empty() {
    final now = DateTime.now();
    return UserAccountModel(
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
      totalBadges: 0,
      badgeList: [],
      totalGems: 0,
      totalXp: 0,
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
  ];
}
