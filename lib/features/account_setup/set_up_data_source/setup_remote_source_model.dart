import 'package:variance_dart/variance_dart.dart';

class SetupRemoteSourceModel {
  SetupRemoteSourceModel({
    this.createdAt,
    this.email,
    this.isVerified,
    this.lastLoginAt,
    this.refreshToken,
    this.token,
    this.updatedAt,
    this.userName,
    this.userId,
    this.smartWallet,
  });

  factory SetupRemoteSourceModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;

    return SetupRemoteSourceModel(
      token: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      userId: user?['id'] as String?,
      userName: user?['username'] as String?,
      email: user?['email'] as String?,
      isVerified: user?['isEmailVerified'] as bool?,
      lastLoginAt:
          user?['lastLoginAt'] != null
              ? DateTime.parse(user!['lastLoginAt'] as String)
              : null,
      createdAt:
          user?['createdAt'] != null
              ? DateTime.parse(user!['createdAt'] as String)
              : null,
      updatedAt:
          user?['updatedAt'] != null
              ? DateTime.parse(user!['updatedAt'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'accessToken': token,
    'refreshToken': refreshToken,
    'user': {
      'id': userId,
      'username': userName,
      'email': email,
      'isEmailVerified': isVerified,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    },
  };

  final String? token;
  final String? refreshToken;
  final String? userId;
  final String? userName;
  final String? email;
  final bool? isVerified;
  final SmartWallet? smartWallet;
  final DateTime? lastLoginAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
