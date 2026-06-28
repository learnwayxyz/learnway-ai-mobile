import 'package:variance_dart/variance_dart.dart';

class SetUpUserModel {
  SetUpUserModel({
    this.userName,
    this.email,
    this.isVerified,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
    this.smartWallet,
  });
  factory SetUpUserModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    return SetUpUserModel(
      userName: user['username'] as String?,
      email: user['email'] as String?,
      isVerified: user['isEmailVerified'] as bool?,
      lastLoginAt:
          user['lastLoginAt'] == null
              ? null
              : DateTime.parse(user['lastLoginAt'] as String),
      createdAt:
          user['createdAt'] == null
              ? null
              : DateTime.parse(user['createdAt'] as String),
      updatedAt:
          user['updatedAt'] == null
              ? null
              : DateTime.parse(user['updatedAt'] as String),
    );
  }

  final String? userName;
  final String? email;
  final bool? isVerified;
  final SmartWallet? smartWallet;
  final DateTime? lastLoginAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
