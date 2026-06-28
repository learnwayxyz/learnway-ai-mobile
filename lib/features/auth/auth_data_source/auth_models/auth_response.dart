import 'dart:convert';

class AuthResponse {
  final String? token;
  final String? refreshToken;
  final UserModel? user;

  AuthResponse({
    this.token,
    this.refreshToken,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'accessToken': token,
        'refreshToken': refreshToken,
        'user': user?.toJson(),
      };
}

class UserModel {
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

  UserModel({
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
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle halfPrivateKey which can be either String or List
    String? halfPrivateKeyValue;
    final halfPrivateKeyRaw = json['halfPrivateKey'];
    if (halfPrivateKeyRaw is String) {
      halfPrivateKeyValue = halfPrivateKeyRaw;
    } else if (halfPrivateKeyRaw is List) {
      // Convert List to JSON string
      halfPrivateKeyValue = jsonEncode(halfPrivateKeyRaw);
    }

    return UserModel(
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
    );
  }

  Map<String, dynamic> toJson() => {
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
      };
}
