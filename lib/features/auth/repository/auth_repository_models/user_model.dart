import 'dart:developer';

class UserModel {
  UserModel({
    this.userName,
    this.email,
    this.isVerified,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    log(json.toString());
    return UserModel(
      userName: json['user']['userName'] as String?,
      email: json['user']['email'] as String?,
      isVerified: json['user']['isVerified'] as bool?,
      lastLoginAt:
          json['user']['lastLoginAt'] == null
              ? null
              : DateTime.parse(json['lastLoginAt'] as String),
      createdAt:
          json['user']['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      updatedAt:
          json['user']['updatedAt'] == null
              ? null
              : DateTime.parse(json['user']['updatedAt'] as String),
    );
  }
  final String? userName;
  final String? email;
  final bool? isVerified;
  final DateTime? lastLoginAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
